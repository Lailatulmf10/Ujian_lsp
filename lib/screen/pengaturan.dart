import 'package:flutter/material.dart';
import 'package:login_signup_flutter/database/database_helper.dart';
import 'package:login_signup_flutter/screen/home.dart';
import 'package:login_signup_flutter/screen/loginForm.dart';

class Pengaturan extends StatefulWidget {
  final int id_user;
  const Pengaturan({Key? key, required this.id_user}) : super(key: key);
  @override
  _PengaturanState createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black),
                  ),
                ),
                child: Text("Ganti Password"),
              ),
              Text("Password Lama"),
              TextFormField(
                controller: oldpasswordController,
              ),
              SizedBox(
                height: 20,
              ),
              Text("Password Baru"),
              TextFormField(
                controller: newpasswordController,
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                onPressed: () async {
                  if (oldpasswordController.text.isEmpty ||
                      newpasswordController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Data tidak boleh kosong.'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    await DatabaseHelper().changePassword(
                        widget.id_user,
                        oldpasswordController.text,
                        newpasswordController.text,
                        context);
                  }
                },
                child: Text(
                  "Simpan",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                onPressed: () {
                  print("Simpan diklik");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => loginForm()),
                  );
                },
                child: Text(
                  "Kembali",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
