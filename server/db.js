const mongoose = require('mongoose');

mongoose.connect('mongodb+srv://harshbutani125:LVieEHRKoS1P3j1F@cluster0.fktefhx.mongodb.net/Paytm');

const userSchema = new mongoose.Schema({
    username: String,
    firstname: String,
    lastname: String,
    password: Number
});


const User = mongoose.model('user', userSchema);

module.exports = {
    User
};