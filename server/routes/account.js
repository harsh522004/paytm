const express = require("express");
const accountRoute = express.Router();

const { authMiddleware } = require('../middleware');
const { Account, User } = require("../db");
const { transferAmountMiddleware } = require("../types");
const { default: mongoose } = require("mongoose");

accountRoute.get('/balance', authMiddleware, async function (req, res) {

    console.log("Request Comes to /balance end");
    const userId = req.userId;

    const response = await Account.findOne({ userId: userId });

    console.log("Response getting");

    if (!response) {
        return res.status(411).json({
            message: "Not Able to get Balance"
        });
    }

    return res.status(200).json({
        balance: response.balance
    });


});


accountRoute.post('/transfer', authMiddleware, async function (req, res) {

    // create new session
    const session = await mongoose.startSession();

    // start Transaction phase


    // get body
    const paylod = req.body;
    const parsedPayload = transferAmountMiddleware.safeParse(paylod);

    // if types if input is incorrect
    if (!parsedPayload.success) {
        return res.status(411).json({
            message: "Invalid Input"
        });

    }

    session.startTransaction();
    try {

        // get body
        const transferAmount = paylod.amount;
        const to = paylod.to;
        const userId = req.userId;

        // get account data of sender
        const accountDetail = await Account.findOne({
            userId: userId
        }).session(session);

        // current balance of sender
        const currentBalance = accountDetail.balance;

        // make sure there is sufficient balance
        if (currentBalance < transferAmount) {
            await session.abortTransaction();
            return res.status(400).json({
                message: "Insufficient balance"
            });
        }


        // decrese current balance from sender side


        const toAccount = await Account.findOne({
            userId: to
        }).session(session);

        if (!toAccount) {
            await session.abortTransaction();
            return res.status(400).json({
                message: "Invalid account"
            });
        }

        const currentReciverBalance = toAccount.balance;

        await Account.updateOne(accountDetail, { balance: (currentBalance - transferAmount) }).session(session);
        await Account.updateOne(toAccount, { balance: currentReciverBalance + transferAmount }).session(session);

        await session.commitTransaction();
        // Done
        return res.status(200).json({
            message: "Transfer Successfull"
        });


    } catch (error) {
        console.error("Error during transfer:", error);
        await session.abortTransaction();
        return res.status(500).json({
            message: "Internal Server Error"
        });
    }


});




module.exports = { accountRoute };