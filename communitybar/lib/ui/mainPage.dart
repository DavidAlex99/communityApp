import 'package:flutter/material.dart';

//visualizar todos los eventos
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagina de visualizaciones'),
      ),
      body: Center(
        child: Text('Aqui estar las visualizacioes de los eventos'),
      ),
    );
  }
}
