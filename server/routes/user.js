const express = require('express');
const jwt = require('jsonwebtoken');
const userRoute = express.Router();
const { User, Account } = require('../db');
const { signupValidate, signinValidate } = require('../types');
const { authMiddleware } = require('../middleware');
const { JWT_SECRET } = require('../config');

function randomNumber(min, max) {
    return Math.random() * (max - min) + min;
}

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

    await Account.create({
        userId: newUser._id,
        balance: randomNumber(1, 10000),
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

    console.log("Reqest come at end signIn");
    var payload = req.body;
    var username = payload.username;

    var parsedPayload = signinValidate.safeParse(payload);



    if (!parsedPayload.success) {
        return res.status(411).json({
            message: "Error while parsing"
        });
    }

    const findedUser = await User.findOne({ username: username });



    if (findedUser) {
        const userId = findedUser._id;
        const token = jwt.sign({ userId }, JWT_SECRET);

        console.log("token is : ", token);
        return res.status(200).json({
            token: token,
            data: findedUser
        });
    }

});


// update
userRoute.put('/change', authMiddleware, async function (req, res) {

    console.log("back end point hit");
    const { password, firstname, username } = req.body;

    console.log("Incoming Body is : ", req.body);

    if (!password && !firstname && !username) {
        return res.status(411).json({
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
    if (username) {
        userObject.username = username;
    }

    console.log("Data Tobe change is : ", userObject);

    //userId send by AuthMiddleware, which we use here
    const userResponse = await User.updateOne({ _id: req.userId }, userObject);

    if (!userResponse) {
        return res.status(411).json({
            message: "Error While Updating",
        });
    }

    return res.status(200).json({
        message: "User Data Updated!",
    })
});

// get user Data
userRoute.get('/bulk', async function (req, res) {
    const filterName = req.query.filter || "";

    console.log("Quary Name is : ", filterName);



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

        });
    } else {
        return res.status(401).json({
            message: "No User Found!"
        });
    }


});


// get all users
userRoute.get('/allUser', authMiddleware, async function (req, res) {
    var userList = await User.find({});
    if (!userList) {
        res.status(400).json({
            error: "Not able to get all users"
        });

    }
    res.status(200).json({
        userlist: userList,
    });
});


userRoute.get('/userinfo', authMiddleware, async function (req, res) {
    var userId = req.userId;
    const findUser = await User.findById({ _id: userId });
    const accountUser = await Account.findOne({ userId: userId });

    if (!findUser || !accountUser) {
        res.status(401).json({
            error: "Not Find User",
        });
    }
    res.status(200).json({
        userData: findUser,
        accountData: accountUser
    });

});
module.exports = { userRoute };