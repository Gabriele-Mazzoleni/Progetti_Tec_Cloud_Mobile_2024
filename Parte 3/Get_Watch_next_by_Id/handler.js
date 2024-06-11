
const connect_to_db = require('./db');

// GET BY TALK HANDLER

const talk = require('./talk');

module.exports.get_by_id = (event, context, callback) => {
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
            body: 'Could not fetch the talks. Tag is null.'
        })
    }

    if (!body.doc_per_page) {
        body.doc_per_page = 10
    }
    if (!body.page) {
        body.page = 1
    }

    connect_to_db().then(() => {
        console.log('=> get_all talks');
        talk.find({ "_id": body.id })

            /*
             talk.find({ "Related_videos.related_video_ids": body.id }, { 
       "Related_videos.related_video_ids": 1, 
       "Related_videos.related_video_title": 1, 
       "Related_videos.related_presentedBy": 1 
     })*/



            /*talk.aggregate([
                    {
                      $match: { Related_videos: { $elemMatch: { related_video_ids: body.id } } }
                    },
                    {
                      $project: {
                        Related_videos: {
                          $filter: {
                            input: "$Related_videos",
                            as: "video",
                            cond: { $eq: ["$$video.related_video_ids", body.id] }
                          }
                        }
                      }
                    }
                  ])*///This will return an array of documents where each document has a Related_videos
            //field that contains only the element that matches the condition,
            //and includes all fields in that element.


            .then(talks => {
                if (!talks) {
                    throw new Error('Talk not found');
                }
                callback(null, {
                    statusCode: 200,
                    body: JSON.stringify(talks)
                })
            }
            )
            .catch(err =>
                callback(null, {
                    statusCode: err.statusCode || 500,
                    headers: { 'Content-Type': 'text/plain' },
                    body: 'Could not fetch the talks.'
                })
            );
    });
};
