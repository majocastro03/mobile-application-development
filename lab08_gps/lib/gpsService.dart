import 'package:geolocator/geolocator.dart';

class GpsService {
  Future<Position> obtenerGps() async {
    bool bGpsHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!bGpsHabilitado) {
      return Future.error('Por favor habilite el servicio de ubicación.');
    }
    LocationPermission bGpsPermiso = await Geolocator.checkPermission();
    if (bGpsPermiso == LocationPermission.denied) {
      bGpsPermiso = await Geolocator.requestPermission();
      if (bGpsPermiso == LocationPermission.denied) {
        return Future.error('Se denegó el permiso para obtener la ubicación.');
      }
    }
    if (bGpsPermiso == LocationPermission.deniedForever) {
      return Future.error('Permiso de ubicación denegado permanentemente.');
    }
    return await Geolocator.getCurrentPosition();
  }
}
