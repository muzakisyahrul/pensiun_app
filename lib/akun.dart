import './config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './user_model.dart';

class Akun extends StatefulWidget {
  @override
  _AkunState createState() => new _AkunState();
}

class _AkunState extends State<Akun> {
  bool visible = false;
  User user = new User();
  String _token = "";

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  _logOut() async {
    await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Apakah Anda Yakin?'),
        content: new Text('Anda akan keluar akun anda.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Batal'),
          ),
          TextButton(
            onPressed: () => {_prosesLogout()},
            child: new Text('Lanjut'),
          ),
        ],
      ),
    );
  }

  _prosesLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('slogin', false);
    prefs.setString('token', "");
    prefs.setString('nama_pegawai', "");
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
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
            'Akun',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        body: SingleChildScrollView(
            child: Container(
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                margin: EdgeInsets.only(top: 20),
                                child: new Center(
                                  child: ClipOval(
                                    child: getImage(),
                                  ),
                                ),
                              ),
                              new Container(
                                margin: EdgeInsets.only(top: 5),
                                child: new Center(
                                  child: Text(
                                    user.nama_lengkap,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              new Container(
                                margin: EdgeInsets.only(top: 2, bottom: 20),
                                child: new Center(
                                  child: Text(
                                    "NRP. " + user.nrp,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(
                          Icons.power_settings_new,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        onPressed: () {
                          _logOut();
                        },
                        label: Text('LOGOUT'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
