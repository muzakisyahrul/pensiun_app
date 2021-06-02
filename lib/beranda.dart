import './config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './user_model.dart';
import './ubah_biodata.dart';

class Beranda extends StatefulWidget {
  @override
  _BerandaState createState() => new _BerandaState();
}

class _BerandaState extends State<Beranda> {
  bool visible = false;
  User user = new User();
  String _token = "";

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  _getUserInfo() async {
    setState(() {
      visible = true;
    });
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? "";
    try {
      var res = await http
          .get(Uri.parse(BASE_URL_API + "api/main/info_user"), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': _token,
      }).timeout(const Duration(seconds: 10));
      print(res.body);
      if (res.statusCode == 200) {
        var response = json.decode(res.body);
        print(response);
        setState(() {
          visible = false;
          user = new User(
            id: response['id'],
            id_pegawai: response['id_pegawai'],
            nrp: response['nrp'],
            nama_lengkap: response['nama_lengkap'],
            pangkat: response['pangkat'],
            jabatan: response['jabatan'],
            kesatuan: response['kesatuan'],
            tgl_lahir: response['tgl_lahir'],
            foto: response['foto'],
            path_foto: response['path_foto'],
          );
        });
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
      visible = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Gagal Menghubungkan Ke Server"),
      backgroundColor: Colors.deepOrange,
    ));
  }

  Widget getImage() {
    if (user.foto.isEmpty) {
      return Image.asset(
        'assets/avatar.jpg',
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        BASE_URL_API + user.path_foto + user.foto,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
    ));
    return new Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back, color: Colors.white),
          //   onPressed: () => SystemNavigator.pop(),
          // ),
          elevation: 2,
          title: const Text(
            'Beranda',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        body: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Center(
                          child: ClipOval(
                            child: getImage(),
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.only(top: 5),
                          child: new Center(
                            child: Text(
                              user.nama_lengkap,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.only(top: 2),
                          child: new Center(
                            child: Text(
                              "NRP. " + user.nrp,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                    Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: visible,
                        child: Container(child: CircularProgressIndicator())),
                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(
                              Icons.assignment_ind,
                              color: Colors.black,
                            ),
                            title: Text(
                              'Biodata',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text('Detail biodata pegawai'),
                          ),
                          Row(children: <Widget>[
                            Expanded(child: Divider()),
                            Expanded(child: Divider()),
                          ]),
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                            child: Row(children: <Widget>[
                              Text(
                                'NRP : ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                user.nrp,
                                style: TextStyle(color: Colors.black),
                              ),
                            ]),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                            child: Row(children: <Widget>[
                              Text(
                                'Nama : ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                user.nama_lengkap,
                                style: TextStyle(color: Colors.black),
                              ),
                            ]),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                            child: Row(children: <Widget>[
                              Text(
                                'Pangkat : ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                user.pangkat,
                                style: TextStyle(color: Colors.black),
                              ),
                            ]),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                            child: Row(children: <Widget>[
                              Text(
                                'Jabatan : ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                user.jabatan,
                                style: TextStyle(color: Colors.black),
                              ),
                            ]),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                            child: Row(children: <Widget>[
                              Text(
                                'Kesatuan : ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                user.kesatuan,
                                style: TextStyle(color: Colors.black),
                              ),
                            ]),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                            child: Row(children: <Widget>[
                              Text(
                                'Tanggal Lahir : ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                user.tgl_lahir,
                                style: TextStyle(color: Colors.black),
                              ),
                            ]),
                          ),
                          Row(children: <Widget>[
                            Expanded(child: Divider()),
                            Expanded(child: Divider()),
                          ]),
                          ButtonBar(
                            children: <Widget>[
                              ElevatedButton.icon(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => UbahBiodata()));
                                },
                                label: Text('Ubah Data'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
