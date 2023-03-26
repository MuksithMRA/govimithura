import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:govimithura/models/insect_model.dart';

class InsectService {
  static final _insects = FirebaseFirestore.instance.collection('insects');
  static Future<QuerySnapshot<Map<String, dynamic>>>? getAllInsects() {
    Future<QuerySnapshot<Map<String, dynamic>>>? querySnapshot;
    try {
      querySnapshot = _insects.get();
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return querySnapshot;
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>?> getInsectById(
      String id) async {
    DocumentSnapshot<Map<String, dynamic>>? documentSnapshot;
    try {
      documentSnapshot = await _insects.doc(id).get();
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return documentSnapshot;
  }

  static Future<bool> addInsect(InsectModel insect) async {
    try {
      getRecentInsect()!.then((value) {
        if (value.docs.isEmpty) {
          insect.id = '1';
        } else {
          insect.id = (int.parse(value.docs[0]['id']) + 1).toString();
        }
        _insects.doc(insect.id).set(insect.toJson());
      });
      return true;
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return false;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>>? getRecentInsect() {
    Future<QuerySnapshot<Map<String, dynamic>>>? querySnapshot;
    try {
      querySnapshot = _insects.orderBy('id', descending: true).limit(1).get();
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return querySnapshot;
  }
}
