const zod = require('zod');

const signupValidate = zod.object({
    username: zod.string(),
    firstname: zod.string(),
    lastname: zod.string(),
    password: zod.string(),

});

const signinValidate = zod.object({
    username: zod.string(),
    password: zod.string(),

});

const transferAmountMiddleware = zod.object({
    to: zod.string(),
    amount: zod.number()
});


module.exports = {
    signupValidate,
    signinValidate,
    transferAmountMiddleware
};