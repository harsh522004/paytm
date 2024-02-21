const mongoose = require('mongoose');
const { Schema, number } = require('zod');

mongoose.connect('mongodb+srv://harshbutani125:LVieEHRKoS1P3j1F@cluster0.fktefhx.mongodb.net/Paytm');

const userSchema = new mongoose.Schema({
    username: {
        type: String,
        required: true,
        unique: true,
        minLength: 3,
        maxLength: 30,
        lowercase: true,
        trim: true,

    },
    firstname: {
        type: String,
        required: true,
        trim: true,
        maxLength: 50
    },
    lastname: {
        type: String,
        required: true,
        trim: true,
        maxLength: 50
    },
    password: {
        type: String,
        required: true,
        minLength: 6
    }
});

const accountSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', require: true },
    balance: {
        type: Number,
        required: true
    }
});


const User = mongoose.model('user', userSchema);
const Account = mongoose.model('Account', accountSchema);

module.exports = {
    User,
    Account
};