const mongoose = require('mongoose');
const { Schema } = mongoose;

const relatedVideoSchema = new Schema({
  related_video_ids: { type: String, required: true },
  related_video_title: { type: String, required: true },
  related_presentedBy: { type: String, required: true },
}, { collection: 'tedx_data' });


module.exports = mongoose.model('RelatedVideo', relatedVideoSchema);