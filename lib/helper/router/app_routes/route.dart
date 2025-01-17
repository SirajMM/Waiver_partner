import 'package:get/get.dart';
import 'package:waiver_driver/backend/binding/DriverTypeSelection/DriverTypeSelection_binding.dart';
import 'package:waiver_driver/backend/binding/Login/login_binding.dart';
import 'package:waiver_driver/backend/binding/signIn/signin_binding.dart';
import 'package:waiver_driver/backend/binding/splash/splash_binding.dart';
import 'package:waiver_driver/controller/driver_type_selection/driver_type_selection_controller.dart';
import 'package:waiver_driver/controller/registration_certificate/registration_certificate_controller.dart';
import 'package:waiver_driver/controller/splash/splash_controller.dart';
import 'package:waiver_driver/view/driver_type_selection/driver_type_selection_view.dart';
import 'package:waiver_driver/view/login/login_view.dart';
import 'package:waiver_driver/view/registration_certificate/registration_certificate_view.dart';
import 'package:waiver_driver/view/sign_in/sign_in_view.dart';
import 'package:waiver_driver/view/splash/splash_view.dart';

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

  static String getInitialRoute() => splash;
   static String getLoginRoute() => login;
    static String getSignInRoute() => signIn;
    static String getDriverTypeSelectionRoute() => driverTypeSelection;

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
      name: AppRoutes1.signIn,
      page: () => const SignInScreen(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: AppRoutes1.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.otp,
    //   page: () => const OtpScreen(),
    //   binding: OtpControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.welcome,
    //   page: () => const DriverTypeSelectionScreen(),
    //   binding: DriverProfileControllerBinding(),
    // ),
    // // OMS: 2024-06-08 registration page as common
    // GetPage(
    //   name: AppRoutes.registration,
    //   page: () => const RegistrationScreen(),
    //   binding: RegistrationControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.fleetRegistration,
    //   page: () => const FleetRegistrationScreen(),
    //   binding: FleetRegistrationControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.chauffeurProof,
    //   page: () => const ChauffeurProofScreen(),
    //   binding: ChauffeurProofControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.profilePhoto,
    //   page: () => const ProfilePhotoScreen(),
    //   binding: ProfilePhotoControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.aadharCard,
    //   page: () => const AadharCardScreen(),
    //   binding: AadharCardControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.bankAccount,
    //   page: () => const BankAccountScreen(),
    //   binding: BankAccountControllerBinding(),
    // ),
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
    // GetPage(
    //   name: AppRoutes.waitingForAuthorization,
    //   page: () => const WaitingForAuthorizationScreen(),
    //   binding: WaitingForAuthorizationControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.viewBankAccount,
    //   page: () => const ViewBankAccountScreen(),
    //   binding: ViewBankAccountControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.locationNotEnabled,
    //   page: () => const LocationNotEnabledScreen(),
    //   binding: LocationNotEnabledControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.home,
    //   page: () => const HomeScreen(),
    //   binding: HomeControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.reasonForCancel,
    //   page: () => const ReasonForCancelScreen(),
    //   binding: ReasonForCancelControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.profile,
    //   page: () => const ProfileScreen(),
    //   binding: ProfileControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.earning,
    //   page: () => const EarningScreen(),
    //   binding: EarningControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.rating,
    //   page: () => const RatingScreen(),
    //   binding: RatingControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.myRides,
    //   page: () => const MyRidesScreen(),
    //   binding: MyRidesControllerBinding(),
    // ),
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
    // GetPage(
    //   name: AppRoutes.notification,
    //   page: () => const NotificationScreen(),
    //   binding: NotificationControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.help,
    //   page: () => const HelpScreen(),
    //   binding: HelpControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.setting,
    //   page: () => const SettingScreen(),
    //   binding: SettingControllerBinding(),
    // ),
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
    // GetPage(
    //   name: AppRoutes.preferences,
    //   page: () => const PreferencesScreen(),
    //   binding: PreferencesControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.accountRelated,
    //   page: () => const AccountRelatedScreen(),
    //   binding: AccountRelatedControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.fleetHomePage,
    //   page: () => const FleetHomePageScreen(),
    //   binding: FleetHomePageControllerBinding(),
    // ),
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
