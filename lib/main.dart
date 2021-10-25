import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    initialRoute: "/first",
    routes: <String, WidgetBuilder>{
      "/first": (BuildContext context) => FirstRoute(),
      "/second": (BuildContext context) => SecondRoute(),
    },
  ));
}

class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First Route"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingButton(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/second");
              },
              child: Text(
                "Push Here",
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Push Here",
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }
}

class FloatingButton extends StatefulWidget {
  @override
  ButtonState createState() => ButtonState();
}

class ButtonState extends State {
  //インスタンス作成
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  FirebaseFirestore _db = FirebaseFirestore.instance;

  //SharedPreferencesのロードメソッド
  Future<int> getCount() async {
    SharedPreferences prefs = await _prefs;
    return (prefs.getInt('counter') ?? 0);
  }

  //SharedPreference
  int _counter = 0;
  //FireStore
  int _counter2 = 0;

  //ボタン押下時
  void incrementCounter() async {
    //■■■読み込み
    //SharedPreference
    SharedPreferences prefs = await _prefs;

    //FireStore
    //collectionとdocumentを指定してsnapshotを受け取る
    DocumentSnapshot doc = await _db.collection('counter').doc('test').get();
    //単純に取り出すメソッド'get('フィールド')'メソッドではなく、data()メソッドを使って一度Map型に変換
    Map<String, dynamic> fields = doc.data() ?? {'count':0};

    //■■■１足して変数に代入
    setState(() {
      //SharedPreference
      _counter = (prefs.getInt('counter') ?? 0) + 1;
      //FireStore
      _counter2 = fields['count'] + 1;
    });

    //■■■書き込み
    //SharedPreference
    await prefs.setInt('counter', _counter);

    //FireStore
    //DocumentSnapshotは経由せず、連想型配列でフィールドを指定してFirestoreへ書き込み
    await _db.collection('counter').doc('test').set(
      {'count':_counter,}
    );

  }

  @override
  Widget build(BuildContext context) {
    //SharedPreferencesのロード（ボタン押下前(初回)ロードになる)
    getCount().then((value) {
      setState(() {
        _counter = value;
      });
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("$_counter"),
        Text("$_counter2"),
        FloatingActionButton(onPressed: incrementCounter),
      ],
    );
  }
}
