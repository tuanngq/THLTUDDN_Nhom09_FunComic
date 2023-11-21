import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thltuddn01/pages/comment_page.dart';
import 'package:thltuddn01/pages/show_image.dart';
import 'package:thltuddn01/services/firestore_books.dart';
import 'package:thltuddn01/services/firestore_library.dart';

class BookInfoPage extends StatefulWidget {
  final String? userId;
  final String docID;

  const BookInfoPage({super.key,required this.userId, required this.docID});

  @override
  State<BookInfoPage> createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  // firestore_books
  final FirestoreService_books firestoreService_books = FirestoreService_books();

  // firestore_books
  final FirestoreService_library firestoreService_libraries = FirestoreService_library();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
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
          String docID = targetBook!.id;

          if (targetBook != null) {
            // Display the specific book
            Map<String, dynamic> data = targetBook.data() as Map<String, dynamic>;
            String bookImagePath = data['image'];
            String bookName = data['name'];
            String bookGenre = data['genre'];
            String bookSummary = data['summary'];

            // const margin_size = 30.0;
            return Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Điều hướng trở lại trang trước
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back), 
                      ),
                      Text(
                        bookName,
                        style: const TextStyle(
                        fontSize: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Xử lý sự kiện khi bấm vào IconButton Thêm vào thư viện ở đây
                        firestoreService_libraries
                        .checkIfAdded(widget.docID, widget.userId!)
                        .then((bool hasAdded) {
                          if (hasAdded) {
                            // Người dùng đã đánh giá, không cho phép viết đánh giá
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Không thành công'),
                                content: const Text('Truyện này đã có trong thư viện của bạn.'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Đóng'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            firestoreService_libraries
                            .addLibrary(widget.userId!, widget.docID, bookName, bookImagePath, bookGenre);

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Thành công'),
                                content: Text('Đã thêm truyện vào thư viện'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Đóng'),
                                  ),
                                ],
                              ),
                            );
                          }
                        });
                        },
                        icon: const Icon(Icons.add_card_rounded),
                      ),
                    ],
                  ),
            
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      height: 200,
                      child: Image.asset(
                        bookImagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Thể loại: " + bookGenre,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tóm tắt: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      bookSummary,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Xử lý sự kiện khi nút "Đọc truyện" được nhấn
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ShowStory()));
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ShowImage()));
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ShowImage(docID: widget.docID),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Màu nền của nút
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // Độ cong của góc
                          ),
                        ),
                        child: const Text(
                          "Đọc truyện",
                          style: TextStyle(
                            color: Colors.white, // Màu văn bản
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Xử lý sự kiện khi nút "Xem đánh giá" được nhấn
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CommentPage(userId: widget.userId, storyId: docID),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Màu nền của nút
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // Độ cong của góc
                          ),
                        ),
                        child: const Text(
                          "Xem đánh giá truyện",
                          style: TextStyle(
                            color: Colors.white, // Màu văn bản
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
