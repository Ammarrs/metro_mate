import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class MapUtils {
  static Future<void> openGoogleMapsDirections({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String travelMode = 'walking',
  }) async {
    final origin = '$originLat,$originLng';
    final destination = '$destLat,$destLng';

    if (Platform.isAndroid) {
      final Uri nativeUri = Uri.parse('google.navigation:q=$destination&mode=w');
      if (await canLaunchUrl(nativeUri)) {
        await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
        return;
      }
      await launchUrl(
        Uri.parse('https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=walking'),
        mode: LaunchMode.externalApplication,
      );
    } else if (Platform.isIOS) {
      final Uri googleUri = Uri.parse('comgooglemaps://?saddr=$origin&daddr=$destination&directionsmode=walking');
      if (await canLaunchUrl(googleUri)) {
        await launchUrl(googleUri, mode: LaunchMode.externalApplication);
        return;
      }
      await launchUrl(
        Uri.parse('https://maps.apple.com/?saddr=$origin&daddr=$destination&dirflg=w'),
        mode: LaunchMode.externalApplication,
      );
    } else {
      await launchUrl(
        Uri.parse('https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=walking'),
        mode: LaunchMode.externalApplication,
      );
    }
  }
}