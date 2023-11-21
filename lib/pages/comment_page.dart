import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:thltuddn01/services/firestore_books.dart';
import 'package:thltuddn01/services/firestore_comment.dart';

class CommentPage extends StatefulWidget {
  final String? userId;
  final String storyId;

  const CommentPage({super.key,required this.userId, required this.storyId});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  // // firestore_books
  // final FirestoreService_books firestoreService_books = FirestoreService_books();

  // firestore_books
  final FirestoreService_comment firestoreService_comments = FirestoreService_comment();

  // text controller
  final TextEditingController textController = TextEditingController();

  void openCommentBox({String? storyId, String? option}) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          // button to save
          ElevatedButton(
            onPressed: () {
              // add a new note
              if (option == 'add') {
                firestoreService_comments.addComment(widget.userId!, storyId!, textController.text);
              }

              // update an existing note
              else {
                firestoreService_comments.updateComment(widget.userId!, storyId!, textController.text);
              }

              // clear the text controller
              textController.clear();

              // close the box
              Navigator.pop(context);
            }, 
            child: const Text("Đăng"),
          ) 
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final storyId = widget.storyId;
    final screenHeight = MediaQuery.of(context).size.height; // Lấy chiều cao của màn hình
    final customHeight = screenHeight * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá truyện'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  firestoreService_comments
                  .checkIfUserCommented(storyId, widget.userId!)
                  .then((bool userHasCommented) {
                    if (userHasCommented) {
                      // Người dùng đã đánh giá, không cho phép viết đánh giá
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Thông báo'),
                          content: const Text('Bạn đã đánh giá truyện này.'),
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
                      openCommentBox(storyId: storyId, option: 'add');
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Màu nền của nút
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Độ cong của góc
                  ),
                ),
                child: const Text(
                  "Viết đánh giá",
                  style: TextStyle(
                    color: Colors.white, // Màu văn bản
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              ElevatedButton(
                onPressed: () {
                  // Xử lý sự kiện khi nút "Thay đổi đánh giá" được nhấn
                  openCommentBox(storyId: storyId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Màu nền của nút
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Độ cong của góc
                  ),
                ),
                child: const Text(
                  "Thay đổi đánh giá",
                  style: TextStyle(
                    color: Colors.white, // Màu văn bản
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              ElevatedButton(
                onPressed: () {
                  // Xử lý sự kiện khi nút "Xóa đánh giá" được nhấn
                  firestoreService_comments.deleteComment(widget.userId!, storyId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Màu nền của nút
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Độ cong của góc
                  ),
                ),
                child: const Text(
                  "Xóa đánh giá",
                  style: TextStyle(
                    color: Colors.white, // Màu văn bản
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: customHeight,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('comments')
                            .where('storyId', isEqualTo: storyId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
              
                          var comments = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              var comment = comments[index].data();
              
                              String email = comment['userId'];
                              int atIndex = email.indexOf("@");
                              String username = email.substring(0, atIndex);
              
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                padding: EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Người dùng: ${username}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      comment['text'],
                                      style: const TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



