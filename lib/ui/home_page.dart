import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:top_gifs/ui/gif_page.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controllerTextoPesquisa;
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;
    if (_search == null)
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=uuNz73GbPaY36O9abxfCZLFQ7undGP0O&limit=25&offset=$_offset&rating=G");
    else
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=uuNz73GbPaY36O9abxfCZLFQ7undGP0O&q=$_search&limit=25&offset=$_offset&rating=G&lang=en");

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _controllerTextoPesquisa = new TextEditingController(text: "");
    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.fromLTRB(25, 8, 8, 8),
            icon: Icon(Icons.home),
            color: Colors.white,
            onPressed: () {
              setState(() {
                _controllerTextoPesquisa.clear();
                _search = null;
                _offset = 0;
              });
            },
          )
        ],
        backgroundColor: Colors.black,
        title: Image.asset(
          'images/PoweredBy.png',
          fit: BoxFit.cover,
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _controllerTextoPesquisa,
                onSubmitted: (text) {
                  setState(() {
                    _search = text;
                    _offset = 0;
                  });
                },
                decoration: InputDecoration(
                    labelText: "Pesquise aqui!",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder()),
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              )),
          Expanded(
              child: FutureBuilder(
                  future: _getGifs(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return circularProgressIndicator();
                      default:
                        if (snapshot.hasError)
                          return Center(
                            child: Text("Error"),
                          );
                        else
                          return _createGifTable(context, snapshot);
                    }
                  }))
        ],
      ),
    );
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: snapshot.data["data"].length + 1,
      itemBuilder: (context, index) {
        if (index < snapshot.data["data"].length)
          return GestureDetector(
              onLongPress: () {
                Share.share(snapshot.data["data"][index]["images"]
                    ["fixed_height"]["url"]);
              },
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GifPage(snapshot.data["data"][index])));
              },
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height"]
                    ["url"],
                height: 300,
                fit: BoxFit.cover,
              ));
        else
          return Container(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _offset += 25;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70,
                  ),
                  Text(
                    "Carregar mais...",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  )
                ],
              ),
            ),
          );
      },
    );
  }
}

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
