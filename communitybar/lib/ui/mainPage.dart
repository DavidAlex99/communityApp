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

              // Aplana todas las imágenes de todos los bares en una lista única
              List<Poster> posters = bars.expand((bar) => bar.poster).toList();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: posters.length,
                  itemBuilder: (context, index) {
                    return _buildGridItem(
                        posters[index].url, posters[index].namePhoto, context);
                  },
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

  Widget _buildGridItem(
      String imageUrl, String namePhoto, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Aquí, la navegación puede ser un poco diferente ya que estás tratando con una imagen y no con un bar completo
        // Tal vez quieras navegar a una vista detallada de la imagen, o simplemente quitar el GestureDetector si no quieres ninguna acción al tocar la imagen
      },
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  }
}
