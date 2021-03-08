import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gyframework/Page/root_page.dart';
import 'dart:ui';

/**
 * 接收原生传来的路由名：可以根据routename指定显示的页面
 * */
void main() => runApp(MyApp(nativePageRouteName: window.defaultRouteName));


class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  final String nativePageRouteName;
  const MyApp({Key key, this.nativePageRouteName}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootPage(nativePageRouteName: widget.nativePageRouteName),
    );
  }
}




