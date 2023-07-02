import 'dart:convert';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:platform_info/platform_info.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

class Stupid {
  final Uri baseUrl;
  final String deviceId;
  late String plat;
  final String apiKey;
  final void Function(Object, StackTrace)? onError;
  final InternetConnection con;
  final bool waitForInternet;

  Stupid({
    required this.baseUrl,
    required this.deviceId,
    required this.apiKey,
    this.waitForInternet = true,
    this.onError
  }) :
    con = InternetConnection.createInstance()
  {
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
    if(waitForInternet && !await con.hasInternetAccess){
      await con.onStatusChange.where((event) => event == InternetStatus.connected).first;
    }
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
      );
      return resp.statusCode == 201;
    }catch(e, stack){
      if(onError != null) onError!(e, stack);
      return false;
    }
  }

  Future<bool> crash(Crash cr) async{
    if(waitForInternet && !await con.hasInternetAccess){
      await con.onStatusChange.where((event) => event == InternetStatus.connected).first;
    }
    try{
      var bod = <String, String>{
        "id": cr.id,
        "error": cr.error,
        "platform": plat,
        "stack": cr.stack,
        "version": cr.version
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
      );
      return resp.statusCode == 201;
    }catch(e, stack){
      if(onError != null) onError!(e, stack);
      return false;
    }
  }
}

class Crash{
  String id = Uuid().v4();
  String error;
  String stack;
  String version;

  Crash({required this.error, required this.stack, this.version = "unknown"});
}