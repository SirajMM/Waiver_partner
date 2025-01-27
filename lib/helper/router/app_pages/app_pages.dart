import 'package:get/get.dart';
import 'package:waiver_driver/controller/account_related/account_related_controller.dart';
import 'package:waiver_driver/controller/add_driver_fleet/add_driver_controller.dart';
import 'package:waiver_driver/controller/add_vehicle/add_vehicle_controller.dart';
import 'package:waiver_driver/controller/add_vehicle_proof/add_vehicle_proof_controller.dart';
import 'package:waiver_driver/controller/driving_licence/driving_licence_controller.dart';
import 'package:waiver_driver/controller/earning/earning_controller.dart';
import 'package:waiver_driver/controller/faq_details/faq_details_controller.dart';
import 'package:waiver_driver/controller/faq_listing/faq_listing_controller.dart';
import 'package:waiver_driver/controller/faq_topics/faq_topic_controller.dart';
import 'package:waiver_driver/controller/fleet_home_page/fleet_home_page_controller.dart';
import 'package:waiver_driver/controller/help/help_controller.dart';
import 'package:waiver_driver/controller/home/home_controller.dart';
import 'package:waiver_driver/controller/location_not_enabled/location_not_enabled_controller.dart';
import 'package:waiver_driver/controller/my_rides/my_rides_controller.dart';
import 'package:waiver_driver/controller/notification/notification_controller.dart';
import 'package:waiver_driver/controller/police_clearance_certificate/police_clearance_certificate_controller.dart';
import 'package:waiver_driver/controller/preferences/preferences_controller.dart';
import 'package:waiver_driver/controller/profile/profile_controller.dart';
import 'package:waiver_driver/controller/rating/rating_controller.dart';
import 'package:waiver_driver/controller/reason_for_cancel/reason_for_cancel_controller.dart';
import 'package:waiver_driver/controller/receipt/receipt_controller.dart';
import 'package:waiver_driver/controller/refer_and_earn/refer_and_earn_controller.dart';
import 'package:waiver_driver/controller/registration_certificate/registration_certificate_controller.dart';
import 'package:waiver_driver/controller/setting/setting_controller.dart';
import 'package:waiver_driver/controller/vehicle_insurance/vehicle_insurance_controller.dart';
import 'package:waiver_driver/controller/vehicle_permit/vehicle_permit_controller.dart';
import 'package:waiver_driver/controller/vehicle_proof/vehicle_proof_controller.dart';
import 'package:waiver_driver/controller/view_bank_account/view_bank_account_controller.dart';
import 'package:waiver_driver/controller/waiting_for_authorization/waiting_for_authorization_controller.dart';
import 'package:waiver_driver/view/account_related/account_related_view.dart';
import 'package:waiver_driver/view/add_driver_fleet/add_driver_view.dart';
import 'package:waiver_driver/view/add_vehicle/add_vehicle_view.dart';
import 'package:waiver_driver/view/add_vehicle_proof/add_vehicle_proof_view.dart';
import 'package:waiver_driver/view/driver_profile/driver_profile_view.dart';
import 'package:waiver_driver/view/driving_licence/driving_licence_view.dart';
import 'package:waiver_driver/view/earning/earning_view.dart';
import 'package:waiver_driver/view/faq_details/faq_details_view.dart';
import 'package:waiver_driver/view/faq_listing/faq_listing_view.dart';
import 'package:waiver_driver/view/faq_topics/faq_topic_view.dart';
import 'package:waiver_driver/view/fleet_home_page/fleet_home_page_view.dart';
import 'package:waiver_driver/view/help/help_view.dart';
import 'package:waiver_driver/view/home/home_view.dart';
import 'package:waiver_driver/view/location_not_enabled/location_not_enabled_view.dart';
import 'package:waiver_driver/view/my_rides/my_rides_view.dart';
import 'package:waiver_driver/view/notification/notification_view.dart';
import 'package:waiver_driver/view/police_clearance_certificate/police_clearance_certificate_view.dart';
import 'package:waiver_driver/view/preferences/preferences_view.dart';
import 'package:waiver_driver/view/profile/profile_view.dart';
import 'package:waiver_driver/view/rating/rating_view.dart';
import 'package:waiver_driver/view/reason_for_cancel/reason_for_cancel_view.dart';
import 'package:waiver_driver/view/receipt/receipt_view.dart';
import 'package:waiver_driver/view/refer_and_earn/refer_and_earn_view.dart';
import 'package:waiver_driver/view/registration_certificate/registration_certificate_view.dart';
import 'package:waiver_driver/view/setting/setting_view.dart';
import 'package:waiver_driver/view/vehicle_insurance/vehicle_insurance_view.dart';
import 'package:waiver_driver/view/vehicle_permit/vehicle_permit_view.dart';
import 'package:waiver_driver/view/vehicle_proof/vehicle_proof_view.dart';
import 'package:waiver_driver/view/view_bank_account/view_bank_bank_view.dart';
import 'package:waiver_driver/view/waiting_for_authorization/waiting_for_authorization_view.dart';

import '../../../controller/aadhar_card/aadhar_card_controller.dart';
import '../../../controller/bank_account/bank_account_controller.dart';
import '../../../controller/chauffeur_proof/chauffeur_proof_controller.dart';
import '../../../controller/driver_profile/driver_profile_controller.dart';
import '../../../controller/driver_type_selection/driver_type_selection_controller.dart';
import '../../../controller/fleet_registration/fleet_registration_controller.dart';
import '../../../controller/login/login_controller.dart';
import '../../../controller/otp/otp_controller.dart';
import '../../../controller/profile_photo/profile_photo_controller.dart';
import '../../../controller/registration/registration_controller.dart';
import '../../../controller/sign_in/sign_in_controller.dart';
import '../../../controller/splash/splash_controller.dart';
import '../../../register_success.dart';
import '../../../view/aadhar_card/aadhar_card_view.dart';
import '../../../view/bank_account/bank_account_view.dart';
import '../../../view/chauffeur_proof/chauffeur_proof_view.dart';
import '../../../view/driver_type_selection/driver_type_selection_view.dart';
import '../../../view/fleet_registration/fleet_registration_view.dart';
import '../../../view/login/login_view.dart';
import '../../../view/otp/otp_view.dart';
import '../../../view/profile_photo/profile_photo_view.dart';
import '../../../view/registration/registration_view.dart';
import '../../../view/sign_in/sign_in_view.dart';
import '../../../view/splash/splash_view.dart';
import '../app_routes/app_routes.dart';

class AppPages {
  static List<GetPage> appPages = <GetPage>[
    // GetPage(
    //   name: AppRoutes.splash,
    //   page: () => const SplashScreen(),
    //   bindings: [
    //     SplashControllerBinding(),
    //   ],
    // ),
    // GetPage(
    //   name: AppRoutes.driverTypeSelection,
    //   page: () => const DriverTypeSelectionScreen(),
    //   binding: DriverTypeSelectionControllerBinding(),
    // ),
    // OMS: 2024-06-08 login section choosing page
    // GetPage(
    //   name: AppRoutes.signIn,
    //   page: () => const SignInScreen(),
    //   binding: SignInControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.login,
    //   page: () => const LoginScreen(),
    //   binding: LoginControllerBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.otp,
    //   page: () => const OtpScreen(),
    //   binding: OtpControllerBinding(),
    // ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => const DriverTypeSelectionScreen(),
      binding: DriverProfileControllerBinding(),
    ),
    // OMS: 2024-06-08 registration page as common
    // GetPage(
    //   name: AppRoutes.registration,
    //   page: () => const RegistrationScreen(),
    //   binding: RegistrationControllerBinding(),
    // ),
    GetPage(
      name: AppRoutes.fleetRegistration,
      page: () => const FleetRegistrationScreen(),
      binding: FleetRegistrationControllerBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.chauffeurProof,
    //   page: () => const ChauffeurProofScreen(),
    //   binding: ChauffeurProofControllerBinding(),
    // ),
    GetPage(
      name: AppRoutes.profilePhoto,
      page: () => const ProfilePhotoScreen(),
      binding: ProfilePhotoControllerBinding(),
    ),
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
    GetPage(
      name: AppRoutes.successFullRegister,
      page: () => const SuccessFullRegister(),
    ),
    GetPage(
      name: AppRoutes.policeClearanceCertificate,
      page: () => const PoliceClearanceCertificateScreen(),
      binding: PoliceClearanceCertificateControllerBinding(),
    ),
    GetPage(
      name: AppRoutes.drivingLicence,
      page: () => const DrivingLicenceScreen(),
      binding: DrivingLicenceControllerBinding(),
    ),
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
    GetPage(
      name: AppRoutes.locationNotEnabled,
      page: () => const LocationNotEnabledScreen(),
      binding: LocationNotEnabledControllerBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.home,
    //   page: () => const HomeScreen(),
    //   binding: HomeControllerBinding(),
    // ),
    GetPage(
      name: AppRoutes.reasonForCancel,
      page: () => const ReasonForCancelScreen(),
      binding: ReasonForCancelControllerBinding(),
    ),
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
    GetPage(
      name: AppRoutes.receipt,
      page: () => const ReceiptScreen(),
      binding: ReceiptControllerBinding(),
    ),
    GetPage(
      name: AppRoutes.referAndEarn,
      page: () => const ReferAndEarnScreen(),
      binding: ReferAndEarnControllerBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.notification,
    //   page: () => const NotificationScreen(),
    //   binding: NotificationControllerBinding(),
    // ),
    GetPage(
      name: AppRoutes.help,
      page: () => const HelpScreen(),
      binding: HelpControllerBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.setting,
    //   page: () => const SettingScreen(),
    //   binding: SettingControllerBinding(),
    // ),
    GetPage(
      name: AppRoutes.faq,
      page: () => const FaqTopicsScreen(),
      binding: FaqTopicControllerBinding(), //Done over here 14/01/2025
    ),
    GetPage(
      name: AppRoutes.faqDetails,
      page: () => const FaqDetailsScreen(), // Start from here
      binding: FaqDetailsControllerBinding(),
    ),
    GetPage(
      name: AppRoutes.faqListing,
      page: () => const FaqListingScreen(),
      binding: FaqListingControllerBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.preferences,
    //   page: () => const PreferencesScreen(),
    //   binding: PreferencesControllerBinding(),
    // ),
    GetPage(
      name: AppRoutes.accountRelated,
      page: () => const AccountRelatedScreen(),
      binding: AccountRelatedControllerBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.fleetHomePage,
    //   page: () => const FleetHomePageScreen(),
    //   binding: FleetHomePageControllerBinding(),
    // ),
    GetPage(
      name: AppRoutes.addVehicle,
      page: () => const AddVehicleScreen(),
      binding: AddVehicleControllerBinding(),
    ),
    GetPage(
      name: AppRoutes.addDriver,
      page: () => const AddDriverScreen(),
      binding: AddDriverControllerBinding(),
    ),
    GetPage(
      name: AppRoutes.vehicleProof,
      page: () => const VehicleProofScreen(),
      binding: VehicleProofControllerBinding(),
    ),
    // OMS: 2024-06-09 18:53:02 working here
    GetPage(
      name: AppRoutes.addProofVehicle,
      page: () => const AddVehicleProofScreen(),
      binding: AddVehicleProofControllerBinding(),
    ),
    GetPage(
      name: AppRoutes.driverProfile,
      page: () => const DriverProfileScreen(),
      binding: DriverProfileControllerBinding(),
    ),
    GetPage(
      name: AppRoutes.vehicleInsurance,
      page: () => const VehicleInsuranceScreen(),
      binding: VehicleInsuranceControllerBinding(),
    ),
    GetPage(
      name: AppRoutes.vehiclePermit,
      page: () => const VehiclePermitScreen(),
      binding: VehiclePermitControllerBinding(),
    ),
    GetPage(
      name: AppRoutes.registrationCertificate,
      page: () => const RegistrationCertificateScreen(),
      binding: RegistrationCertificateControllerBinding(),
    ),
  ];
}
