
const connect_to_db = require('./db');

// GET BY WATCH NEXT HANDLER

const watch_next = require('./Watch_next');

module.exports.get_by_watch_next = (event, context, callback) => {
    context.callbackWaitsForEmptyEventLoop = false;//no fz di callback
    console.log('Received event:', JSON.stringify(event, null, 2));
    let body = {}
    if (event.body) {
        body = JSON.parse(event.body)//se non c'è corpo non ,lo estraggo
    }
    // set default
    if (!body.tag) {
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
        watch_next.find({ tags: body.tag })
            .skip((body.doc_per_page * body.page) - body.doc_per_page)
            .limit(body.doc_per_page)
            .then(talks => {
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
