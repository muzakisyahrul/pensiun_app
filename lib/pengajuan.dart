import './config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './dokumen_model.dart';

class Pengajuan extends StatefulWidget {
  @override
  _PengajuanState createState() => new _PengajuanState();
}

class _PengajuanState extends State<Pengajuan> {
  List<DokumenModel> _listDokumen = [];

  bool is_loading = false;

  @override
  void initState() {
    super.initState();
    _getListDokumen();
  }

  _getListDokumen() async {
    final prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString('token') ?? "";
    _listDokumen.clear();
    setState(() {
      is_loading = true;
    });
    try {
      var res = await http
          .get(Uri.parse(BASE_URL_API + "api/init/list_dokumen"), headers: {
        'Authorization': _token,
      }).timeout(const Duration(seconds: 10));
      print(res.body);
      if (res.statusCode == 200) {
        setState(() {
          is_loading = false;
        });
        var response = json.decode(res.body);
        var data = response['records'];
        if (data != null) {
          data.forEach((dt) {
            var ab = new DokumenModel(
              id_dokumen: dt['id_dokumen'],
              nama_dokumen: dt['nama_dokumen'],
              nama_file: dt['nama_file'],
              path_file: dt['path_file'],
              created_at: dt['created_at'],
              updated_at: dt['updated_at'],
            );
            _listDokumen.add(ab);
          });
        }
      } else {
        showFailResponseMessage();
      }
    } catch (e) {
      print(e.toString());
      showFailResponseMessage();
    }
  }

  showFailResponseMessage() {
    setState(() {
      is_loading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Gagal Menghubungkan Ke Server"),
      backgroundColor: Colors.deepOrange,
    ));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
    ));

    return new Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: const Text(
            'Pengajuan Pensiun',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        body: ListView.builder(
          itemCount: _listDokumen.length,
          itemBuilder: (context, i) {
            final x = _listDokumen[i];
            return Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.assignment_ind,
                            color: Colors.black,
                          ),
                          title: Text(
                            x.nama_dokumen,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          tileColor: Colors.white,
                        ),
                        Row(children: <Widget>[
                          Expanded(child: Divider()),
                          Expanded(child: Divider()),
                        ]),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: Icon(
                                Icons.upload_file,
                                color: Colors.black,
                                size: 24.0,
                              ),
                              onPressed: () {},
                              label: Text(
                                'Upload File',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orange[200],
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(3.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(children: <Widget>[
                          Expanded(child: Divider()),
                          Expanded(child: Divider()),
                        ]),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                          child: new Text("Silakan Pilih File Terlebih Dahulu"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
