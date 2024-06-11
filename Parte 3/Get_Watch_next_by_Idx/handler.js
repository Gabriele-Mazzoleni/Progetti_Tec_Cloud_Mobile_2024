
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
      body: 'Could not fetch the talks. Id is null.'
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
    talk.find({ "_id": body.id }).select('Related_videos -_id')
        .skip((body.doc_per_page * body.page) - body.doc_per_page)
        .limit(body.doc_per_page)
        .then(talks => {
         if (!talks|| talks.lenght===0) {
             throw new Error('Talk not found');
        }
        
          let relatedVideos = talks[0].Related_videos;
          
           // Remove _id from each related video
          relatedVideos = relatedVideos.map(video => {
            const { _id, ...rest } = video.toObject();
            return rest;
          });
        
          callback(null, {
             statusCode: 200,
             headers: { 'Content-Type': 'application/json' },
             body: JSON.stringify(relatedVideos)
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
