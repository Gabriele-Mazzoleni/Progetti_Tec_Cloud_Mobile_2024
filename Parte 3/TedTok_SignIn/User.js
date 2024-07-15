const mongoose = require('mongoose');

const user_schema = new mongoose.Schema({
    _id: String,
    Mail: String,
    Username: String,
    Password: String
}, { collection: 'TedTok_Log_Ins' });

module.exports = mongoose.model('appUser', user_schema);