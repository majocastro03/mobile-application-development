import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lab08_gps/gpsService.dart';
import 'package:lab08_gps/mapsService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS App',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GpsService gpsService = GpsService();
  final MapService mapService = MapService();

  void _getOpenMap() async {
    try {
      Position posicion = await gpsService.obtenerGps();
      String urlMapa = mapService.generarUrlMapa(posicion);
      await mapService.abrirUrl(urlMapa);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GPS App')),
      body: Center(
        child: ElevatedButton(
          onPressed: _getOpenMap,
          child: Text('Obtener Ubicación'),
        ),
      ),
    );
  }
}
