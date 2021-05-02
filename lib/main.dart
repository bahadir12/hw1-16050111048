import 'package:flutter/material.dart';
import 'package:mobileyhomework1/1/abc.dart';


void main() {
  runApp(MaterialApp(
    title: "Flutter Dersleri",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
    home: Scaffold(
      body: abc(),
    ),
  ));
}