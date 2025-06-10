import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Comenzamos en la esquina superior izquierda
    path.moveTo(0, 0);

    // Vamos al borde inferior izquierdo
    path.lineTo(0, size.height * 0.8);

    // Curva prominente en el centro (punto de control en el centro pero más abajo)
    path.quadraticBezierTo(
      size.width * 0.5, // Centro horizontal
      size.height * 1.20, // Punto de control - configurable
      size.width, // Termina en esquina inferior derecha
      size.height * 0.8, // Misma altura que el lado izquierdo
    );

    path.lineTo(size.width, 0); // Esquina superior derecha
    path.close(); // Cerramos el camino

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
