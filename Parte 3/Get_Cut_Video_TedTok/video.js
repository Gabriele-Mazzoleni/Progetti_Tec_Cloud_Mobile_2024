const mongoose = require('mongoose');

const video_schema = new mongoose.Schema({
  _id: String,
  url: String
}, { collection: 'TedTok_data' });

module.exports = mongoose.model('talk', video_schema);