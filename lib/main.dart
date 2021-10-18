import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{  //1層（土台）
  @override //親クラスのメソッド上書き
  Widget build(BuildContext context){ //BuildContext = Element
                                      //Elementは画面描画用の情報をもつ
    return MaterialApp( //2層
      home:Scaffold(  //3層
        appBar: AppBar( //4層
          title: Text("App Bar"),
        ),
        body: Center( //4層
          child: Text("body"),
        ),
      )
    );
  }
}
// 1. 起動時に最初に呼び出されるのは、main関数。
// 2. main関数からrunApp関数を呼び出すことで、アプリが実行される。
// 3. runApp関数に引数で指定した、StatelessWidgetを継承したクラスがアプリ本体のUIとなる。
// 4. StatelessWidgetを継承したクラスには、build関数を用意し、MaterialAppインスタンスを返す