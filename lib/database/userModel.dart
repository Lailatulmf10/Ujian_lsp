class UserModel {
  int? _id;
  late String namaUser,nama, kataSandi;

  UserModel(
      {required this.namaUser,
      required this.nama,
      required this.kataSandi,
      });

  UserModel.fromMap(dynamic objek) {
    _id = objek['id'];
    namaUser = objek['username'];
    nama = objek['name'];
    kataSandi = objek['password'];
    
  }

  int? get id => _id;
  String get username => namaUser;
  String get name => nama;
  String get password => kataSandi;
  

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = namaUser;
    map['name'] = nama;
    map['password'] = kataSandi;
    return map;
  }
}