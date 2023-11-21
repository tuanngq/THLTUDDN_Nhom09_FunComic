import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService_comment {
  // Get collection of notes
  final CollectionReference comments = 
      FirebaseFirestore.instance.collection('comments');

  // CREATE: add a new note
  Future<void> addComment(String userId, String storyId, String text) {
    return comments.add({
      'userId': userId,
      'storyId': storyId,
      'text': text,
      'timestamp': Timestamp.now(),
    });
  }

  // READ: get notes from database
  Stream<QuerySnapshot> getCommentsStream(String storyId) {
    final commentsStream = comments
      .orderBy('timestamp', descending: true)
      .where('storyId', isEqualTo: storyId)
      .snapshots();
    
    return commentsStream;
  }

  // UPDATE: update notes given a doc id
  Future<void> updateComment(String userId, String storyId, String newComment) async {
    final querySnapshot = await comments
      .where('userId', isEqualTo: userId)
      .where('storyId', isEqualTo: storyId)
      .get();

    for (final doc in querySnapshot.docs) {
      await comments.doc(doc.id).update({
        'text': newComment,
        'timestamp': Timestamp.now(),
      });
    }
  }

  // DELETE: delete notes given a doc id
  Future<void> deleteComment(String userId, String storyId) async {
  final querySnapshot = await comments
    .where('userId', isEqualTo: userId)
    .where('storyId', isEqualTo: storyId)
    .get();

  for (final doc in querySnapshot.docs) {
    await comments.doc(doc.id).delete();
    }
  }


  Future<bool> checkIfUserCommented(String storyId, String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('comments')
        .where('storyId', isEqualTo: storyId)
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}