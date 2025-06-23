import 'package:flutter/material.dart';
import 'package:medialert/providers/HistoricProvider.dart';
import 'package:medialert/providers/StatusProvider.dart';
import 'package:medialert/providers/IntakeProvider.dart';
import 'package:medialert/providers/MedicationProvider.dart';
import 'package:medialert/views/BaseScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StatusProvider()),
        ChangeNotifierProvider(create: (_) => IntakeProvider()),
        ChangeNotifierProvider(create: (_) => MedicationProvider()),
        ChangeNotifierProvider(create: (_) => HistoricProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Afacad'),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Imagen de fondo
        Positioned.fill(
          child: Image(
            image: AssetImage('assets/background_home.png'),
            fit: BoxFit.cover,
          ),
        ),
        // Contenido principal
        Column(
          children: [
            const SizedBox(height: 80),
            const Text(
              '¡Nunca olvides tu medicina!',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                fontFamily: 'Afacad',
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
            // Imagen central
            Center(
              child: Image(
                image: AssetImage('assets/ilustration_home.png'),
                width: 350,
                height: 400,
              ),
            ),
            Spacer(),
            // Texto pequeño en la parte inferior
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Te ayudaremos a recordar cada toma y llevar un historial organizado',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontFamily: 'Afacad',
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Botón mediano en la parte inferior
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: SizedBox(
                width: 200,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    //Vista Home
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BaseScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xAA07AA97),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Comenzar',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Afacad',
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
