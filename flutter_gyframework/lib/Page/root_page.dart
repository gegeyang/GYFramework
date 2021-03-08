import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';

class RootPage extends StatefulWidget {
  @override
  final String nativePageRouteName;

  const RootPage({Key key, this.nativePageRouteName}) : super(key: key);

  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  //建立消息频道，与原生交互消息
  final MethodChannel flutterChannel = MethodChannel('EachOtherChannel');

  var titleString = '';

  void initState() {
    // TODO: implement initState
    super.initState();

    //处理原生传来的消息
    flutterChannel.setMethodCallHandler((MethodCall call) {
      if(call.method == 'invokeFlutterMethod') {
        titleString = call.arguments['title'];
        setState(() {
        });
      }
    });

  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.nativePageRouteName),
          leading: navieLeading(),
          backgroundColor: Color(0xff0488EC),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Text(
                  titleString,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget navieLeading() {
    return IconButton(
      icon: Icon(Icons.home),
      onPressed: () {
        flutterChannel.invokeMethod('exit');
      },
    );
  }
}
