import express from 'express';

import users from './user/userRoutes';
import sessions from './session/sessionRoutes';

const router = express.Router();

router.get('/ping', (req, res) => res.send('pong'));

router.use(users);
router.use(sessions);

export default router;
