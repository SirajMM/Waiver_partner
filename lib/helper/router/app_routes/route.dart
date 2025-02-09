import 'package:get/get.dart';
import 'package:waiver_driver/backend/binding/Aadhar/aadhar_binding.dart';
import 'package:waiver_driver/backend/binding/BankAccount/bankaccount_binding.dart';
import 'package:waiver_driver/backend/binding/ChauffeurProof/chauffeurproof_binding.dart';
import 'package:waiver_driver/backend/binding/DriverTypeSelection/DriverTypeSelection_binding.dart';
import 'package:waiver_driver/backend/binding/Earning/earningscreen_binding.dart';
import 'package:waiver_driver/backend/binding/FleetHomePage/FleetHomePage_binding.dart';
import 'package:waiver_driver/backend/binding/Home/home_binding.dart';
import 'package:waiver_driver/backend/binding/Login/login_binding.dart';
import 'package:waiver_driver/backend/binding/Notification/notification_binding.dart';
import 'package:waiver_driver/backend/binding/Otp/otp_binding.dart';
import 'package:waiver_driver/backend/binding/Profile/profilescreen_binding.dart';
import 'package:waiver_driver/backend/binding/Rating/ratingscreen_binding.dart';
import 'package:waiver_driver/backend/binding/ReasonForCancel/reason_for_cancel_binding.dart';
import 'package:waiver_driver/backend/binding/Registraion/registration_binding.dart';
import 'package:waiver_driver/backend/binding/WaitingForAuthorization/waitingforauthorization_binding.dart';
import 'package:waiver_driver/backend/binding/signIn/signin_binding.dart';
import 'package:waiver_driver/backend/binding/splash/splash_binding.dart';
import 'package:waiver_driver/controller/driver_type_selection/driver_type_selection_controller.dart';
import 'package:waiver_driver/controller/reason_for_cancel/reason_for_cancel_controller.dart';
import 'package:waiver_driver/controller/registration_certificate/registration_certificate_controller.dart';
import 'package:waiver_driver/controller/splash/splash_controller.dart';
import 'package:waiver_driver/view/chauffeur_proof/chauffeur_proof_view.dart';
import 'package:waiver_driver/view/driver_type_selection/driver_type_selection_view.dart';
import 'package:waiver_driver/view/fleet_home_page/fleet_home_page_view.dart';
import 'package:waiver_driver/view/home/home_view.dart';
import 'package:waiver_driver/view/login/login_view.dart';
import 'package:waiver_driver/view/my_rides/my_rides_view.dart';
import 'package:waiver_driver/view/notification/notification_view.dart';
import 'package:waiver_driver/view/otp/otp_view.dart';
import 'package:waiver_driver/view/registration/registration_view.dart';
import 'package:waiver_driver/view/registration_certificate/registration_certificate_view.dart';
import 'package:waiver_driver/view/sign_in/sign_in_view.dart';
import 'package:waiver_driver/view/splash/splash_view.dart';

import '../../../backend/binding/MyRide/myridescreen_binding.dart';
import '../../../backend/binding/Preferences/preferences_binding.dart';
import '../../../backend/binding/Settings/settings_binding.dart';
import '../../../backend/binding/ViewBankAccount/viewbankaccount_binding.dart';
import '../../../view/Location/location_screen.dart';
import '../../../view/aadhar_card/aadhar_card_view.dart';
import '../../../view/bank_account/bank_account_view.dart';
import '../../../view/earning/earning_view.dart';
import '../../../view/preferences/preferences_view.dart';
import '../../../view/profile/profile_view.dart';
import '../../../view/rating/rating_view.dart';
import '../../../view/reason_for_cancel/reason_for_cancel_view.dart';
import '../../../view/setting/setting_view.dart';
import '../../../view/view_bank_account/view_bank_bank_view.dart';
import '../../../view/waiting_for_authorization/waiting_for_authorization_view.dart';

class AppRoutes1 {
  static String splash = "/splash";
  static String driverTypeSelection = "/driverTypeSelection";
  static String login = "/login";
  static String signIn = "/signIn";
  static String otp = "/otp";
  static String welcome = "/welcome";
  static String registration = "/registration";
  static String fleetRegistration = "/fleetRegistration";
  static String chauffeurProof = "/chauffeurProof";
  static String profilePhoto = "/profilePhoto";
  static String aadharCard = "/aadharCard";
  static String bankAccount = "/bankAccount";
  static String policeClearanceCertificate = "/policeClearanceCertificate";
  static String drivingLicence = "/drivingLicence";
  static String waitingForAuthorization = "/waitingForAuthorization";
  static String locationNotEnabled = "/locationNotEnabled";
  static String home = "/home";
  static String viewBankAccount = "/viewBankAccount";
  static String reasonForCancel = "/reasonForCancel";
  static String profile = "/profile";
  static String earning = "/earning";
  static String tripDetails = "/tripDetails";
  static String rating = "/rating";
  static String myRides = "/myRides";
  static String receipt = "/receipt";
  static String referAndEarn = "/referAndEarn";
  static String notification = "/notification";
  static String help = "/help";
  static String setting = "/setting";
  static String faq = "/faq";
  static String faqDetails = "/faqDetails";
  static String faqListing = "/faqListing";
  static String preferences = "/preferences";
  static String accountRelated = "/accountRelated";
  static String successFullRegister = "/successFullRegister";
  static String fleetHomePage = "/fleetHomePage";
  static String addVehicle = "/addVehicle";
  static String addDriver = "/addDriver";
  static String vehicleProof = "/vehicleProof";
  static String vehicleDetails = "/vehicleDetails";
  static String addProofVehicle = "/addProofVehicle";
  static String driverProfile = "/driverProfile";
  static String registrationCertificate = "/registrationCertificate";
  static String vehicleInsurance = "/vehicleInsurance";
  static String vehiclePermit = "/vehiclePermit";
  static String getLocation = "/getLocation";

  static String getInitialRoute() => splash;
  static String getLoginRoute() => login;
  static String getSignInRoute() => signIn;
  static String getDriverTypeSelectionRoute() => driverTypeSelection;
  static String getOtpInRoute() => otp;
  static String getFleetHomePageInRoute() => fleetHomePage;
  static String getHomeInRoute() => home;
  static String getChauffeurProofInRoute() => chauffeurProof;
  static String getRegistraionInRoute() => registration;
  static String getWaitingForAuthorizationInRoute() => waitingForAuthorization;
  static String getAadharCardInRoute() => aadharCard;
  static String getBankAccountInRoute() => bankAccount;
  static String getProfileScreenInRoute() => profile;
  static String getEraningScreenInRoute() => earning;
  static String getViewBankAccountScreenInRoute() => viewBankAccount;
  static String getRatingScreenInRoute() => rating;
  static String getMyRideScreenInRoute() => myRides;
  static String getNotificationInRoute() => notification;
  static String getSettingsScreeenInRoute() => setting;
  static String getPreferencesInRoute() => preferences;
  static String getreasonForCancelInRoute() => reasonForCancel;
  static String getgetLocationInRoute() => getLocation;

  static List<GetPage> appPages1 = <GetPage>[
    GetPage(
      name: AppRoutes1.splash,
      page: () => const SplashScreen(),
      bindings: [
        SplashBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes1.driverTypeSelection,
      page: () => const DriverTypeSelectionScreen(),
      binding: DriverTypeSelectionBinding(),
    ),
    // // OMS: 2024-06-08 login section choosing page
    GetPage(
      name: AppRoutes1.getLocation,
      page: () => const LocationScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes1.signIn,
      page: () => const SignInScreen(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: AppRoutes1.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes1.otp,
      page: () => const OtpScreen(),
      binding: OtpBinging(),
    ),
    // GetPage(
    //   name: AppRoutes.welcome,
    //   page: () => const DriverTypeSelectionScreen(),
    //   binding: DriverProfileControllerBinding(),
    // ),
    // // OMS: 2024-06-08 registration page as common
    GetPage(
      name: AppRoutes1.registration,
      page: () => const RegistrationScreen(),
      binding: RegistrationBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.fleetRegistration,
    //   page: () => const FleetRegistrationScreen(),
    //   binding: FleetRegistrationControllerBinding(),
    // ),
    GetPage(
      name: AppRoutes1.chauffeurProof,
      page: () => const ChauffeurProofScreen(),
      binding: ChauffeurProof_Binding(),
    ),
    // GetPage(
    //   name: AppRoutes.profilePhoto,
    //   page: () => const ProfilePhotoScreen(),
    //   binding: ProfilePhotoControllerBinding(),
    // ),
    GetPage(
      name: AppRoutes1.aadharCard,
      page: () => const AadharCardScreen(),
      binding: AadharBinding(),
    ),
    GetPage(
      name: AppRoutes1.bankAccount,
      page: () => const BankAccountScreen(),
      binding: BankaccountBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.successFullRegister,
    //   page: () => const SuccessFullRegister(),
    // ),
    // GetPage(
    //   name: AppRoutes.policeClearanceCertificate,
    //   page: () => const PoliceClearanceCertificateScreen(),
    //   binding: PoliceClearanceCertificateControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.drivingLicence,
    //   page: () => const DrivingLicenceScreen(),
    //   binding: DrivingLicenceControllerBinding(),
    // ),
    GetPage(
      name: AppRoutes1.waitingForAuthorization,
      page: () => const WaitingForAuthorizationScreen(),
      binding: WaitingForAuthorizationBinding(),
    ),
    GetPage(
      name: AppRoutes1.viewBankAccount,
      page: () => const ViewBankAccountScreen(),
      binding: ViewBankAccountScreenBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.locationNotEnabled,
    //   page: () => const LocationNotEnabledScreen(),
    //   binding: LocationNotEnabledControllerBinding(),
    // ),
    GetPage(
      name: AppRoutes1.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes1.reasonForCancel,
      page: () => const ReasonForCancelScreen(),
      binding: ReasonForCancelBinding(),
    ),
    GetPage(
      name: AppRoutes1.profile,
      page: () => const ProfileScreen(),
      binding: ProfilescreenBinding(),
    ),
    GetPage(
      name: AppRoutes1.earning,
      page: () => const EarningScreen(),
      binding: EarningscreenBinding(),
    ),
    GetPage(
      name: AppRoutes1.rating,
      page: () => const RatingScreen(),
      binding: RatingscreenBinding(),
    ),
    GetPage(
      name: AppRoutes1.myRides,
      page: () => const MyRidesScreen(),
      binding: MyrideScreenBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.receipt,
    //   page: () => const ReceiptScreen(),
    //   binding: ReceiptControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.referAndEarn,
    //   page: () => const ReferAndEarnScreen(),
    //   binding: ReferAndEarnControllerBinding(),
    // ),
    GetPage(
      name: AppRoutes1.notification,
      page: () => const NotificationScreen(),
      binding: NotificationBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.help,
    //   page: () => const HelpScreen(),
    //   binding: HelpControllerBinding(),
    // ),
    GetPage(
      name: AppRoutes1.setting,
      page: () => const SettingScreen(),
      binding: SettingScreenBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.faq,
    //   page: () => const FaqTopicsScreen(),
    //   binding: FaqTopicControllerBinding(), //Done over here 14/01/2025
    // ),
    // GetPage(
    //   name: AppRoutes.faqDetails,
    //   page: () => const FaqDetailsScreen(), // Start from here
    //   binding: FaqDetailsControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.faqListing,
    //   page: () => const FaqListingScreen(),
    //   binding: FaqListingControllerBinding(),
    // ),
    GetPage(
      name: AppRoutes1.preferences,
      page: () => const PreferencesScreen(),
      binding: PreferencesBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.accountRelated,
    //   page: () => const AccountRelatedScreen(),
    //   binding: AccountRelatedControllerBinding(),
    // ),
    GetPage(
      name: AppRoutes1.fleetHomePage,
      page: () => const FleetHomePageScreen(),
      binding: FleetHomePageBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.addVehicle,
    //   page: () => const AddVehicleScreen(),
    //   binding: AddVehicleControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.addDriver,
    //   page: () => const AddDriverScreen(),
    //   binding: AddDriverControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.vehicleProof,
    //   page: () => const VehicleProofScreen(),
    //   binding: VehicleProofControllerBinding(),
    // ),
    // // OMS: 2024-06-09 18:53:02 working here
    // GetPage(
    //   name: AppRoutes.addProofVehicle,
    //   page: () => const AddVehicleProofScreen(),
    //   binding: AddVehicleProofControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.driverProfile,
    //   page: () => const DriverProfileScreen(),
    //   binding: DriverProfileControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.vehicleInsurance,
    //   page: () => const VehicleInsuranceScreen(),
    //   binding: VehicleInsuranceControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.vehiclePermit,
    //   page: () => const VehiclePermitScreen(),
    //   binding: VehiclePermitControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.registrationCertificate,
    //   page: () => const RegistrationCertificateScreen(),
    //   binding: RegistrationCertificateControllerBinding(),
    // ),
  ];
}
