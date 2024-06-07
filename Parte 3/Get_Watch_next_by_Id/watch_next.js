const mongoose = require('mongoose');

const watch_next_schema = new mongoose.Schema({
    title: String,
    url: String,
    description: String,
    speakers: String
}, { collection: 'TedTok_data' });

module.exports = mongoose.model('watch_next', watch_next_schema);
