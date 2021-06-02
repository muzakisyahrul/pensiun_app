class User {
  String id;
  String id_pegawai;
  String nrp;
  String nama_lengkap;
  String pangkat;
  String jabatan;
  String kesatuan;
  String tgl_lahir;
  String foto;
  String path_foto;

  User(
      {this.id = "",
      this.id_pegawai = "",
      this.nrp = "",
      this.nama_lengkap = "",
      this.pangkat = "",
      this.jabatan = "",
      this.kesatuan = "",
      this.tgl_lahir = "",
      this.foto = "",
      this.path_foto = ""});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      id_pegawai: map['id_pegawai'],
      nrp: map['nrp'],
      nama_lengkap: map['nama_lengkap'],
      pangkat: map['pangkat'],
      jabatan: map['jabatan'],
      kesatuan: map['kesatuan'],
      tgl_lahir: map['tgl_lahir'],
      foto: map['foto'],
      path_foto: map['path_foto'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this.id;
    map['id_pegawai'] = this.id_pegawai;
    map['nrp'] = nrp;
    map['nama_lengkap'] = nama_lengkap;
    map['pangkat'] = pangkat;
    map['jabatan'] = jabatan;
    map['kesatuan'] = kesatuan;
    map['tgl_lahir'] = tgl_lahir;
    map['foto'] = foto;
    map['path_foto'] = path_foto;
    return map;
  }
}
