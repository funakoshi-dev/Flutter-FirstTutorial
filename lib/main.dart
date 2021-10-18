import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

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
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<int> getCount() async {
    SharedPreferences prefs = await _prefs;
    return (prefs.getInt('counter') ?? 0);
  }

  int _counter = 0;

  void incrementCounter() async {
    SharedPreferences prefs = await _prefs;
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0) + 1;
    });
    await prefs.setInt('counter', _counter);
  }

  @override
  Widget build(BuildContext context) {
    getCount().then((value) {
      setState(() {
        _counter = value;
      });
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("$_counter"),
        FloatingActionButton(onPressed: incrementCounter),
      ],
    );
  }
}
