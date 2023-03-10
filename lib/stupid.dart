
import 'dart:html';
import 'dart:indexed_db';
import 'dart:io';

class Stupid {
  String apiKey;
  String baseUrl;
  String? deviceId;

  Stupid({required this.apiKey, required this.baseUrl, this.deviceId}){
    if (baseUrl.endsWith("/")){
      baseUrl = baseUrl.substring(0, baseUrl.length-2);
    }
  }

  void log() {
    var out = Uri.https("")
    var req = HttpRequest();
    req.open("POST", "${baseUrl}/log", );
  }
}