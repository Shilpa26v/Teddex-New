import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

Future<bool> launchUrl(String url) async {
  var canLaunch = await url_launcher.canLaunch(url);
  if (canLaunch) {
    url_launcher.launch(url).whenComplete(() => debugPrint("launchUrl -> $url"));
  }
  return canLaunch;
}
