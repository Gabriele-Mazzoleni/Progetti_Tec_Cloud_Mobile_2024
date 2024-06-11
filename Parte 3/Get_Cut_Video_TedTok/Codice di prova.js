const AWS = require('aws-sdk');
const axios = require('axios');

const s3 = new AWS.S3();
const db = new AWS.DynamoDB.DocumentClient();


//URI BUCKET S3 Cut_Video: s3://tedx-2024-data-mazzoleni-g/Cut_videos

exports.handler = async (event) => {
    const videoId = event.pathParameters.id;

    // Recupera l'URL del video dal database
    const params = {
        TableName: 'VideoURLs',
        Key: { id: videoId }
    };

    let videoUrl;
    try {
        const data = await db.get(params).promise();
        videoUrl = data.Item.url;
    } catch (error) {
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Could not retrieve video URL' }),
        };
    }

    // Scarica il video dall'URL
    let videoBuffer;
    try {
        const response = await axios.get(videoUrl, { responseType: 'arraybuffer' });
        videoBuffer = response.data;
    } catch (error) {
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Could not download video' }),
        };
    }

    // Restituisci il video come risposta
    return {
        statusCode: 200,
        headers: {
            'Content-Type': 'video/mp4', // Assumi che il video sia in formato MP4
        },
        body: videoBuffer.toString('base64'),
        isBase64Encoded: true
    };
};
