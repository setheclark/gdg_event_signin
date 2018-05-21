import 'package:event_signin/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MaterialApp(
    title: "IO Extended 2018",
    theme: ThemeData(primarySwatch: Colors.blue),
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
