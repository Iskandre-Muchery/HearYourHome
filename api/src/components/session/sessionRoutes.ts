import express from 'express';
import handler from 'express-async-handler';
import httpStatus from 'http-status-codes';

import jwtMiddleware from './sessionMiddleware';
import validate from '../../middlewares/validationMiddleware';
import * as controllers from './sessionControllers';

import { SessionForgotPasswordDto, SessionRecoverPasswordDto } from './sessionTypes';

const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Session
 *   description: The users managing API
 */

/**
 * @swagger
 * components:
 *   schemas:
 *     SessionForgotPasswordDto:
 *       type: object
 *       required:
 *         - email
 *       properties:
 *         email:
 *           type: string
 *           description: user's email address
 *       example:
 *         email: vincent.vega@gmail.com
 */

/**
 * @swagger
 * /sessions/forgotpassword:
 *   post:
 *     summary: Recover user password
 *     tags: [Session]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/SessionForgotPasswordDto'
 *     responses:
 *       200:
 *         description: The user user password has been sent
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UserRo'
 *       400:
 *         description: The request is not valid
 */

router.post(
    '/sessions/forgotpassword',
    validate(SessionForgotPasswordDto),
    handler(async (req, res) => {
        const user = await controllers.forgotPassword(req.body);
        res.send(user);
    })
)

router.post(
    '/sessions/recoverpassword',
    validate(SessionRecoverPasswordDto),
    handler(async (req, res) => {
        const user = await controllers.recoverPassword(req.body);
        res.send(user);
    })
)

export default router;