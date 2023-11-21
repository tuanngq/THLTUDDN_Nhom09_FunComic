import 'package:flutter/material.dart';
import 'package:thltuddn01/model/comic_model.dart';
import 'package:thltuddn01/pages/book_info_page.dart';
import 'package:thltuddn01/services/firestore_booksearch.dart';

class SearchPage extends StatefulWidget {
  final String? userId;
  const SearchPage({super.key, required this.userId});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FirestoreService_booksearch firebaseService = FirestoreService_booksearch();
  List<ComicModel> comic_list = [];
  List<ComicModel> display_list = [];

  @override
  void initState() {
    super.initState();
    _loadComicsFromFirebase();
  }
  
  void _loadComicsFromFirebase() async {
    List<ComicModel> comics = await firebaseService.getComicsFromFirebase();
    setState(() {
      comic_list = comics;
      display_list = comics.toList(); // Khởi tạo display_list ở đây
    });
  }

  void updateList(String value) {
    setState(() {
      display_list = comic_list
          .where((element) =>
              element.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "Tìm truyện cho bé", 
          style: TextStyle(
            color: Colors.black, // Đặt màu cho văn bản
            fontSize: 22.0, // Đặt kích thước văn bản
            fontWeight: FontWeight.bold, // Đặt độ đậm của văn bản
          ),
        ),
        centerTitle: true, // Đặt văn bản ở giữa AppBar
        titleSpacing: 0.0, // Đặt khoảng cách giữa văn bản và icon về 0
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Màu nền của TextField
                borderRadius: BorderRadius.circular(40), // Độ cong của góc
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey, // Màu shadow
                    blurRadius: 10, // Độ mờ
                    offset: Offset(0, 5), // Độ lệch theo trục X và Y
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) => updateList(value),
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white, // Màu nền của TextField
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Ví dụ: Tấm Cám",
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: display_list.length == 0
                  ? const Center(
                      child: Text(
                        "Không tìm thấy kết quả",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: display_list.length,
                      itemBuilder: (context, index) => ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                            builder: (context) => BookInfoPage(userId: widget.userId, docID: display_list[index].id!),
                          ),
                      );
                        }, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // Đặt màu nền là trong suốt
                          shadowColor: Colors.transparent, // Đặt màu viền (nếu có) là trong suốt
                        ),
                        child: ListTile(
                        contentPadding: const EdgeInsets.all(8.0),
                        title: Text(
                          display_list[index].name!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: AspectRatio(
                          aspectRatio: 4 / 5,
                          child: Image.asset(
                            display_list[index].image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
            )),
          ],
        ),
      ),
    );
  }
}
