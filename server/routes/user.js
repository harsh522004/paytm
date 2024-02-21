const express = require('express');
const jwt = require('jsonwebtoken');
const userRoute = express.Router();
const { User } = require('../db');
const { signupValidate, signinValidate } = require('../types');
const { authMiddleware } = require('../middleware');
const { JWT_SECRET } = require('../config');



// sign up
userRoute.post('/signup', async function (req, res) {

    // get Data from Body
    var payload = req.body;
    var username = payload.username;
    var firstname = payload.firstname;
    var lastname = payload.lastname;
    var password = payload.password;


    var parsedPayload = signupValidate.safeParse(payload);


    // check validation
    if (!parsedPayload.success) {
        console.log("parsing unsuccessfull");
        return res.status(411).json({
            message: "Email already taken / Incorrect inputs"
        });
    }

    const existingUser = await User.findOne({ username: username });

    if (existingUser) {
        console.log("Existing user Found");
        return res.status(411).json({
            message: "Email already taken / Incorrect inputs"
        });
    }


    // user create
    var newUser = await User.create({
        username: username,
        firstname: firstname,
        lastname: lastname,
        password: password
    });

    console.log("User Created");

    const userId = newUser._id;


    // jwt create
    const token = jwt.sign({ userId }, JWT_SECRET);

    console.log("Token created");


    // response success
    return res.status(200).json({
        message: "User created successfully",
        token: token
    });
});


// sign in
userRoute.post('/signin', async function (req, res) {
    var payload = req.body;
    var username = payload.username;

    var parsedPayload = signinValidate.safeParse(payload);

    if (!parsedPayload.success) {
        return res.status(411).json({
            message: "Error while logging in"
        });
    }

    const findedUser = await User.findOne({ username: username });

    if (findedUser) {
        const userId = findedUser._id;
        const token = jwt.sign({ userId }, JWT_SECRET);
        return res.status(200).json({
            token: token
        });
    }

    return res.status(411).json({
        message: "Error while logging in"
    });


});


// update
userRoute.put('/', authMiddleware, async function (req, res) {
    const { password, firstname, lastname } = req.body;

    if (!password && !firstname && !lastname) {
        res.status(411).json({
            message: "Provide a Data tobe change"
        });
    }

    // create object with new Filed

    const userObject = {};

    if (password) {
        userObject.password = password;
    }
    if (firstname) {
        userObject.firstname = firstname;
    }
    if (lastname) {
        userObject.lastname = lastname;
    }


    console.log("Data Tobe change is : ", userObject);



    //userId send by AuthMiddleware, which we use here
    const userResponse = await User.updateOne({ _id: req.userId }, userObject);

    if (!userResponse) {
        res.status(411).json({
            message: "Error While Updating",
        });
    }

    res.status(200).json({
        message: "User Data Updated!",
    })
});


userRoute.get('/bulk', async function (req, res) {
    const filterName = req.query.filter || "";

    console.log("Quary Name is : ", filterName);

    // const findedUsers = await User.find({
    //     $or: [{
    //         firstname: {
    //             "$regex": filterName,
    //         },
    //         lastname: {
    //             "$regex": filterName,

    //         },
    //     }]
    // }
    // );

    const findedUsers = await User.findOne({
        $or: [
            { firstname: filterName },
            { lastname: filterName }
        ]
    });


    if (findedUsers) {

        console.log("users is :", findedUsers);
        return res.status(200).json({
            user: findedUsers
            // user: findedUsers.map(user => ({

            //     username: user.username,
            //     firstname: user.firstname,
            //     lastname: user.lastname,
            //     _id: user._id

            // }
            // ))
        });
    } else {
        return res.status(401).json({
            message: "No User Found!"
        });
    }


});
module.exports = { userRoute };