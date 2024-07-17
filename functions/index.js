const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.notifyOnRepoChange = functions.firestore
    .document('repositories/{repoId}')
    .onUpdate(async (change, context) => {
        const repo = change.after.data();
        const username = repo.username;

        const subscriptions = await admin.firestore().collection('subscriptions')
            .where('username', '==', username).get();

        const tokens = [];
        subscriptions.forEach(subscription => {
            tokens.push(subscription.data().fcmToken);
        });

        const payload = {
            notification: {
                title: 'Repository Updated',
                body: `${username} has updated a repository.`,
            },
        };

        return admin.messaging().sendToDevice(tokens, payload);
    });