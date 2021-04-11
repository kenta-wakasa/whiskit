import * as admin from "firebase-admin";
import * as csvSync from "csv-parse/lib/sync";
import * as fs from "fs";

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript

/// console の プロジェクトの設定からダウンロードできる json ファイルを指定
let serviceAccount = require("./whiskit-web-firebase-adminsdk.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://${serviceAccount.projectId}.firebaseio.com",
});

const firestore = admin.firestore();
