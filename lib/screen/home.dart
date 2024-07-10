import 'package:flutter/material.dart';
import 'package:login_signup_flutter/database/database_helper.dart';
import 'package:login_signup_flutter/screen/detailForm.dart';
import 'package:login_signup_flutter/screen/pemasukan.dart';
import 'package:login_signup_flutter/screen/pengaturan.dart';
import 'package:login_signup_flutter/screen/pengeluaran.dart';

class Home extends StatefulWidget {
  final int id_user;
  const Home({Key? key, required this.id_user}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              "Rangkuman Bulan ini",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            FutureBuilder(
                future: DatabaseHelper().totalOutcome(id_user: widget.id_user),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Text(
                      "Total Pengeluaran : Rp. ${snapshot.data}",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    );
                  } else {
                    return const Text('Empty Data');
                  }
                }),
            SizedBox(height: 10),
            FutureBuilder(
                future: DatabaseHelper().totalIncome(id_user: widget.id_user),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Text(
                      "Total Pemasukan : Rp. ${snapshot.data}",
                      style: TextStyle(
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    );
                  } else {
                    return const Text('Empty Data');
                  }
                }),
            SizedBox(height: 20),
            Image.asset("assets/images/logo2.png", height: 200.0, width: 200.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    // Navigasi ke halaman "Tambah Pemasukan"
                  },
                  child: Column(
                    children: [
                      SizedBox(width: 50),
                      // Icon(Icons.add_circle, size: 50, color: Colors.blue),
                      Text(
                        "Tambah Pemasukan",
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Pemasukan(
                                        id_user: widget.id_user,
                                      )));
                        },
                        child: Icon(Icons.add_circle,
                            size: 50, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigasi ke halaman "Tambah Pengeluaran"
                  },
                  child: Column(
                    children: [
                      Text("Tambah Pengeluaran"),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Pengeluaran(
                                        id_user: widget.id_user,
                                      )));
                        },
                        child: Icon(Icons.remove_circle,
                            size: 50, color: Colors.orange),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    // Navigasi ke halaman "Detail Cash Flow"
                  },
                  child: Column(
                    children: [
                      Text("Detail Cash Flow"),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailForm(
                                        id_user: widget.id_user,
                                      )));
                        },
                        child: Icon(Icons.list, size: 50, color: Colors.purple),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigasi ke halaman "Pengaturan"
                  },
                  child: Column(
                    children: [
                      Text("Pengaturan"),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Pengaturan(
                                        id_user: widget.id_user,
                                      )));
                        },
                        child:
                            Icon(Icons.settings, size: 50, color: Colors.grey),
                      ),
                    ],
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
