const connect_to_db = require('./db');
const talk = require('./Talk');

module.exports.get_by_tag = (event, context, callback) => {
    context.callbackWaitsForEmptyEventLoop = false;
    console.log('Received event:', JSON.stringify(event, null, 2));

    let body = {};
    if (event.body) {
        try {
            body = JSON.parse(event.body);
        } catch (error) {
            console.error('Error parsing body:', error);
            callback(null, {
                statusCode: 400,
                headers: { 'Content-Type': 'text/plain' },
                body: 'Invalid JSON body'
            });
            return;
        }
    }

    const tags = body.tags; 
    if (!tags || !Array.isArray(tags) || tags.length === 0) {
        callback(null, {
            statusCode: 400,
            headers: { 'Content-Type': 'text/plain' },
            body: 'Tags are null or they are not an array.'
        });
        return;
    }

    if (!body.doc_per_page) {
        body.doc_per_page = 10;
    }
    if (!body.page) {
        body.page = 1;
    }

    connect_to_db().then(() => {
        console.log('=> get_all talks');
        talk.find({ tags: { $in: tags } })
            .sort({ publishedAt: -1 })
            .then(talks => {
                console.log('Talks fetched before removing duplicates:', talks.length);

                // Rimuovi i duplicati
                const uniqueTalks = talks.reduce((acc, talk) => {
                    if (!acc.some(t => t._id === talk._id)) {
                        acc.push(talk);
                    }
                    return acc;
                }, []);

                console.log('Unique talks:', uniqueTalks.length);

                // Applica la paginazione
                const paginatedTalks = uniqueTalks.slice(
                    (body.doc_per_page * (body.page - 1)),
                    (body.doc_per_page * body.page)
                );

                callback(null, {
                    statusCode: 200,
                    body: JSON.stringify(paginatedTalks)
                });
            })
            .catch(err => {
                console.error('Error fetching talks:', err);
                callback(null, {
                    statusCode: err.statusCode || 500,
                    headers: { 'Content-Type': 'text/plain' },
                    body: 'Could not fetch the talks.'
                });
            });
    }).catch(err => {
        console.error('Error connecting to database:', err);
        callback(null, {
            statusCode: 500,
            headers: { 'Content-Type': 'text/plain' },
            body: 'Could not connect to the database.'
        });
    });
};
