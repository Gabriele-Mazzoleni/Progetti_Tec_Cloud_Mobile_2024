const connect_to_db = require('./db');
const talk = require('./User');

module.exports.log_in = (event, context, callback) => {
    context.callbackWaitsForEmptyEventLoop = false;
    console.log('Received event:', JSON.stringify(event, null, 2));
    let body = {};
    if (event.body) {
        body = JSON.parse(event.body);
    }

    // Validazione dei dati di input
    if (!body.mail && !body.password) {
        return callback(null, {
            statusCode: 400,
            headers: { 'Content-Type': 'text/plain' },
            body: 'Please insert an email and password.'
        });
    }

    if (!body.mail) {
        return callback(null, {
            statusCode: 400,
            headers: { 'Content-Type': 'text/plain' },
            body: 'Missing email.'
        });
    }

    if (!body.mail) {
        return callback(null, {
            statusCode: 400,
            headers: { 'Content-Type': 'text/plain' },
            body: 'Missing Password.'
        });
    }

    connect_to_db().then(() => {
        console.log('=> Accessing user data');
        appUser.findOne({ "Mail": body.mail, "Password": body.password })
            .then(user => {
                if (!user) {
                    console.log('=> User not found');
                    return callback(null, {
                        statusCode: 404,
                        headers: { 'Content-Type': 'text/plain' },
                        body: 'User not found.'
                    });
                }
                console.log('=> User found:', user);
                callback(null, {
                    statusCode: 200,
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({"Message": "Success", "Mail": user.Mail, "Username": user.Username, "Password": user.Password})
                });
            })
            .catch(err => {
                console.error('Database query failed:', err);
                callback(null, {
                    statusCode: 500,
                    headers: { 'Content-Type': 'text/plain' },
                    body: 'Could not fetch the user. ' + err.message
                });
            });
    }).catch(err => {
        console.error('Database connection failed:', err);
        callback(null, {
            statusCode: 500,
            headers: { 'Content-Type': 'text/plain' },
            body: 'Database connection failed. ' + err.message
        });
    });
};
