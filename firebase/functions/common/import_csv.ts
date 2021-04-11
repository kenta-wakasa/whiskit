import * as admin from "firebase-admin";
import * as csvSync from "csv-parse/lib/sync";
import * as fs from "fs";
// import serviceAccount from "./service_account.json";

/// csv ファイルを Firestore に import
/// 参考：https://orangelog.site/firebase/firestore-csv-import/
createCollection("./common/sample.csv", "collection");
addDocument("sample", {
  name: "puipui",
  createdAt: admin.firestore.FieldValue.serverTimestamp(),
});

/// Collection に Document を追加するサンプル
async function addDocument(
  collectionName: string,
  object: { [key: string]: any }
) {
  const firestore = admin.firestore();
  const ref = firestore.collection(collectionName);
  try {
    const ret = await ref.doc().set(object);
    console.log("success");
    console.log(ret);
  } catch (error) {
    console.log("Failed", error);
  }
}

/// csv を import して collection を生成する。
///
/// csv は次の形式で用意する。
///
/// _id, fieldName01, fieldName02, ...
///  id,      data01,      data02, ...
///
/// id がブランクの場合は自動生成の id が適用される。
async function createCollection(csvFilePath: string, collectionName: string) {
  const serviceAccount = require("../service_account.json");
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://${serviceAccount.projectId}.firebaseio.com",
  });
  const data = fs.readFileSync(csvFilePath); //csvファイルの読み込み
  const responses: any = csvSync(data); //parse csv
  const objects: { [key: string]: any }[] = []; //この配列の中にパースしたcsvの中身をkey-value形式で入れていく。

  /// 一段目から fieldName を取得する
  for (const response of responses) {
    const object: { [key: string]: any } = {};
    for (let index = 0; index < responses[0].length; index++) {
      object[responses[0][index] as string] = response[index];
    }
    objects.push(object);
  }

  /// 一段目はヘッダーのため削除する
  objects.shift();

  const firestore = admin.firestore();
  firestore.runTransaction(async function (transaction) {
    try {
      for (const object of objects) {
        // _id が空じゃない場合はそのidで生成する
        if (object["_id"] != "") {
          let id = object["_id"];
          delete object._id;
          transaction.set(firestore.collection(collectionName).doc(id), object);
        }
        // _id がからの場合は id を生成する
        else {
          delete object._id;
          transaction.set(firestore.collection(collectionName).doc(), object);
        }
      }
      console.log("success");
    } catch (error) {
      console.log("Failed", error);
    }
  });
}
