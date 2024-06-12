//importo librerie utili
const AWS = require('aws-sdk');
const axios = require('axios');
const mongoose = require('mongoose');
const connect_to_db = require('./db');
const video = require('./video');


// Configura il client S3
const S3_BUCKET_NAME = 's3://tedx-2024-data-mazzoleni-g/Cut_videos/';
const s3 = new AWS.S3();


module.exports.get_cut_video = async (event, context, callback) => {
    context.callbackWaitsForEmptyEventLoop = false;//no fz di callback
    console.log('Received event:', JSON.stringify(event, null, 2));
    
    let body = {}
    if (event.body) {
      body = JSON.parse(event.body)//se non c'è corpo non ,lo estraggo
    }
    // set default
    if (!body.id) {
      callback(null, {
        statusCode: 500,
        headers: { 'Content-Type': 'text/plain' },
        body: 'ID inserito è nullo'
      })
    }
    
    const videoId= body.id;

    try {
        await connect_to_db();
        const document = await video.findOne({ "_id": videoId }).exec();

        if (!document) {
            return callback(null, {
                statusCode: 404,
                body: JSON.stringify('ID non trovato')
            });
        }

        const videoUrl = document.url;
        if (!videoUrl) {
            return callback(null, {
                statusCode: 400,
                body: JSON.stringify('URL non trovato nel documento')
            });
        }

        const s3Key = `videos/${videoId}.mp4`;
        
        //controllo che la chiave non sia già nel bucket
        try {
            await s3.headObject({ Bucket: S3_BUCKET_NAME, Key: s3Key }).promise();
            return callback(null, {
                statusCode: 200,
                body: JSON.stringify(`Video già presente su S3 con chiave: ${s3Key}`)
            });
        } catch (headErr) {
            if (headErr.code !== 'NotFound') {
                throw headErr;
            }
            // Se l'oggetto non è trovato, continuiamo con il download e l'upload
        }

        const response = await axios.get(videoUrl, { responseType: 'arraybuffer' });

        const params = {
            Bucket: S3_BUCKET_NAME,
            Key: s3Key,
            Body: response.data
        };

        await s3.putObject(params).promise();

        return callback(null, {
            statusCode: 200,
            body: JSON.stringify(`Video salvato su S3 con chiave: ${s3Key}`)
        });
    } catch (error) {
        return callback(null, {
            statusCode: 500,
            body: JSON.stringify(`Errore: ${error.message}`)
        });
    }
};