import 'package:flutter/material.dart';
import './ui/task_screen.dart';
import './ui/new_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        // brightness: Brightness.dark,
      ),
      // home: MyHomePage(),
      initialRoute: '/',
      routes: {
        '/': (context) => TaskScreen(),
        '//': (context) => NewTask(),
      },
    );
  }
}