// import * as admin from "firebase-admin";

// 手順1: まず functions ディレクトリに入る
// 手順2: npm run build をすると index.js が生成される
// 手順3: デプロイは firebase deploy --only functions
import * as functions from "firebase-functions";

// 公式ref:https://firebase.google.com/docs/functions/firestore-events?hl=ja
export const computeSweet = functions.firestore
  .document("WhiskyCollection/{WhiskyId}/WhiskyReview/{docId}")
  .onWrite(async (snap, context) => {
    // async の追加箇所に注意
    const ref = snap.after.ref;
    const whiskyRef = ref.parent.parent;
    const docs = await ref.parent.get();

    const sweetList = docs.docs.map((e) => e.data()!["sweet"] as number);
    const richList = docs.docs.map((e) => e.data()!["rich"] as number);


    var sweetSum = 0;
    for (const sweet of sweetList) {
      sweetSum += sweet;
    }
    const sweetAverage = sweetSum / sweetList.length;

    var richSum = 0;
    for (const rich of richList) {
      richSum += rich;
    }
    const richAverage = sweetSum / richList.length;

    whiskyRef?.set(
      {
        sweet: sweetAverage,
        rich: richAverage,
      },
      { merge: true }
    );
  });
