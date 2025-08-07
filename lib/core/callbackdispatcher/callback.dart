// import 'dart:convert';
// import 'dart:developer';
// import 'package:http/http.dart' as http;
// import 'package:workmanager/workmanager.dart';

// import '../../controller/home/home_controller.dart';
// import '../../helper/init/init.dart';

// void callbackDispatcher() {
  // Workmanager().executeTask((task, inputData) async {
  //   try {
  //     if (task == "executeApiCall") {
  //       log("🚀 Running Background API Call...");
  //
  //       // Enhanced logging and error handling
  //       try {
  //         await MainBinding().dependencies();
  //         log("✅ Dependencies Initialized");
  //
  //         await HomeController.to.changeDriverOnlineStatus();
  //         log("✅ Driver Online Status Changed");
  //       } catch (dependencyError) {
  //         log("❌ Dependency or Status Change Error: $dependencyError");
  //         return Future.value(false);
  //       }
  //     }
  //     return Future.value(true);
  //   } catch (generalError) {
  //     log("❌ General Error in Callback Dispatcher: $generalError");
  //     return Future.value(false);
  //   }
  // });
// }
