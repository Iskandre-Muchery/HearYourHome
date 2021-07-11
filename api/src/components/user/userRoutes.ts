import express from 'express';
import handler from 'express-async-handler';
import httpStatus from 'http-status-codes';

import authMiddleware from '../../middlewares/authMiddleware';
import adminMiddleware from '../../middlewares/adminMiddleware';
import ownershipMiddleware from '../../middlewares/ownershipMiddleware';
import validate from '../../middlewares/validationMiddleware';

import * as controllers from './userControllers';
import userMiddleware from './userMiddleware';
import { UserSignupDto, UserSigninDto, UserUpdateDto } from './userTypes';

const router = express.Router();

/**
 * @swagger
 * components:
 *   schemas:
 *     User:
 *       type: object
 *       required:
 *         - id
 *         - email
 *         - password
 *       properties:
 *         id:
 *           type: string
 *           description: user's id
 *         email:
 *           type: string
 *           description: user's email address
 *         username:
 *           type: string
 *           description: user's username
 *         firstName:
 *           type: string
 *           description: user's first name
 *         lastName:
 *           type: string
 *           description: user's last name
 *         password:
 *           type: string
 *           description: user's password
 *         address:
 *           type: string
 *           description: user's address
 *         country:
 *           type: string
 *           description: user's country
 *         isGuarantor:
 *           type: boolean
 *           description: Is he a guarantor or a client?
 *         createdAt:
 *           type: date-time
 *           description: user's account creation date
 *         role:
 *           type: string
 *           description: user's status
 *           enum:
 *             - USER
 *             - ADMIN
 *       example:
 *         id: ckpbb8u1i000456j36dsrvq3y
 *         email: vincent.vega@gmail.com
 *         username: vvega
 *         firstname: Vincent
 *         lastname: Vega
 *         password: password
 *         address: Butch Coolidge's apartment, Los Angeles,
 *         country: United States
 *         isGuarantor: False
 *         createdAt: 018-03-20T09:12:28Z
 *         role: ADMIN
 */

/**
 * @swagger
 * tags:
 *   name: Users
 *   description: The users managing API
 */

/**
 * @swagger
 * /users:
 *   get:
 *     summary: Returns the list of all the users
 *     tags: [Users]
 *     responses:
 *       200:
 *         description: The list of the users
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/UserRo'
 */

router.get(
  '/users',
  adminMiddleware,
  handler(async (req, res) => {
    const users = await controllers.listUsers();
    res.send(users);
  }),
);

/**
 * @swagger
 * /users/{userId}:
 *   get:
 *     summary: Get the user by id
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: userId
 *         schema:
 *           type: string
 *         required: true
 *         description: The user id
 *     responses:
 *       200:
 *         description: The user description by id
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/User'
 *       404:
 *         description: The user was not found
 */

 router.get(
  '/users/:userId',
  ownershipMiddleware,
  userMiddleware,
  handler(async (req, res) => {
    const user = await controllers.getUser(res.locals.user);
    res.send(user);
  }),
);

/**
 * @swagger
 * components:
 *   schemas:
 *     UserSignupDto:
 *       type: object
 *       required:
 *         - email
 *         - password
 *       properties:
 *         email:
 *           type: string
 *           description: user's email address
 *         username:
 *           type: string
 *           description: user's username
 *         password:
 *           type: string
 *           description: user's password
 *       example:
 *         email: vincent.vega@gmail.com
 *         username: vvega
 *         password: password
 */

/**
 * @swagger
 * components:
 *   schemas:
 *     UserRo:
 *       type: object
 *       required:
 *         - email
 *       properties:
 *         id:
 *           type: string
 *           description: user's id
 *         email:
 *           type: string
 *           description: user's email address
 *         username:
 *           type: string
 *           description: user's username
 *         createdAt:
 *           type: date-time
 *           description: user's account creation date
 *         role:
 *           type: string
 *           description: user's status
 *           enum:
 *             - USER
 *             - ADMIN
 *       example:
 *         id: ckpbb8u1i000456j36dsrvq3y
 *         email: vincent.vega@gmail.com
 *         username: vvega
 *         createdAt: 018-03-20T09:12:28Z
 *         role: ADMIN
 */

/**
 * @swagger
 * /users/signup:
 *   post:
 *     summary: Create a new user
 *     tags: [Users]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/UserSignupDto'
 *     responses:
 *       201:
 *         description: The user was successfully created
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UserRo'
 *       400:
 *         description: The request is not valid
 *       409:
 *         description: user already exists
 */

router.post(
  '/users/signup',
  validate(UserSignupDto),
  handler(async (req, res) => {
    const user = await controllers.signup(req.body);
    res.status(httpStatus.CREATED).send(user);
  }),
);

/**
 * @swagger
 * components:
 *   schemas:
 *     UserSigninDto:
 *       type: object
 *       required:
 *         - email
 *         - password
 *       properties:
 *         email:
 *           type: string
 *           description: user's email address
 *         password:
 *           type: string
 *           description: user's password
 *       example:
 *         email: vincent.vega@gmail.com
 *         password: password
 */

/**
 * @swagger
 * /users/signin:
 *   post:
 *     summary: connect the user
 *     tags: [Users]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/UserSigninDto'
 *     responses:
 *       200:
 *         description: The user was successfully connected
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UserRo'
 *       500:
 *         description: Some server error
 *       401:
 *         description: Unauthorized password
 */

router.post(
  '/users/signin',
  validate(UserSigninDto),
  handler(async (req, res) => {
    const user = await controllers.signin(req.body);
    req.session.user = {
      id: user.id,
      role: user.role,
    };
    res.send(user);
  }),
);

/**
 * @swagger
 * /users/signout:
 *   post:
 *     summary: disconnect the user
 *     tags: [Users]
 *     responses:
 *       204:
 *         description: The user was successfully disconnected
 *       401:
 *         description: The user is not logged in
 *       500:
 *         description: Some server error
 */

router.post(
  '/users/signout',
  authMiddleware,
  handler(async (req, res) => {
    await new Promise<void>((resolve, reject) => {
      req.session.destroy((err) => {
        if (err) {
          reject(err);
        } else {
          resolve();
        }
      });
    });
    res.sendStatus(httpStatus.NO_CONTENT);
  }),
);

/**
 * @swagger
 * components:
 *   schemas:
 *     UserUpdateDto:
 *       type: object
 *       properties:
 *         email:
 *           type: string
 *           description: user's email address
 *         username:
 *           type: string
 *           description: user's username
 *         password:
 *           type: string
 *           description: user's password
 *       example:
 *         email: vincent.vega@gmail.com
 *         username: vvega
 *         password: password
 */

/**
 * @swagger
 * /users/{userId}:
 *   patch:
 *     summary: Change some user information
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: userId
 *         schema:
 *           type: string
 *         required: true
 *         description: The user id
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/UserUpdateDto'
 *     responses:
 *       200:
 *         description: The user is up to date
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UserRo'
 *       404:
 *         description: The user was not found
 */

router.patch(
  '/users/:userId',
  validate(UserUpdateDto),
  ownershipMiddleware,
  userMiddleware,
  handler(async (req, res) => {
    const user = await controllers.updateUser(res.locals.user, req.body);
    res.send(user);
  }),
);

/**
 * @swagger
 * /users/{userId}:
 *   delete:
 *     summary: Delete a user account
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: userId
 *         schema:
 *           type: string
 *         required: true
 *         description: The user id
 *     responses:
 *       204:
 *         description: The user was successfully deleted
 *       404:
 *         description: The user was not found
 */

router.delete(
  '/users/:userId',
  ownershipMiddleware,
  userMiddleware,
  handler(async (req, res) => {
    await controllers.deleteUser(res.locals.user);
    res.sendStatus(httpStatus.NO_CONTENT);
  }),
);

export default router;
