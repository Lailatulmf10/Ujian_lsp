import 'dart:io';
import 'package:flutter/material.dart';
import 'package:login_signup_flutter/database/keuanganModel.dart';
import 'package:login_signup_flutter/database/userModel.dart';
import 'package:login_signup_flutter/screen/home.dart';
import 'package:login_signup_flutter/screen/loginForm.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{ 
  final String databaseName = "databaseUjian.db";
  final int databaseVersion = 1;

  final String tabelUser = "user";
  final String columnUserId = "id";
  final String columnName = "name";
  final String columnUserName = "username";
  final String columnUserPassword = "password";

  final String tabelManajemenKeuangan = "manajemen_keuangan";
  final String columnIdKeuangan = "id";
  final String columnIdUserKeuangan = "id_user";
  final String columnTypeKeuangan = "type";
  final String columnDateKeuangan = "date";
  final String columnNominalKeuangan = "nominal";
  final String columnDescriptionKeuangan = "description";

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Create Database
    _database = await _initDatabase();
    return _database!;
  }

  Future _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, databaseName);
    try {
      _database = await openDatabase(path,
          version: databaseVersion, onCreate: _onCreate);
      return _database;
    } catch (e) {
      print('Error saat membuka database: $e');
      return null;
    }
  }
  // Membuat Tabel
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tabelUser (
      $columnUserId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $columnName TEXT,
      $columnUserName TEXT, 
      $columnUserPassword TEXT)
      ''');

    await db.execute('''
    CREATE TABLE $tabelManajemenKeuangan (
      $columnIdKeuangan INTEGER PRIMARY KEY AUTOINCREMENT, 
      $columnIdUserKeuangan INTEGER,
      $columnTypeKeuangan TEXT, 
      $columnDateKeuangan TEXT, 
      $columnNominalKeuangan INTEGER, 
      $columnDescriptionKeuangan TEXT, 
      FOREIGN KEY ($columnIdUserKeuangan) REFERENCES $tabelUser ($columnUserId))
      ''');
  }
  // Insert Database
  Future<int> createUser(UserModel user) async {
    final db = await database;
    return await db.insert(tabelUser, user.toMap());
  }
  // Mencari User Berdasarkan Username
  Future<UserModel?> getUserByUsername(String username) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tabelUser,
      where: '$columnUserName = ?',
      whereArgs: [username],
    );
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  // Mencari User Berdasarkan ID
  Future<UserModel?> getUserById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tabelUser,
      where: '$columnUserId = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }
  // Register
  Future<void> register(String username, String password, String name,
      BuildContext context) async {
    UserModel? user = UserModel(
      namaUser: username,
      nama: name,
      kataSandi: password,
    );
    int result = await DatabaseHelper().createUser(user);
    if (result > 0) {
      // Registrasi berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => loginForm()),
      );
    } 
  }
  // Login
  Future<void> login(
      String username, String password, BuildContext context) async {
    UserModel? user = await DatabaseHelper().getUserByUsername(username);
    if (user != null && user.password == password) {
      // Login berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Home(
                  id_user: user.id!,
                )),
      );
    } 
  }
  // Ubah Password
  Future<void> changePassword(
      int id, String password, String newPassword, BuildContext context) async {
    UserModel? user = await DatabaseHelper().getUserById(id);
    if (user != null && user.password == password) {
      // Password lama sesuai, update password di objek user
      user.kataSandi = newPassword;

      // Lakukan UPDATE ke database
      final db = await DatabaseHelper().database;
      await db.update(
        tabelUser, // Nama tabel yang sesuai
        user.toMap(), // Data yang diperbarui
        where: '${columnUserId} = ?', // Kriteria WHERE
        whereArgs: [id], // Parameter WHERE
      );
      // Kembali ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => loginForm()),
      );
    } else {
      // Password lama tidak sesuai
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Password lama tidak sesuai.'),
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
    }
  }
  // Insert Database CashFlow
  Future<int?> createCashFlow(KeuanganModel flow) async {
    final db = await database;
    return await db.insert(tabelManajemenKeuangan, flow.toMap());
  }

  // Tambah Pendapatan
  Future<void> addIncome(int id_user, String date, int total,
      String description, BuildContext context) async {
    // Buat objek CashFlow
    KeuanganModel? flow = KeuanganModel(
      idUser: id_user,
      tipe: 'income',
      tanggal: date,
      jumlah: total,
      keterangan: description,

    );
    // Insert ke database
    int? result = await DatabaseHelper().createCashFlow(flow);
    if (result! > 0) {
      // Tambah pendapatan berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home(id_user: id_user)),
      );
    } else {
      // Gagal menambahkan pendapatan
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Gagal menambahkan. Silakan coba lagi.'),
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
    }
  }

  // Tambah Pengeluaran
  Future<void> addOutcome(int id_user, String date, int total,
      String description, BuildContext context) async {
    // Buat objek CashFlow
    KeuanganModel flow = KeuanganModel(
      idUser: id_user,
      tipe: 'outcome',
      tanggal: date,
      jumlah: total,
      keterangan: description,

    );
    // Insert ke database
    int? result = await DatabaseHelper().createCashFlow(flow);
    if (result! > 0) {
      // Tambah pengeluaran berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home(id_user: id_user)),
      );
    } else {
      // Gagal menambahkan pengeluaran
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Gagal menambahkan. Silakan coba lagi.'),
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
    }
  }

  // Mengambil semua data CashFlow User Login
  Future<List<KeuanganModel>> all(int id_user) async {
    final db = await database;
    // cek apakah database sudah terbuka
    if (_database != null) {
      final data = await db.query(
            tabelManajemenKeuangan,
            where: '$columnIdUserKeuangan = ?',
            whereArgs: [id_user],
          ) ??
          [];
      List<KeuanganModel> result = data.map((e) => KeuanganModel.fromMap(e)).toList();
      // Memeriksa dan mengganti nilai null jika diperlukan
      for (var flow in result) {
        if (flow.jumlah == null) {
          flow.jumlah = 0; // Ganti dengan nilai default atau nilai yang sesuai
        }
        if (flow.keterangan == null) {
          flow.keterangan =
              ""; // Ganti dengan nilai default atau nilai yang sesuai
        }
      }
      print(result);
      return result;
    } else {
      print('Database belum terbuka');
      return [];
    }
  }

  // Menghitung total pendapatan
  Future<int> totalIncome({required int id_user}) async {
    // cek apakah database sudah terbuka
    final db = await database;
    int income = 0; // Inisialisasi dengan nilai 0
    if (_database != null) {
      final data = await db.query(
            tabelManajemenKeuangan,
            where: '$columnIdUserKeuangan = ? AND $columnTypeKeuangan = ?',
            whereArgs: [id_user, "income"],
          ) ??
          [];
      List<KeuanganModel> result = data.map((e) => KeuanganModel.fromMap(e)).toList();
      // Menjumlahkan total pendapatan
      for (var flow in result) {
        income += flow.total;
      }
      return income;
    } else {
      return income; // Return 0 jika database belum terbuka
    }
  }

  // Menghitung total pengeluaran
  Future<int> totalOutcome({required int id_user}) async {
    // cek apakah database sudah terbuka
    final db = await database;
    int outcome = 0; // Inisialisasi dengan nilai 0
    if (_database != null) {
      final data = await db.query(
            tabelManajemenKeuangan,
            where: '$columnIdUserKeuangan = ? AND $columnTypeKeuangan = ?',
            whereArgs: [id_user, "outcome"],
          ) ??
          [];
      List<KeuanganModel> result = data.map((e) => KeuanganModel.fromMap(e)).toList();
      // Menjumlahkan total pendapatan
      for (var flow in result) {
        outcome += flow.total;
      }
      return outcome;
    } else {
      return outcome; // Return 0 jika database belum terbuka
    }
  }
}