import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BaresMain extends StatefulWidget {
  final String barName;

  BaresMain({required this.barName});

  @override
  _BaresMainState createState() => _BaresMainState();
}

class _BaresMainState extends State<BaresMain> {
  late Future<Bar> futureBar;

  @override
  void initState() {
    super.initState();
    futureBar = fetchBar(widget.barName);
  }

  Future<Bar> fetchBar(String barName) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/api/bares/$barName'));
    if (response.statusCode == 200) {
      return Bar.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar los datos del bar.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.barName),
      ),
      body: FutureBuilder<Bar>(
        future: futureBar,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              Bar bar = snapshot.data!;
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class Bar {
  final String name;
  final String ubication;
  final List<Menu> menu;
  final List<Poster> poster;

  Bar({
    required this.name,
    required this.ubication,
    required this.menu,
    required this.poster,
  });

  factory Bar.fromJson(Map<String, dynamic> json) {
    return Bar(
      name: json['name'],
      ubication: json['ubication'],
      menu: (json['menu'] as List).map((i) => Menu.fromJson(i)).toList(),
      poster: (json['poster'] as List).map((i) => Poster.fromJson(i)).toList(),
    );
  }
}

class Menu {
  final String name;
  final double price;

  Menu({required this.name, required this.price});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }
}

class Poster {
  final String namePhoto;
  final String url;

  Poster({required this.namePhoto, required this.url});

  factory Poster.fromJson(Map<String, dynamic> json) {
    return Poster(
      namePhoto: json['namePhoto'],
      url: json['url'],
    );
  }
}
