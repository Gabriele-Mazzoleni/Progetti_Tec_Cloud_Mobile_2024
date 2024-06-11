const AWS = require('aws-sdk');
const axios = require('axios');
const { MongoClient } = require('mongodb');

// Configurazioni
const MONGODB_URI = 'mongodb+srv://<username>:<password>@<cluster-url>/test?retryWrites=true&w=majority';
const DATABASE_NAME = 'your_database';
const COLLECTION_NAME = 'your_collection';
const S3_BUCKET_NAME = 'your_s3_bucket_name';

// Configura il client S3
const s3 = new AWS.S3();

let cachedDb = null;

async function connectToDatabase(uri) {
    if (cachedDb) {
        return cachedDb;
    }
    const client = await MongoClient.connect(uri, { useNewUrlParser: true, useUnifiedTopology: true });
    cachedDb = client.db(DATABASE_NAME);
    return cachedDb;
}

exports.handler = async (event) => {
    const videoId = event.id;
    if (!videoId) {
        return {
            statusCode: 400,
            body: JSON.stringify('ID non fornito')
        };
    }

    const db = await connectToDatabase(MONGODB_URI);
    const collection = db.collection(COLLECTION_NAME);

    const document = await collection.findOne({ _id: videoId });
    if (!document) {
        return {
            statusCode: 404,
            body: JSON.stringify('ID non trovato')
        };
    }

    const videoUrl = document.url;
    if (!videoUrl) {
        return {
            statusCode: 400,
            body: JSON.stringify('URL non trovato nel documento')
        };
    }

    try {
        const response = await axios.get(videoUrl, { responseType: 'arraybuffer' });
        const s3Key = `videos/${videoId}.mp4`;

        const params = {
            Bucket: S3_BUCKET_NAME,
            Key: s3Key,
            Body: response.data
        };

        await s3.putObject(params).promise();

        return {
            statusCode: 200,
            body: JSON.stringify(`Video salvato su S3 con chiave: ${s3Key}`)
        };
    } catch (error) {
        return {
            statusCode: 500,
            body: JSON.stringify(`Errore: ${error.message}`)
        };
    }
};
