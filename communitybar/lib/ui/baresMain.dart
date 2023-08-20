import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BaresMain extends StatelessWidget {
  final Bar bar;
  final String selectedImageUrl;

  BaresMain({required this.bar, required this.selectedImageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del bar - ${bar.name}'),
      ),
      body: Column(
        children: [
          Image.network(selectedImageUrl,
              fit: BoxFit.cover), // Muestra la imagen seleccionada al principio
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: bar.menu.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Image.network(
                        bar.menu[index].url,
                        fit: BoxFit.cover,
                      ),
                      Text(bar.menu[index].name),
                      Text('\$${bar.menu[index].price.toString()}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
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
  final String namePhoto;
  final String url;

  Menu({
    required this.name,
    required this.price,
    required this.namePhoto,
    required this.url,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      name: json['name'],
      price: json['price'].toDouble(),
      namePhoto: json['namePhoto'],
      url: json['url'],
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
