const express = require('express');

// root Route Handler
const rootRouter = express.Router();
const { userRoute } = require('./user');
const { accountRoute } = require('./account');



// rootRoute handled send all request to userRouter if /user comes
rootRouter.use('/user', userRoute);
rootRouter.use('/account', accountRoute);

module.exports = { rootRouter };