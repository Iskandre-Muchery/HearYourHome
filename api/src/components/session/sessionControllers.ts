import httpStatus from 'http-status-codes';
import createError from 'http-errors';

import db from "../../appDatabase";
import { PartialSession, SessionForgotPasswordDto, SessionRecoverPasswordDto } from "./sessionTypes";
import { buildUserRo } from '../user/userHelpers';
import { decodeSession, encodeSession } from './sessionHelpers';
import nodemailer from 'nodemailer';
import path = require('path');
import { UserRo, UserUpdateDto } from '../user/userTypes';
import { updateUser } from '../user/userControllers';

//tslint:disable-next-line: no-var-requires
const hbs = require('nodemailer-express-handlebars');

const hbsConfig = {
    viewEngine: {
        extName: '.hbs',
        partialsDir: path.join(__dirname, '../../views.'),
        layoutsDir: path.join(__dirname, '../../views'),
        defaultLayout: ''
    },
    viewPath: path.join(__dirname, '../../views'),
    extName: '.hbs'
};

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: { user: 'hearyourhome.dev.testing@gmail.com', pass: 'camesoule'}
});

export async function recoverPassword(payload: SessionRecoverPasswordDto) {
    const decodedSession = decodeSession("HYH:)", payload.token);
    if (decodedSession.type == "valid") {
        const user = await db.user.findUnique({
            where: { email: decodedSession.session.email }
        });
        if (user != null) {
            updateUser(user, {password: payload.password})
        } else {
            throw createError(httpStatus.NOT_FOUND, 'User not found');
        }
        return buildUserRo(user);
    } else {
        throw createError(httpStatus.UNAUTHORIZED, "Invalid token");
    }
}

export async function forgotPassword(payload: SessionForgotPasswordDto) {
    const user = await db.user.findUnique({
        where: { email: payload.email },
    });
    if (user?.password == null) throw createError(httpStatus.NOT_FOUND, 'User not found');
    const userRo = buildUserRo(user);
    await sendResetPasswordEmail(userRo)
    return (userRo);
}

export async function sendResetPasswordEmail(user: UserRo) {

    const userPartialSession: PartialSession = {
        id: user.id,
        email: user.email,
        createdAt: user.createdAt.toString(),
    }
    const token = encodeSession('HYH:)', userPartialSession);
    transporter.use('compile', hbs(hbsConfig));
    const ccValue = 'hearyourhome.dev.testing@gmail.com';
    const email = {
        from: 'Hear Your Home',
        to: user.email,
        subject: "Réinitialisation du mot de passe",
        template: 'forgotPasswordEmail',
        context: { user, token }
    }
    await transporter.sendMail(email).catch(error => {
        throw createError(httpStatus.UNAUTHORIZED, "Unable to send reset password email to address: " + user.email);
    });
}