import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget{

  @override
  _MyWidgetState createState() => _MyWidgetState();

}

class _MyWidgetState extends State {

  int _counter = 0;
  void _incrementCounter(){
    setState(() => _counter++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Push Button!")),
      body: Center(child: Text("$_counter")),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        ),
    );
  }

}