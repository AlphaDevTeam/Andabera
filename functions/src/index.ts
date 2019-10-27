import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const triggerMessage = functions.firestore
  .document('messages/{messageId}')
  .onCreate(async snapshot => {
    const alertMessage = snapshot.data();
    if(alertMessage && alertMessage.title && alertMessage.description){

      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: `${alertMessage.title}`,
          body: `${alertMessage.description}`,
          click_action: 'FLUTTER_NOTIFICATION_CLICK',
          icon: 'your-icon-url',
          sound: 'default'
        }
      };

      if(alertMessage.userUID){
        //console.log("Searching for UID : " + alertMessage.userUID);
        const querySnapshot = await db
          .collection('userX')
          .doc(alertMessage.userUID)
          .collection('deviceTokens')
          .get();
        //console.log("Collection : " + JSON.stringify(querySnapshot));
        const tokens = querySnapshot.docs.map(snap => snap.id);
        //console.log("Array : " + tokens);
        return fcm.sendToDevice(tokens, payload);
      } else if(alertMessage.msgChanel){
        //console.log("Sending to Chanel  : " + alertMessage.msgChanel);
        return fcm.sendToTopic(alertMessage.msgChanel, payload);
      }
      return null;
    }
    return null;
  });
