import 'package:flutter/material.dart';
import 'package:top_gifs/ui/home_page.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(hintColor: Colors.black, primaryColor: Colors.white),
    ));
