import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thltuddn01/pages/search_page.dart';
import 'package:thltuddn01/services/firestore_books.dart';
import 'package:thltuddn01/pages/book_info_page.dart';

class BookPage extends StatefulWidget {
  final String? userId;

  const BookPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final FirestoreService_books firestoreService = FirestoreService_books();
  List<String> categories = ['Cổ tích Việt Nam', 'Truyện ngụ ngôn', 'Truyện nước ngoài'];
  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    String email = widget.userId!;
    int atIndex = email.indexOf("@");
    String username = email.substring(0, atIndex);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: ListTile(
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('lib/images/avatar.png'),
            ),
            title: Text('Xin chào, ' + username + '!'),
            subtitle: Text('Đọc truyện thôi...'),
            trailing: IconButton(
              onPressed: signUserOut,
              icon: Icon(Icons.logout),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(40),
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage(userId: widget.userId)));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.all(24),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "Tìm kiếm truyện cho bé",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20,),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FilterChip(
                  selected: selectedCategories.contains(category),
                  label: Text(
                    category,
                    style: TextStyle(
                      color: selectedCategories.contains(category) ? Colors.white : Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedCategories.add(category);
                      } else {
                        selectedCategories.remove(category);
                      }
                    });
                  },
                  backgroundColor: selectedCategories.contains(category) ? Colors.blue : Colors.grey,
                  selectedColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  showCheckmark: true, // Hiển thị biểu tượng checkmark khi được chọn
                  checkmarkColor: Colors.white, // Đặt màu biểu tượng checkmark
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20,),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getbooksStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<DocumentSnapshot> booksList = snapshot.data!.docs;
                List<DocumentSnapshot> filteredBooks = [];

                for (var document in booksList) {
                  String bookGenre = (document.data() as Map<String, dynamic>)['genre'];
                  if (selectedCategories.isEmpty || selectedCategories.contains(bookGenre)) {
                    filteredBooks.add(document);
                  }
                }

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1 / 1.8,
                    ),
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = filteredBooks[index];
                      String docID = document.id;
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      String bookImagePath = data['image'];
                      String bookName = data['name'];

                      const marginSize = 8.0;
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.only(right: marginSize, left: marginSize, bottom: marginSize),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BookInfoPage(userId: widget.userId!, docID: docID),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(0),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(bookImagePath),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  bookName,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    shadows: [
                                      Shadow(
                                        color: Colors.grey,
                                        offset: Offset(2, 2),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center, // Đặt căn giữa văn bản
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Text("Không có sách phù hợp!");
              }
            },
          ),
        ),
      ],
    );
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
}
