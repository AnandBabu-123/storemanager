import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:storemanager/routes/app_routes.dart';
import 'package:storemanager/screens/authentication_views/login_view.dart';
import 'package:storemanager/screens/dash_board.dart';
import 'controllers/authController.dart';
import 'data/api_foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<String>(
        future: authController.getInitialRoute(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data == AppRoutes.loginView) {
            return LoginView();
          } else {
            return DashboardView();
          }
        },
      ),
      getPages: AppRoutes.routes,
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Directionality(
//           textDirection: TextDirection.ltr,
//           child: InternetIndicator(),
//         ),
//         Expanded(
//           child: GetMaterialApp(
//             debugShowCheckedModeBanner: false,
//             theme: ThemeData(
//               colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//               useMaterial3: true,
//             ),
//             initialRoute: AppRoutes.loginView,
//             getPages: AppRoutes.routes,
//           ),
//         ),
//       ],
//     );
//   }
// }
