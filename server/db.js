const mongoose = require('mongoose');

mongoose.connect("mongodb+srv://harshbutani125:LVieEHRKoS1P3j1F@cluster0.fktefhx.mongodb.net/Paytm");

const userSchema = new mongoose.Schema({
    username: String,
    firstname: String,
    lastname: String,
    password: String
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