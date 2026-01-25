import 'dart:io';
import 'package:dio/dio.dart';
import 'package:storemanager/data/shared_preferences_data.dart';
import '../utilities/snack_bar_view.dart';
import 'api_foundation.dart';

class ApiCalls{
  late Dio _dio;
    ApiCalls()
      : _dio = Dio(BaseOptions(
    baseUrl: ApiFoundation.baseUrl(),
    connectTimeout: const Duration(seconds: 4500),
    receiveTimeout: const Duration(seconds: 4500),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  Future<void> initializeDio() async {
    final preference = SharedPreferencesData();
    var token = await preference.getAccessToken();
    print(token);

    _dio = Dio(BaseOptions(
      baseUrl:  ApiFoundation.baseUrl(),
      connectTimeout: const Duration(seconds: 50),
      receiveTimeout: const Duration(seconds: 50),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ));
  }

  Future<Response> getMethod(String endpoint) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.get(endpoint);
          return response;
        }on DioException catch (dioError) {
          if (dioError.response != null) {
            return dioError.response!;
          } else {
            if (dioError.type == DioExceptionType.connectionTimeout) {
              SnackBarView.showErrorMessage("Connection timed out. Please try again.");
              throw Exception("Connection timed out.");
            } else if (dioError.type == DioExceptionType.receiveTimeout) {
              SnackBarView.showErrorMessage("Request timed out. Please check your internet connection.");
              throw Exception("Request timed out.");
            } else {
              SnackBarView.showErrorMessage("Network error: ${dioError.message}");
              throw Exception("Network error: ${dioError.message}");
            }
          }
        }
      }  else {
        connectivityNotifier.setConnected(false); // Update notifier
        //SnackBarView.showErrorMessage("No Internet Connection");
        throw Exception("No internet connection.");
      }
    } on SocketException catch (_) {
      connectivityNotifier.setConnected(false); // Update notifier
      // SnackBarView.showErrorMessage("No Internet Connection");
      throw Exception("No internet connection.");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }

  Future<Response> postMethod(String endpoint, Map<String, dynamic> data) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(endpoint, data: data);
          return response;
        } on DioException catch (dioError) {
          if (dioError.response != null) {
            return dioError.response!;
          } else {
            if (dioError.type == DioExceptionType.connectionTimeout) {
              SnackBarView.showErrorMessage("Connection timed out. Please try again.");
              throw Exception("Connection timed out.");
            } else if (dioError.type == DioExceptionType.receiveTimeout) {
              SnackBarView.showErrorMessage("Request timed out. Please check your internet connection.");
              throw Exception("Request timed out.");
            } else {
              SnackBarView.showErrorMessage("Network error: ${dioError.message}");
              throw Exception("Network error: ${dioError.message}");
            }
          }
        }
      }  else {
        connectivityNotifier.setConnected(false);
      //  SnackBarView.showErrorMessage("No Internet Connection");
        throw Exception("No internet connection.");
      }
    } on SocketException catch (_) {
      connectivityNotifier.setConnected(false);
      // SnackBarView.showErrorMessage("No Internet Connection");
      throw Exception("No internet connection.");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }

  Future<Response> putMethod(String endpoint, Map<String, dynamic> data) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.put(endpoint, data: data);
          return response;
        } on DioException catch (dioError) {
          if (dioError.response != null) {
            return dioError.response!;
          } else {
            if (dioError.type == DioExceptionType.connectionTimeout) {
              SnackBarView.showErrorMessage("Connection timed out. Please try again.");
              throw Exception("Connection timed out.");
            } else if (dioError.type == DioExceptionType.receiveTimeout) {
              SnackBarView.showErrorMessage("Request timed out. Please check your internet connection.");
              throw Exception("Request timed out.");
            } else {
              SnackBarView.showErrorMessage("Network error: ${dioError.message}");
              throw Exception("Network error: ${dioError.message}");
            }
          }
        }
      }  else {
        connectivityNotifier.setConnected(false);
       // SnackBarView.showErrorMessage("No Internet Connection");
        throw Exception("No internet connection.");
      }
    } on SocketException catch (_) {
      connectivityNotifier.setConnected(false);
    //  SnackBarView.showErrorMessage("No Internet Connection");
         throw Exception("No internet connection.");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }

  Future<Response>deleteMethod(String endpoint, Map<String, dynamic> data) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.delete(endpoint, data: data);
          return response;
        } on DioException catch (dioError) {
          if (dioError.response != null) {
            return dioError.response!;
          } else {
            if (dioError.type == DioExceptionType.connectionTimeout) {
              SnackBarView.showErrorMessage("Connection timed out. Please try again.");
              throw Exception("Connection timed out.");
            } else if (dioError.type == DioExceptionType.receiveTimeout) {
              SnackBarView.showErrorMessage("Request timed out. Please check your internet connection.");
              throw Exception("Request timed out.");
            } else {
              SnackBarView.showErrorMessage("Network error: ${dioError.message}");
              throw Exception("Network error: ${dioError.message}");
            }
          }
        }
      }  else {
        connectivityNotifier.setConnected(false);
      //  SnackBarView.showErrorMessage("No Internet Connection");
        throw Exception("No internet connection.");
      }
    } on SocketException catch (_) {
      connectivityNotifier.setConnected(false);
     // SnackBarView.showErrorMessage("No Internet Connection");
      throw Exception("No internet connection.");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }


  Future<void> multiPartInitializeDio() async {
    final preference = SharedPreferencesData();
    var token = await preference.getAccessToken();
    print("token::: $token");
    _dio = Dio(BaseOptions(
      baseUrl:  ApiFoundation.baseUrl(),
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ));
  }

  Future<Response> multipartPostMethod(String endpoint, FormData data) async { // Changed parameter type
    try {
      final result = await InternetAddress.lookup('google.com'); // Internet check
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(endpoint, data: data); // Pass FormData directly
          return response;
        } on DioException catch (dioError) {
          if (dioError.response != null) {
            return dioError.response!;
          } else {
            if (dioError.type == DioExceptionType.connectionTimeout) {
              SnackBarView.showErrorMessage("Connection timed out. Please try again.");
              throw Exception("Connection timed out.");
            } else if (dioError.type == DioExceptionType.receiveTimeout) {
              SnackBarView.showErrorMessage("Request timed out. Please check your internet connection.");
              throw Exception("Request timed out.");
            } else {
              SnackBarView.showErrorMessage("Network error: ${dioError.message}");
              throw Exception("Network error: ${dioError.message}");
            }
          }
        }
      }  else {
        connectivityNotifier.setConnected(false);
        // SnackBarView.showErrorMessage("No Internet Connection");
        throw Exception("No internet connection.");
      }
    } on SocketException catch (_) {
      connectivityNotifier.setConnected(false);
      // SnackBarView.showErrorMessage("No Internet Connection");
      throw Exception("No internet connection.");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }

  Future<Response> multipartPatchMethod(String endpoint, FormData data) async { // Changed parameter type
    try {
      final result = await InternetAddress.lookup('google.com'); // Internet check
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.patch(endpoint, data: data); // Pass FormData directly
          return response;
        } on DioException catch (dioError) {
          if (dioError.response != null) {
            return dioError.response!;
          } else {
            if (dioError.type == DioExceptionType.connectionTimeout) {
              SnackBarView.showErrorMessage("Connection timed out. Please try again.");
              throw Exception("Connection timed out.");
            } else if (dioError.type == DioExceptionType.receiveTimeout) {
              SnackBarView.showErrorMessage("Request timed out. Please check your internet connection.");
              throw Exception("Request timed out.");
            } else {
              SnackBarView.showErrorMessage("Network error: ${dioError.message}");
              throw Exception("Network error: ${dioError.message}");
            }
          }
        }
      }  else {
        connectivityNotifier.setConnected(false);
        // SnackBarView.showErrorMessage("No Internet Connection");
        throw Exception("No internet connection.");
      }
    } on SocketException catch (_) {
      connectivityNotifier.setConnected(false);
      // SnackBarView.showErrorMessage("No Internet Connection");
      throw Exception("No internet connection.");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }

  Future<Response> patchMethod(String endpoint, Map<String, dynamic> data) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.patch(endpoint, data: data);
          return response;
        } on DioException catch (dioError) {
          if (dioError.response != null) {
            return dioError.response!;
          } else {
            if (dioError.type == DioExceptionType.connectionTimeout) {
              SnackBarView.showErrorMessage("Connection timed out. Please try again.");
              throw Exception("Connection timed out.");
            } else if (dioError.type == DioExceptionType.receiveTimeout) {
              SnackBarView.showErrorMessage("Request timed out. Please check your internet connection.");
              throw Exception("Request timed out.");
            } else {
              SnackBarView.showErrorMessage("Network error: ${dioError.message}");
              throw Exception("Network error: ${dioError.message}");
            }
          }
        }
      } else {
        connectivityNotifier.setConnected(false);
        // SnackBarView.showErrorMessage("No Internet Connection");
        throw Exception("No internet connection.");
      }
    } on SocketException catch (_) {
      connectivityNotifier.setConnected(false);
      // SnackBarView.showErrorMessage("No Internet Connection");
      throw Exception("No internet connection.");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }


}