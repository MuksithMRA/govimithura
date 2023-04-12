import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/error_model.dart';

class CropService {
  static final _crops = FirebaseFirestore.instance.collection('crops');
  static Future<QuerySnapshot<Map<String, dynamic>>?> getCropById(
      int id) async {
    QuerySnapshot<Map<String, dynamic>>? documentSnapshot;
    try {
      documentSnapshot = await _crops.where('id', isEqualTo: id).get();
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return documentSnapshot;
  }
}
