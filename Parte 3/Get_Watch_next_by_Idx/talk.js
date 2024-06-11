const mongoose = require('mongoose');

const watch_next_schema = new mongoose.Schema({
  _id: String,
  Related_videos: [{
    related_video_ids: String,
    related_video_title: String,
    related_presentedBy: String
  }]

}, { collection: 'MyTedx_data' });

module.exports = mongoose.model('talk', watch_next_schema);
