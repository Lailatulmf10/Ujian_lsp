import 'package:flutter/material.dart';
import 'package:login_signup_flutter/database/database_helper.dart';
import 'package:login_signup_flutter/screen/detailForm.dart';
import 'package:login_signup_flutter/screen/home.dart';

class Pengeluaran extends StatefulWidget {
  final int id_user;
  const Pengeluaran({Key? key, required this.id_user}) : super(key: key);

  @override
  _PengeluaranState createState() => _PengeluaranState();
}

class _PengeluaranState extends State<Pengeluaran> {
  DateTime selectedDate = DateTime.now(); // Added for storing selected date
  TextEditingController tanggalController = TextEditingController();
  TextEditingController nominalController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambahkan Pengeluaran'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text("Tanggal:"),
              
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text("${selectedDate.toLocal()}".split(' ')[0]),
              ),
              SizedBox(height: 20),
              Text("Nominal:"),
                TextFormField(
                controller: nominalController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Text("Keterangan:"),
              TextFormField(
                controller: keteranganController,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                ),
                onPressed: () {
                  tanggalController.clear();
                  nominalController.clear();
                  keteranganController.clear();
                },
                child: Text(
                  "Reset",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                onPressed: () async {
                  if (tanggalController.text.isEmpty ||
                      nominalController.text.isEmpty ||
                      keteranganController.text.isEmpty) {
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
                    DatabaseHelper().addOutcome(
                        widget.id_user,
                        tanggalController.text,
                        int.parse(nominalController.text),
                        keteranganController.text,
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
                  // print("Kembali diklik");
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => Home()),
                  // );
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

  Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (picked != null && picked != selectedDate)
    setState(() {
      selectedDate = picked;
      // Update the tanggalController with the selected date
      tanggalController.text = "${selectedDate.toLocal()}".split(' ')[0];
    });
}

}
