class KeuanganModel {
  int? _id;
  late int idUser, jumlah;
  late String tipe, tanggal, keterangan;

  KeuanganModel(
      {required this.idUser,
      required this.tipe,
      required this.tanggal,
      required this.jumlah,
      required this.keterangan,
});

  KeuanganModel.fromMap(dynamic objek) {
    _id = objek['id'];
    idUser = objek['id_user'];
    tipe = objek['type'];
    tanggal = objek['date'];
    jumlah = objek['nominal'];
    keterangan = objek['description'];

  }
  int? get id => _id;
  int get id_user => idUser;
  String get type => tipe;
  String get date => tanggal;
  int get total => jumlah;
  String get description => keterangan;


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['id_user'] = idUser;
    map['type'] = tipe;
    map['date'] = tanggal;
    map['nominal'] = jumlah;
    map['description'] = keterangan;

    return map;
  }
}