import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './config.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.title = ""}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool visible = false;

  @override
  void initState() {
    super.initState();
  }

  _cekLogin() async {
    setState(() {
      visible = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var params = "api/init/login?username=" +
        userNameController.text +
        "&password=" +
        passwordController.text;

    try {
      var res = await http
          .get(Uri.parse(BASE_URL_API + params))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        var response = json.decode(res.body);
        print(response);
        if (response['status'] == 1) {
          prefs.setBool('slogin', true);
          prefs.setString('token', response['token']);
          prefs.setString('nama_pegawai', response['nama_pegawai']);
          setState(() {
            visible = false;
          });

          Navigator.of(context).pushNamedAndRemoveUntil(
              '/landing', (Route<dynamic> route) => false);
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
      print(e);
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
    ));
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back, color: Colors.white),
          //   onPressed: () => SystemNavigator.pop(),
          // ),
          elevation: 0,
          title: const Text('Login', style: TextStyle(color: Colors.white)),
          brightness: Brightness.dark,
        ),
        body: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Center(
                          child: new Image.asset(
                            "assets/icon.png",
                            height: 70.0,
                            width: 200.0,
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.only(top: 20),
                          child: new Center(
                            child: Text(
                              "APLIKASI PENGAJUAN PENSIUN",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
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
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Username',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                              controller: userNameController..text,
                              obscureText: false,
                              decoration: InputDecoration(
                                  hintText: "Masukkan Username",
                                  border: InputBorder.none,
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true))
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Password',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                              controller: passwordController..text,
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: "Masukkan Password",
                                  border: InputBorder.none,
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  offset: Offset(2, 4),
                                  blurRadius: 5,
                                  spreadRadius: 2)
                            ],
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xfffbb448),
                                  Color(0xfff7892b)
                                ])),
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      onTap: _cekLogin,
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
