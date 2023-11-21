import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thltuddn01/model/comic_model.dart';

class FirestoreService_booksearch {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ComicModel>> getComicsFromFirebase() async {
    final querySnapshot = await _firestore.collection('books').get();
    return querySnapshot.docs.map((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      String docId = document.id;
      return ComicModel(
        docId, data['name'], data['image'], data['genre']
        // Lấy thông tin từ dữ liệu Firebase và tạo đối tượng ComicModel
      );
    }).toList();
  }
}