const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationOnSubscribe = functions.firestore
  .document('subscriptions/{subscriptionId}')
  .onCreate(async (snapshot, context) => {
    const subscription = snapshot.data();
    const payload = {
      notification: {
        title: 'Subscribed',
        body: `You have subscribed to ${subscription.username}.`,
      },
    };
    await admin.messaging().sendToDevice(subscription.fcmToken, payload);
  });

exports.sendNotificationOnUnsubscribe = functions.firestore
  .document('subscriptions/{subscriptionId}')
  .onDelete(async (snapshot, context) => {
    const subscription = snapshot.data();
    const payload = {
      notification: {
        title: 'Unsubscribed',
        body: `You have unsubscribed from ${subscription.username}.`,
      },
    };
    await admin.messaging().sendToDevice(subscription.fcmToken, payload);
  });