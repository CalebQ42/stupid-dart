
import 'package:dotenv/dotenv.dart';
import 'package:platform_info/platform_info.dart';
import 'package:http/http.dart';
import 'package:stupid/crash.dart';

class Stupid {
  Uri baseUrl;
  String deviceId;
  late String plat;
  String? apiKey;

  Stupid({required this.baseUrl, required this.deviceId}){
    if(!platform.isWeb){
      var dot = DotEnv()..load([".stupid"]);
      dot.getOrElse("STUPID_KEY", () => throw("must provide .stupid with STUPID_KEY={API key}"));
    }
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