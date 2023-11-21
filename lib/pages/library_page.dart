import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thltuddn01/pages/book_info_page.dart';
import 'package:thltuddn01/services/firestore_library.dart';

class LibraryPage extends StatefulWidget {
  final String? userId;

  const LibraryPage({super.key, required this.userId});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  // firestore_books
  final FirestoreService_library firestoreService_libraries = FirestoreService_library();

  @override
  Widget build(BuildContext context) {

    final userId = widget.userId;
    final screenHeight = MediaQuery.of(context).size.height; // Lấy chiều cao của màn hình
    final customHeight = screenHeight * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thư viện'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Column(
              children: [
                SizedBox(
                  height: customHeight,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('libraries')
                        .where('userId', isEqualTo: userId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      var libraries = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: libraries.length,
                        itemBuilder: (context, index) {
                          var library = libraries[index].data();

                          return ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BookInfoPage(userId: widget.userId, docID: library['storyId']),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent, // Đặt màu nền là trong suốt
                              shadowColor: Colors.transparent, // Đặt màu viền (nếu có) là trong suốt
                            ),
                            child: ListTile(
                              leading: AspectRatio(
                                aspectRatio: 4 / 5,
                                child: Image.asset(
                                  library['storyImage'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text('Truyện: ${library['storyName']}'),
                              subtitle: Text('Thể loại: ${library['storyGenre']}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete), 
                                onPressed: () {
                                  // Xử lý sự kiện khi nút Delete được nhấn
                                  firestoreService_libraries.deleteLibrary(widget.userId!, library['storyId']);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



