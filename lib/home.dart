import './config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './beranda.dart';
import './pengajuan.dart';
import './akun.dart';

class HomeState extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<HomeState> {
  int _bottomNavIndex = 0;
  List<Widget> _container = [new Beranda(), new Pengajuan(), new Akun()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
    ));
    return new Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
        currentIndex: _bottomNavIndex,
        iconSize: 30,
        selectedFontSize: 15,
        unselectedFontSize: 15,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.assignment),
            title: new Text('Pengajuan'),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Akun'))
        ],
      ),
      body: _container[_bottomNavIndex],
    );
  }
}
