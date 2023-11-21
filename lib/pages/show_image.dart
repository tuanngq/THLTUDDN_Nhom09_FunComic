import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thltuddn01/services/firestore_books.dart';

class ShowImage extends StatefulWidget {
  final String docID;

  const ShowImage({super.key, required this.docID});

  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
    // firestore_books
  final FirestoreService_books firestoreService_books = FirestoreService_books();

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double imageWidth = screenWidth * 0.9; // Đặt chiều rộng bằng 90% chiều rộng màn hình

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Đọc truyện"),
      ),
      body: 
      StreamBuilder<QuerySnapshot>(
      stream: firestoreService_books.getbooksStream(),
      builder: (context, snapshot) {
        // if we have data, get all the docs
        if (snapshot.hasData) {
          List booksList = snapshot.data!.docs;

          // Find the document with the specific docID
          DocumentSnapshot? targetBook;
          for (var document in booksList) {
            if (document.id == widget.docID) {
              targetBook = document;
              break;
            }
          }
          // String docID = targetBook!.id;

          if (targetBook != null) {
            // Display the specific book
            Map<String, dynamic> data = targetBook.data() as Map<String, dynamic>;
            String bookContentPath = data['content'];
            String bookName = data['name'];

            // const margin_size = 30.0;
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10,),
                    Text("Truyện: " + bookName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Center(
                      child: Container(
                        width: imageWidth,
                        child: Image.asset(
                          // 'lib/images/merge01.png',
                          bookContentPath,
                          width: imageWidth,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text("----- Hết -----",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),
            );
          } else {
            return const Text("Không tìm thấy sách phù hợp!");
          }
        }

        // If there is no data, return a loading indicator or an error message.
        return const CircularProgressIndicator(); // Change this to a suitable loading indicator.
      },
    ),
        
    );
  }
}