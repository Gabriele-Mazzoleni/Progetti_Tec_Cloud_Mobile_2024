const mongoose = require('mongoose');
const Talk = require('./models/Talk');

const mongoUri = 'mongodb+srv://<username>:<password>@cluster0.mongodb.net/test?retryWrites=true&w=majority';

mongoose.connect(mongoUri, { useNewUrlParser: true, useUnifiedTopology: true });

exports.handler = async (event) => {
  try {
    const talkId = event.id;

    // Verifica che l'ID sia fornito
    if (!talkId) {
      return {
        statusCode: 400,
        body: JSON.stringify({ message: 'ID is required' }),
      };
    }

    // Recupera il documento dal database
    const talk = await Talk.findById(talkId);

    if (!talk) {
      return {
        statusCode: 404,
        body: JSON.stringify({ message: 'Talk not found' }),
      };
    }

    // Estrae i RelatedVideos
    const relatedVideos = talk.Related_videos;

    return {
      statusCode: 200,
      body: JSON.stringify(relatedVideos),
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: err.message }),
    };
  } finally {
    mongoose.connection.close();
  }
};
