const mongoose = require('mongoose');
const { Schema } = mongoose;

const relatedVideoSchema = new Schema({
  related_video_ids: { type: String, required: true },
  related_video_title: { type: String, required: true },
  related_presentedBy: { type: String, required: true },
});

const talkSchema = new Schema({
  _id: { type: String, required: true },
  slug: { type: String, required: true },
  speakers: { type: String, required: true },
  title: { type: String, required: true },
  url: { type: String, required: true },
  description: { type: String, required: true },
  duration: { type: String, required: true },
  publishedAt: { type: Date, required: true },
  tags: { type: [String], required: true },
  imageUrl: { type: String, required: true },
  Related_videos: { type: [relatedVideoSchema], required: true },
});

const Talk = mongoose.model('Talk', talkSchema);

module.exports = Talk;
