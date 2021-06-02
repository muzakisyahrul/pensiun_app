import 'package:pensiun_app/beranda.dart';

import './config.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './user_model.dart';

class UbahBiodata extends StatefulWidget {
  @override
  _UbahBiodataState createState() => new _UbahBiodataState();
}

class _UbahBiodataState extends State<UbahBiodata> {
  bool visible = false;
  User user = new User();
  String _token = "";

  TextEditingController nrpController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController pangkatController = TextEditingController();
  TextEditingController jabatanController = TextEditingController();
  TextEditingController kesatuanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<bool> _onWillPop() async {
    return true;
    // return (await showDialog(
    //       context: context,
    //       builder: (context) => new AlertDialog(
    //         title: new Text('Are you sure?'),
    //         content: new Text('Do you want to exit an App'),
    //         actions: <Widget>[
    //           TextButton(
    //             onPressed: () => Navigator.of(context).pop(false),
    //             child: new Text('No'),
    //           ),
    //           TextButton(
    //             onPressed: () => Navigator.of(context).pop(true),
    //             child: new Text('Yes'),
    //           ),
    //         ],
    //       ),
    //     )) ??
    //     false;
  }

  _submit() async {
    setState(() {
      visible = true;
    });

    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? "";
    try {
      var res = await http.post(
          Uri.parse(BASE_URL_API + "api/main/ubah_biodata_pegawai"),
          headers: {
            'Authorization': _token,
          },
          body: {
            "nama_lengkap": namaController.text,
            "nrp": nrpController.text,
            "pangkat": pangkatController.text,
            "jabatan": jabatanController.text,
            "kesatuan": kesatuanController.text,
          }).timeout(const Duration(seconds: 10));
      print(parseHtmlString(res.body.toString()));

      if (res.statusCode == 200) {
        var response = json.decode(res.body);
        print(response);
        if (response['status'] == 1) {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(response['message']),
              backgroundColor: Colors.green,
            ));
            visible = false;
          });
          _getUserInfo();
        } else {
          setState(() {
            visible = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.deepOrange,
          ));
        }
      } else {
        showFailResponseMessage();
      }
    } catch (e) {
      print(e.toString());
      showFailResponseMessage();
    }
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
        setState(() {
          visible = false;
          nrpController = TextEditingController(text: user.nrp);
          namaController = TextEditingController(text: user.nama_lengkap);
          pangkatController = TextEditingController(text: user.pangkat);
          jabatanController = TextEditingController(text: user.jabatan);
          kesatuanController = TextEditingController(text: user.kesatuan);
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

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
    ));
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              elevation: 2,
              title: const Text(
                'Ubah Biodata',
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.white,
              brightness: Brightness.light,
            ),
            body: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Column(children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                                      'Form Ubah Biodata',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Row(children: <Widget>[
                                    Expanded(child: Divider()),
                                    Expanded(child: Divider()),
                                  ]),
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'NRP',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextField(
                                                  controller: nrpController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: <
                                                      TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  decoration: InputDecoration(
                                                      hintText: "Masukkan NRP",
                                                      border: InputBorder.none,
                                                      fillColor:
                                                          Color(0xfff3f3f4),
                                                      filled: true))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Nama Lengkap',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextField(
                                                  controller: namaController,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          "Masukkan Nama Lengkap",
                                                      border: InputBorder.none,
                                                      fillColor:
                                                          Color(0xfff3f3f4),
                                                      filled: true))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Pangkat',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextField(
                                                  controller: pangkatController,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          "Masukkan Pangkat",
                                                      border: InputBorder.none,
                                                      fillColor:
                                                          Color(0xfff3f3f4),
                                                      filled: true))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Jabatan',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextField(
                                                  controller: jabatanController,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          "Masukkan Jabatan",
                                                      border: InputBorder.none,
                                                      fillColor:
                                                          Color(0xfff3f3f4),
                                                      filled: true))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Kesatuan',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextField(
                                                  controller:
                                                      kesatuanController,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          "Masukkan Kesatuan",
                                                      border: InputBorder.none,
                                                      fillColor:
                                                          Color(0xfff3f3f4),
                                                      filled: true))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(children: <Widget>[
                                    Expanded(child: Divider()),
                                    Expanded(child: Divider()),
                                  ]),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        icon: Icon(
                                          Icons.save,
                                          color: Colors.white,
                                          size: 24.0,
                                        ),
                                        onPressed: () {
                                          _submit();
                                        },
                                        label: Text('SIMPAN'),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(3.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ])))));
  }
}
