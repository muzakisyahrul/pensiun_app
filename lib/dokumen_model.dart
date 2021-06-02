class DokumenModel {
  String id_dokumen;
  String nama_dokumen;
  String nama_file;
  String path_file;
  String created_at;
  String updated_at;

  DokumenModel(
      {this.id_dokumen = "",
      this.nama_dokumen = "",
      this.nama_file = "",
      this.path_file = "",
      this.created_at = "",
      this.updated_at = ""});
}
