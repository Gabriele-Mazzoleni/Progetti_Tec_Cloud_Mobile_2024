const connect_to_db = require('./db');
const appUser = require('./User');
const mongoose = require('mongoose');

module.exports.sign_in = (event, context, callback) => {
    context.callbackWaitsForEmptyEventLoop = false;
    console.log('Received event:', JSON.stringify(event, null, 2));
    let body = {};
    if (event.body) {
        body = JSON.parse(event.body);
    }

    // Validazione dei dati di input
    if (!body.mail && !body.password && !body.username) {
        return callback(null, {
            statusCode: 400,
            headers: { 'Content-Type': 'text/plain' },
            body: 'Please insert an email, a password and a username.'
        });
    }

    if (!body.mail) {
        return callback(null, {
            statusCode: 400,
            headers: { 'Content-Type': 'text/plain' },
            body: 'Missing email.'
        });
    }

    if (!body.password) {
        return callback(null, {
            statusCode: 400,
            headers: { 'Content-Type': 'text/plain' },
            body: 'Missing Password.'
        });
    }

    if(!body.username){
        return callback(null, {
            statusCode: 400,
            headers: { 'Content-Type': 'text/plain' },
            body: 'Missing Username.'
        });
    }

    connect_to_db().then(() => {
        console.log('=> Accessing user data');
        appUser.findOne({ "Mail": body.mail})
            .then(user => {
                if (user) { //la mail è già nel db
                    console.log('=> Mail is already in use');
                    return callback(null, {
                        statusCode: 404,
                        headers: { 'Content-Type': 'text/plain' },
                        body: 'Mail is already in use.'
                    });
                }
                console.log('=>mail is free', user);
                //codice per inserire il nuovo utente nel db
                const newUser = new appUser({
                    _id: new mongoose.Types.ObjectId().toString(), // Genera un nuovo ID unico
                    Mail: body.mail,
                    Username: body.username,
                    Password: body.password
                    //per un'applicazione a fini commerciali servirebbe eseguire hashing sulla password, ma per i nostri fini va bene così
                });

                newUser.save()
                    .then(() => {
                        console.log('=> New user created');
                        return callback(null, {
                            statusCode: 201,
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({ message: 'User created successfully' })
                        });
                    })  
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
