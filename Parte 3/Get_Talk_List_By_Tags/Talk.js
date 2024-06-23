const mongoose = require('mongoose');

const talk_schema = new mongoose.Schema({
    _id: String,
    speakers: String,
    title: String,
    url: String,
    duration: String,
    publishedAt: Date,
}, { collection: 'TedTok_data' });

module.exports = mongoose.model('talk', talk_schema);