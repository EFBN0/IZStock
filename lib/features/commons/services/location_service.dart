import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();

  static Future<Position> getLocalizacaoAtual() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('O serviço de localização está desativado.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permissão de localização negada');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Permissão de localização negada permanentemente, não podemos requisitar permissão.',
      );
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}
