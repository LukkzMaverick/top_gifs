import 'package:flutter/material.dart';
import 'package:share/';

class GifPage extends StatelessWidget {
  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    String title = _gifData["title"];
    title = capitalize(title);
    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        IconButton(
            icon: Icon(Icons.share),
            color: Colors.black,
            onPressed: () {
              Share.share(_linkImagem());
            })
      ], title: Text(title)),
      backgroundColor: Colors.black,
      body: Center(child: Image.network(_linkImagem())),
    );
  }

  String _linkImagem() {
    return _gifData["images"]["original"]["url"];
  }
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
Widget circularProgressIndicator() {
  return Container(
    width: 200,
    height: 200,
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      strokeWidth: 5,
    ),
  );
}
