import 'package:get/get.dart';
import 'package:waiver_driver/backend/api/api_services/api_services.dart';
import 'package:waiver_driver/backend/api/api_services/urls.dart';
import 'package:waiver_driver/backend/parser/DriverTypeSelection/DriverTypeSelection_Parser.dart';
import 'package:waiver_driver/backend/parser/Login/login_parser.dart';
import 'package:waiver_driver/backend/parser/Signin/signin_parser.dart';
import 'package:waiver_driver/backend/parser/splash/splash_parser.dart';

class MainBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    // Get.put<NetworkController>(NetworkController(), permanent: true);

    Get.lazyPut(() => ApiServices(appBaseUrl: AppUrls.base));

    Get.lazyPut(() => SplashParser(apiService: Get.find()), fenix: true);

        Get.lazyPut(() => SignInParser(apiService: Get.find()), fenix: true);

    Get.lazyPut(() => LoginParser(apiService: Get.find()), fenix: true);
    Get.lazyPut(() => DriverTypeSelectionParser(apiService: Get.find()), fenix: true);

    //   Get.lazyPut(() => ConnectivityBinding(), fenix: true);
    //   Get.lazyPut(
    //       () => LoginParser(
    //           apiService: Get.find(), sharedPreferencesManager: Get.find()),
    //       fenix: true);
    //
    //   Get.lazyPut(
    //     () => SignUpParser(
    //         apiService: Get.find(), sharedPreferencesManager: Get.find()),
    //   );
    // }
  }
}