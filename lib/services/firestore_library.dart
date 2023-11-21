import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService_library {
  // Get collection of notes
  final CollectionReference libraries = 
      FirebaseFirestore.instance.collection('libraries');

  // CREATE: add a new note
  Future<void> addLibrary(String userId, String storyId, String storyName, String storyImage, String storyGenre) {
    return libraries.add({
      'userId': userId,
      'storyId': storyId,
      'storyName': storyName,
      'storyImage': storyImage,
      'storyGenre': storyGenre,
      'timestamp': Timestamp.now(),
    });
  }

  // READ: get notes from database
  Stream<QuerySnapshot> getLibrariesStream(String userId) {
    final librariesStream = libraries
      .where('userId', isEqualTo: userId)
      .orderBy('timestamp', descending: true)
      .snapshots();
    
    return librariesStream;
  }

  // // UPDATE: update notes given a doc id
  // Future<void> updateLibrary(String userId, String storyId, String newComment) async {
  //   final querySnapshot = await libraries
  //     .where('userId', isEqualTo: userId)
  //     .where('storyId', isEqualTo: storyId)
  //     .get();

  //   for (final doc in querySnapshot.docs) {
  //     await libraries.doc(doc.id).update({
  //       'text': newComment,
  //       'timestamp': Timestamp.now(),
  //     });
  //   }
  // }

  // DELETE: delete notes given a doc id
  Future<void> deleteLibrary(String userId, String storyId) async {
  final querySnapshot = await libraries
    .where('userId', isEqualTo: userId)
    .where('storyId', isEqualTo: storyId)
    .get();

  for (final doc in querySnapshot.docs) {
    await libraries.doc(doc.id).delete();
    }
  }


  Future<bool> checkIfAdded(String storyId, String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('libraries')
        .where('storyId', isEqualTo: storyId)
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}