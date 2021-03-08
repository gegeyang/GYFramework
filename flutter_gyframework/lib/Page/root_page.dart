import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Page'),
          leading: naviBack(),
          // Icon(Icons.home),
          leadingWidth: 5,
          backgroundColor: Color(0xff0488EC),
        ),
        body: Center(
          child: Image(
            width: 5,
            height: 5,
            color: Colors.green,
            image: AssetImage('images/common_back.png'),
          ),
          // child: Image.asset('common_back.png'),
        ),
      ),
    );
  }
  Widget naviBack() {
    return Container(
      color: Colors.red,
      child: Image(
        image: AssetImage('images/common_back.png'),
      ),
    );
  }
}
