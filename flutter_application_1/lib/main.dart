import 'package:flutter/cupertino.dart';
import 'Vistas/vista_falla.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Vistas/Inicio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InicioChatGPT(),
    );
  
   
  }
}