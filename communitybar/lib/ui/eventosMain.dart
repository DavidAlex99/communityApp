import 'package:flutter/material.dart';

//visualizar todos los eventos
class EvetosMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagina de visualizacion dentro de un evento'),
      ),
      body: Center(
        child: Text('Aqui estar las visualizacioes de los eventos'),
      ),
    );
  }
}
