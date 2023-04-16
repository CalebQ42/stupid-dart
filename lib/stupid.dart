import 'package:platform_info/platform_info.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

class Stupid {
  Uri baseUrl;
  String deviceId;
  late String plat;
  String? apiKey;

  Stupid({required this.baseUrl, required this.deviceId, this.apiKey}){
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
    if(plat != "web" && apiKey == null) throw("apiKey must be provided if not web");
  }

  Future<bool> log() async {
    var resp = await post(
      baseUrl.resolveUri(
        Uri(
          path: "/log",
          queryParameters: {
            if(plat != "web") "key": apiKey,
            "id": deviceId,
            "platform": plat,
          }
        )
      )
    );
    return resp.statusCode == 201;
  }

  Future<bool> crash(Crash cr) async{
    var resp = await post(
      baseUrl.resolveUri(
        Uri(
          path: "/crash",
          queryParameters: {
            if(plat != "web") "key": apiKey,
          }
        )
      ),
      body: <String, String>{
        "id": cr.id,
        "error": cr.error,
        "platform": plat,
        "stack": cr.stack
      }
    );
    return resp.statusCode == 201;
  }
}

class Crash{
  String id = Uuid().v4();
  String error;
  String stack;

  Crash({required this.error, required this.stack});
}