import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

final nameController = TextEditingController();
final emailController = TextEditingController();
final messageController = TextEditingController();

Future sendEmail() async {
  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  const serviceId = "service_9fntz6q";
  const templateId = "template_iddm71r";
  const userId = "MMOj6PhFzptkiLz6X";
  final response = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "service_id": serviceId,
        "template_id": templateId,
        "user_id": userId,
        "template_params": {
          "name": nameController.text,
          "message": messageController.text,
          "user_email": emailController.text,
        }
      }));
  return response.statusCode;
}


class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Góp ý"),
          // backgroundColor: Colors.brow,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 48, 25, 8),
          child: Form(
              child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5, // Đặt chiều rộng là một nửa màn hình
                alignment: Alignment.center, // Căn giữa nội dung theo chiều ngang
                child: const Text(
                  """Hãy dành chút thời gian để gửi cho chúng tôi những tính năng bạn cần hoặc cần cải tiến thêm nhé!""",
                  style: TextStyle(
                    fontSize: 16, // Đặt kích thước chữ
                    color: Colors.black, // Đặt màu chữ
                    backgroundColor: Colors.white, // Đặt màu nền
                    fontWeight: FontWeight.bold, // Đặt độ đậm
                    fontStyle: FontStyle.italic, // Đặt kiểu chữ nghiêng
                  ),
                  textAlign: TextAlign.center, // Căn giữa dọc
                ),
              ),


              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.account_circle),
                  hintText: 'Tên',
                  labelText: 'Tên của bạn',
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Email',
                  labelText: 'Điền email để chúng tôi có thể liên lạc với bạn',
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.message),
                  hintText: 'Góp ý',
                  labelText: 'Góp ý của bạn',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (messageController.text.isEmpty) {
                    // Kiểm tra xem có giá trị nào trong các TextFormField chưa được nhập
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Thông báo'),
                        content: const Text('Bạn chưa nhập nội dung góp ý.'),
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
                    final responseCode = await sendEmail();
                    if (responseCode == 200) {
                      // Gửi thành công, hiển thị thông báo và xóa nội dung của messageController
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Thông báo'),
                          content: Text('Chúng tôi đã nhận được góp ý của bạn!'),
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
                      // Xóa nội dung các textform sau khi gửi tin nhắn
                      messageController.clear();
                      nameController.clear();
                      emailController.clear();     
                    }
                  }
                },
                child: const Text(
                  "Gửi",
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}