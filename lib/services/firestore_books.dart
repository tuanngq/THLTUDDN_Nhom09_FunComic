import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService_books {

  // Get collection of books
  final CollectionReference books = 
      FirebaseFirestore.instance.collection('books');

  // // CREATE: add a new Book
  // Future<void> addBook(String book) {
  //   return books.add({
  //     'image': book,
  //     'timestamp': Timestamp.now(),
  //   });
  // }

  // READ: get books from database
  Stream<QuerySnapshot> getbooksStream() {
    final booksStream = 
      books.orderBy('timestamp', descending: true).snapshots();
    
    return booksStream;
  }

  // // UPDATE: update books given a doc id
  // Future<void> updateBook(String docID, String newBook) {
  //   return books.doc(docID).update({
  //     'image': newBook,
  //     'timestamp': Timestamp.now(),
  //   });
  // }

  // // DELETE: delete books given a doc id
  // Future<void> deleteBook(String docID) {
  //   return books.doc(docID).delete();
  // }

}