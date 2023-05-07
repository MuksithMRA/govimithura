import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/error_model.dart';

class CropService {
  static final _crops = FirebaseFirestore.instance.collection('crops');

  static Future<QuerySnapshot<Map<String, dynamic>>?> getCropByName(
      String name) async {
    QuerySnapshot<Map<String, dynamic>>? documentSnapshot;
    try {
      documentSnapshot = await _crops
          .where(
            'name',
            isEqualTo: name[0].toUpperCase() + name.substring(1),
          )
          .get();
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return documentSnapshot;
  }
}
