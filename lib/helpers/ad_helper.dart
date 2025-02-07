import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId{
    if(Platform.isAndroid){
      return "ca-app-pub-2627101804586520/4515776768";
    }else if(Platform.isIOS){
      return "";
    }else{
      throw UnsupportedError("Unsupported platform");
    }
  }
}