import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whiskit/models/user.dart';
import 'package:whiskit/models/whisky.dart';

class WhiskyLogRepository {
  /// [User]と whiskyId から[DocumentReference]を生成する
  static DocumentReference generateDocRef({required User user, required String whiskyId}) {
    return user.ref.collection('WhiskyLog').doc(whiskyId);
  }

  static Future<void> addWhiskyLog(User user, String whiskyId) async {
    await generateDocRef(user: user, whiskyId: whiskyId).set(<String, dynamic>{'createdAt': Timestamp.now()});
  }

  static Future<List<Whisky>> fetchWhiskyLogListByUser(User user) async {
    final snapShot = await user.ref.collection('WhiskyLog').get();
    return Future.wait(snapShot.docs.map((doc) => WhiskyRepository.instance.fetchWhiskyById(doc.id)).toList());
  }
}
