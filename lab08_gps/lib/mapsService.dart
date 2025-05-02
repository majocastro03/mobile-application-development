import 'package:geolocator/geolocator.dart';
import 'package:lab08_gps/gpsService.dart';
import 'package:url_launcher/url_launcher.dart';

class MapService {
  String generarUrlMapa(Position posicion) {
    return 'http://www.google.com/maps/place/${posicion.latitude},${posicion.longitude}';
  }

  Future<void> abrirUrl(String url) async {
    final Uri oUri = Uri.parse(url);
    try {
      await launchUrl(oUri, mode: LaunchMode.externalApplication);
    } catch (oError) {
      return Future.error('No se pudo abrir la URL: $oError');
    }
  }
}

void main() async {
  final gpsService = GpsService();
  final mapService = MapService();

  try {
    Position posicion = await gpsService.obtenerGps();
    String urlMapa = mapService.generarUrlMapa(posicion);
    await mapService.abrirUrl(urlMapa);
  } catch (e) {
    print('Error: $e');
  }
}
