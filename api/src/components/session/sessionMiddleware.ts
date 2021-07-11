import { RequestHandler } from "express";
import httpStatus from 'http-status-codes';
import createError from 'http-errors';
import { DecodeResult, ExpirationStatus, Session } from './sessionTypes';
import { decodeSession, encodeSession, checkExpirationStatus } from './sessionHelpers';

/**
 * Protect the route so only logged users with Jwt can access it.
 * Often combined with other middlewares, to
 * first make sure that userSession is defined before any check
 *
 * @throws 401 - Unauthorized | If the token is incorrect
 */
const jwtMiddleware: RequestHandler = (req, res, next) => {

    const secretKey = "HYH:)"
    const requestHeader = "X-JWT-Token";
    const responseHeader = "X-Renewed-JWT-Token";
    const header = req.header(requestHeader);
    
    if (!header) {
        next(createError(httpStatus.UNAUTHORIZED, `Required ${requestHeader} header not found.`));
        return;
    }

    const decodedSession: DecodeResult = decodeSession(secretKey, header);
    
    if (decodedSession.type === "integrity-error" || decodedSession.type === "invalid-token") {
        next(createError(httpStatus.UNAUTHORIZED, `Failed to decode or validate authorization token. Reason: ${decodedSession.type}.`));
        return;
    }

    const expiration: ExpirationStatus = checkExpirationStatus(decodedSession.session);

    if (expiration === "expired") {
        next(createError(httpStatus.UNAUTHORIZED, `Authorization token has expired. Please create a new authorization token.`));
        return;
    }

    let session: Session;

    if (expiration === "grace") {
        const { token, expires, issued } = encodeSession(secretKey, decodedSession.session);
        session = {
            ...decodedSession.session,
            expires: expires,
            issued: issued
        };

        res.setHeader(responseHeader, token);
    } else {
        session = decodedSession.session;
    }

    res.locals = {
        ...res.locals,
        session: session
    };

    next();
}

export default jwtMiddleware;
