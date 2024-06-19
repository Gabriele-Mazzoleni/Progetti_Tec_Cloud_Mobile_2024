//importo librerie utili
const { PutObjectCommand, S3Client, HeadObjectCommand } = require("@aws-sdk/client-s3");
const http = require('http'); // or 'https' for https:// URLs
const fs = require('fs');
const mongoose = require('mongoose');
const connect_to_db = require('./db');
const video = require('./video');


// Configura il client S3
const S3_BUCKET_NAME = 's3://tedx-2024-data-mazzoleni-g/Cut_videos/';
const client = new S3Client({});

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
            await client.head_object( Bucket = S3_BUCKET_NAME, Key = s3Key ).promise(); //da verificare se funziona
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

        
        const file = fs.createWriteStream(s3Key);
        const request = http.get(videoUrl, function(response) {
            response.pipe(file);

            // after download completed close filestream
            file.on("finish", () => {
                file.close();
                console.log("Download Completed");
            });
        });

        const params = new PutObjectCommand({
            Bucket: S3_BUCKET_NAME,
            Key: s3Key,
            Body: file
        });

        try {
            const res = await client.send(params);
            console.log(res);
          } catch (err) {
            console.error(err);
          }
        

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