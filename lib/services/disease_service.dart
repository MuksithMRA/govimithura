import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/error_model.dart';

class DiseaseService {
  static final _leafs = FirebaseFirestore.instance.collection('leafs');

  static Future<QuerySnapshot<Map<String, dynamic>>?> getLeafsById(
      int id) async {
    QuerySnapshot<Map<String, dynamic>>? documentSnapshot;
    try {
      documentSnapshot = await _leafs.where('id', isEqualTo: id).get();
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return documentSnapshot;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>?> getDiseaseById(
      String leafRef, int id) async {
    QuerySnapshot<Map<String, dynamic>>? documentSnapshot;
    try {
      documentSnapshot = await _leafs
          .doc(leafRef)
          .collection("diseases")
          .where('id', isEqualTo: id)
          .get();
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return documentSnapshot;
  }
}
