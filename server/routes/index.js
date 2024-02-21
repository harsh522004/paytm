const express = require('express');

// root Route Handler
const rootRouter = express.Router();
const { userRoute } = require('./user');



// rootRoute handled send all request to userRouter if /user comes
rootRouter.use('/user', userRoute);

module.exports = { rootRouter };