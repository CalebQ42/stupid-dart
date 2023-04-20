import 'dart:convert';

import 'package:platform_info/platform_info.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

class Stupid {
  Uri baseUrl;
  String deviceId;
  late String plat;
  String? apiKey;

  Stupid({required this.baseUrl, required this.deviceId, this.apiKey}){
    if(apiKey == null) throw("apiKey must be provided");
    platform.when(
      io: () => platform.when(
        fuchsia:   () => plat = "fuchsia",
        windows:   () => plat = 'windows',
        android:   () => plat = 'android',
        iOS:       () => plat = 'iOS',
        macOS:     () => plat = 'macOS',
        linux:     () => plat = 'linux',
        unknown:   () => plat = 'unknown',
      ),
      web: () => plat = "web",
      unknown: () => plat = "unknown"
    );
  }

  Future<bool> log() async {
    try{
      var resp = await post(
        baseUrl.resolveUri(
          Uri(
            path: "/log",
            queryParameters: {
              "key": apiKey,
              "id": deviceId,
              "platform": plat,
            }
          )
        )
      ).timeout(const Duration(milliseconds: 500));
      return resp.statusCode == 201;
    }catch(e){
      return false;
    }
  }

  Future<bool> crash(Crash cr) async{
    try{
      var bod = <String, String>{
        "id": cr.id,
        "error": cr.error,
        "platform": plat,
        "stack": cr.stack
      };
      var outBod = JsonEncoder().convert(bod);
      var resp = await post(
        baseUrl.resolveUri(
          Uri(
            path: "/crash",
            queryParameters: {
              "key": apiKey,
            }
          )
        ),
        headers: <String, String>{
          "content-type": "application/json",
        },
        body: outBod,
      ).timeout(const Duration(milliseconds: 500));
      return resp.statusCode == 201;
    }catch(e){
      return false;
    }
  }
}

class Crash{
  String id = Uuid().v4();
  String error;
  String stack;

  Crash({required this.error, required this.stack});
}