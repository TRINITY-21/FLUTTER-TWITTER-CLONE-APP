const functions = require('firebase-functions');

/// intialize admin sdk
const admin = require('firebase-admin');
admin.initializeApp();

/// sending push notification
/// on which cloud firestore should it listen to?

exports.sendNotification = functions.firestore
    .document('Users/{userId}/notification/{notificationId}')
        .onCreate(async (snapshot, context) => {
        
            try {     
                
            /// context helps us to access the parameter that is not known to us like userId
            /// snapshot helps us to access all the data documents
            
            const notificationDoc = snapshot.data(); // returning all document in the collection

            /// send notification message and title
            const notificationMessage = notificationDoc.message;
            const notificationTitle = notificationDoc.title;

            const userId = context.params.user;

            // get fcmToken
            const userDoc = await admin.firestore().collection('Users').doc(userId).get();
                
            const fcmToken = userDoc.data().fcmToken;
             // create the notification body
            
                const message = {
                    "notification": {                 
                        title: notificationTitle,
                        body: notificationMessage,
                    },

                    token : fcmToken

                }

            /// send the message 
                return admin.messaging().send(message);
                
    
            } catch (error) {
                print(error);
            }

                   
        });