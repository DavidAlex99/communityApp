import 'package:flutter/material.dart';
import 'package:communitybar/ui/baresMain.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<List<Bar>> futureBars;

  @override
  void initState() {
    super.initState();
    futureBars = fetchBars();
  }

  Future<List<Bar>> fetchBars() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:3000/api/bares/')); // Asume que tienes un endpoint que devuelve todos los bares
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((bar) => Bar.fromJson(bar)).toList();
    } else {
      throw Exception('Error al cargar los bares.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagina de visualizaciones'),
      ),
      body: FutureBuilder<List<Bar>>(
        future: futureBars,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<Bar> bars = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: bars.map((bar) {
                    return _buildGridItem(bar.poster[0].url, bar.name, context);
                  }).toList(),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildGridItem(String imageUrl, String barName, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navega a BaresMain cuando se toca la imagen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BaresMain(barName: barName),
          ),
        );
      },
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  }
}
