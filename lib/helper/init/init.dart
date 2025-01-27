import 'package:get/get.dart';
import 'package:waiver_driver/backend/api/api_services/api_services.dart';
import 'package:waiver_driver/backend/api/api_services/urls.dart';
import 'package:waiver_driver/backend/parser/Aadhar/aadhart_parser.dart';
import 'package:waiver_driver/backend/parser/ChauffeurProof/ChauffeurProof_parser.dart';
import 'package:waiver_driver/backend/parser/DriverTypeSelection/DriverTypeSelection_Parser.dart';
import 'package:waiver_driver/backend/parser/Earning/earningscreen_parser.dart';
import 'package:waiver_driver/backend/parser/FleetHomePage/fleet_home_page_parser.dart';
import 'package:waiver_driver/backend/parser/Home/home_parser.dart';
import 'package:waiver_driver/backend/parser/Login/login_parser.dart';
import 'package:waiver_driver/backend/parser/MyRide/myridescreen_parser.dart';
import 'package:waiver_driver/backend/parser/Notification/notification_parser.dart';
import 'package:waiver_driver/backend/parser/Profile/profilescreen_parser.dart';
import 'package:waiver_driver/backend/parser/Rating/ratingscreen_parser.dart';
import 'package:waiver_driver/backend/parser/Registration/registration_parser.dart';
import 'package:waiver_driver/backend/parser/Settings/settings_parser.dart';
import 'package:waiver_driver/backend/parser/Signin/signin_parser.dart';
import 'package:waiver_driver/backend/parser/ViewBankAccount/viewbanckaccount_parser.dart';
import 'package:waiver_driver/backend/parser/WaitingForAuthorization/waitingforauthorization_parser.dart';
import 'package:waiver_driver/backend/parser/otp/otp_parser.dart';
import 'package:waiver_driver/backend/parser/splash/splash_parser.dart';

import '../../backend/parser/BankAccount/bankaccount_parser.dart';
import '../../backend/parser/Preference/preference_parser.dart';

class MainBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    // Get.put<NetworkController>(NetworkController(), permanent: true);

    Get.lazyPut(() => ApiServices(appBaseUrl: AppUrls.base));

    Get.lazyPut(() => SplashParser(apiService: Get.find()), fenix: true);

    Get.lazyPut(() => SignInParser(apiService: Get.find()), fenix: true);

    Get.lazyPut(() => LoginParser(apiService: Get.find()), fenix: true);
    Get.lazyPut(() => DriverTypeSelectionParser(apiService: Get.find()),
        fenix: true);
    Get.lazyPut(() => OtpParser(apiService: Get.find()), fenix: true);
    Get.lazyPut(() => FleetHomePageParser(apiService: Get.find()), fenix: true);
    Get.lazyPut(() => HomeParser(apiService: Get.find()), fenix: true);
    Get.lazyPut(() => ChauffeurProof_parser(apiService: Get.find()),
        fenix: true);
    Get.lazyPut(() => RegistrationParser(apiService: Get.find()), fenix: true);
    Get.lazyPut(() => WaitingForAuthorizationParser(apiService: Get.find()),
        fenix: true);

    Get.lazyPut(() => AadharParser(apiService: Get.find()), fenix: true);
    Get.lazyPut(() => BankaccountParser(apiService: Get.find()), fenix: true);
    Get.lazyPut(() => ProfilescreenParser(apiService: Get.find()), fenix: true);
    Get.lazyPut(() => EarningscreenParser(apiService: Get.find()), fenix: true);
    Get.lazyPut(() => ViewbankaccountParser(apiService: Get.find()),
        fenix: true);
    Get.lazyPut(() => RatingscreenParser(apiService: Get.find()), fenix: true);
    Get.lazyPut(() => MyrideScreenParser(apiService: Get.find()), fenix: true);
    Get.lazyPut(() => NotificationParser(apiService: Get.find()), fenix: true);
    Get.lazyPut(() => SettingsParser(apiService: Get.find()), fenix: true);
    Get.lazyPut(() => PreferencesParser(apiService: Get.find()), fenix: true);

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
