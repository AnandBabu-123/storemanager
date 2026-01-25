
import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ApiFoundation {

  static String baseUrl(){
    if(kDebugMode){
    return "http://3.111.125.81/";
  }else if(kProfileMode){
      return "http://3.111.125.81/";
    }else{
      return "http://3.111.125.81/";
    }
  }


  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      return false; // No network at all
    }

    // 🔹 Perform an actual internet lookup
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        return true; // Internet is accessible
      }
    } catch (e) {
      return false; // No internet access despite network connection
    }

    return false;
  }

}
class ConnectivityNotifier extends ValueNotifier<bool> {
  bool _restored = false;

  ConnectivityNotifier() : super(true); // Assume initially connected

  void setConnected(bool isConnected) {
    if (isConnected && !value) {
      _restored = true;
      notifyListeners();
      Timer(Duration(seconds: 3), () {
        _restored = false;
        notifyListeners();
      });
    }
    value = isConnected;
    notifyListeners();
  }

  bool get restored => _restored;
}

final connectivityNotifier = ConnectivityNotifier();

class InternetIndicator extends StatelessWidget {
  const InternetIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: connectivityNotifier,
      builder: (context, isConnected, child) {
        if (!isConnected) {
          return Container(
            color: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.signal_cellular_nodata,color: Colors.white,size: 20,),
                    SizedBox(width: 5,),
                    Text(
                      "No Internet Connection",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (connectivityNotifier.restored) {
          return Container(
            color: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle,color: Colors.white,size: 20,),
                    SizedBox(width: 5,),
                    Text(
                      "Internet Connection Restored",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return SizedBox.shrink(); // Hide when connected
        }
      },
    );
  }
}

