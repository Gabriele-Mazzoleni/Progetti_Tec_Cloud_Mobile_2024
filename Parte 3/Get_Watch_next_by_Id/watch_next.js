const mongoose = require('mongoose');
const { Schema } = mongoose;

const relatedVideoSchema = new Schema({
    TalkId: { type: String, required: true },
    speakers: { type: String, required: true },
    title: { type: String, required: true },
    url: { type: String, required: true },
    tags: { type: [String], required: true },
    Related_videos: { type:  new Schema({
        related_video_ids: { type: String, required: true },
        related_video_title: { type: String, required: true },
        related_presentedBy: { type: String, required: true },
      }), required: true },
}, { collection: 'tedx_data' });


module.exports = mongoose.model('RelatedVideo', relatedVideoSchema);