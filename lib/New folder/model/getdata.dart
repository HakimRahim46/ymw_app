class Users {
  Users(
      {required this.jenishartaDesc,
      required this.label,
      required this.pemilik,
      required this.penempatanPegawaiNama,
      required this.lokasiPenempatan,
      required this.barcodedata,
      required this.state,
      required this.loccode});

  String jenishartaDesc;
  String label;
  String pemilik;
  String penempatanPegawaiNama;
  String lokasiPenempatan;
  String barcodedata;
  String state;
  String loccode;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        jenishartaDesc: json["jenisharta_desc"],
        label: json["label"],
        pemilik: json["pemilik_aset_bah"],
        penempatanPegawaiNama: json["penempatan_pegawai_nama"],
        lokasiPenempatan: json["lokasi_penempatan"],
        barcodedata: json["barcode_data"],
        state: json["state"],
        loccode: json["loccode"],
      );

  static List<Users> parseList(List<dynamic> list) {
    return list.map((i) => Users.fromJson(i)).toList();
  }

  static Future<List<Users>> fromJsonList(jsonList) {
    return jsonList.map<Users>((obj) => Users.fromJson(obj)).toList();
  }
}
