// import * as admin from "firebase-admin";

// npm run build をすると index.js が生成される
// デプロイは firebase deploy --only functions
import * as functions from "firebase-functions";

// 公式ref:https://firebase.google.com/docs/functions/firestore-events?hl=ja
export const triggerSample = functions.firestore
  .document("MyCollection/{docId}")
  .onWrite((change, context) => {
    change.after.ref.set(
      {
        name: "kenta",
      },
      { merge: true }
    );
  });

export const helloWorld = functions.https.onRequest((request, response) => {
  response.send("Hello from Firebase!\n\n");
});
