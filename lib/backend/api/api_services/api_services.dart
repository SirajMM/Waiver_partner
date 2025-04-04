import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as https;

import 'package:waiver_driver/backend/api/api_services/urls.dart';
import 'package:waiver_driver/backend/model/add_vehicle/add_vehicle_model.dart';
import 'package:waiver_driver/backend/model/bank_account/bank_account_model.dart';
import 'package:waiver_driver/backend/model/driver_profile/driver_profile_model.dart';
import 'package:waiver_driver/backend/model/faq_topics/faq_topic_model.dart';
import 'package:waiver_driver/backend/model/fleet_home_page/fleet_home_page_model.dart';
import 'package:waiver_driver/backend/model/help/help_model.dart';
import 'package:waiver_driver/backend/model/home/home_model.dart';
import 'package:waiver_driver/backend/model/my_rides/my_rides_model.dart';
import 'package:waiver_driver/backend/model/notification/notification_model.dart';
import 'package:waiver_driver/backend/model/preferences/preferences_model.dart';
import 'package:waiver_driver/backend/model/profile/profile_model.dart';
import 'package:waiver_driver/backend/model/rating/rating_model.dart';
import 'package:waiver_driver/backend/model/reason_for_cancel/reason_for_cancel_model.dart';
import 'package:waiver_driver/backend/model/setting/setting_model.dart';
import 'package:waiver_driver/backend/model/trip_details/trip_details_model.dart';
import 'package:waiver_driver/backend/model/view_bank_account/view_bank_model.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';
import 'package:waiver_driver/main.dart';

import '../../../core/colors/app_colors.dart';
import '../../model/aadhar_card/aadhar_card_model.dart';
import '../../model/add_driver_fleet/add_driver_model.dart';
import '../../model/chauffeur_proof/chauffeur_proof_model.dart';
import '../../model/earning/earning_model.dart';
import '../../model/login/login_model.dart';
import '../../model/otp/otp_model.dart';
import '../../model/profile_photo/profile_photo_model.dart';
import '../../model/registration/registration_model.dart';

class ApiServices {
  final String appBaseUrl;
  ApiServices({required this.appBaseUrl});

  static String getToken() {
    print("Bearer ${box.read(BoxKeys.token)}");
    return "Bearer ${box.read(BoxKeys.token)}";
  }

  static Future<SendPhoneOtpResponseModel> sendPhoneOtp({
    required Map<String, String> body,
  }) async {
    https.Response response = await https.post(
      Uri.https(AppUrls.base, AppUrls.sendPhoneOtp),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );
    log("${Uri.https(AppUrls.base, AppUrls.sendPhoneOtp)}===============>$body");
    log("${Uri.https(AppUrls.base, AppUrls.sendPhoneOtp)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.sendPhoneOtp)}===============>${response.body}");
    if (response.statusCode == 200) {
      return sendPhoneOtpResponseModelFromJson(response.body);
    } else {
      log(Exception(response.body).toString());
      throw Exception(sendPhoneOtpResponseModelFromJson(response.body)
          .error!
          .nonFieldErrors![0]);
    }
  }

  static Future<VerifyOtpResponseModel> phoneAuth({
    required Map<String, String> body,
  }) async {
    https.Response response = await https.post(
      Uri.https(AppUrls.base, AppUrls.phoneAuth),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );
    log("${Uri.https(AppUrls.base, AppUrls.phoneAuth)}===============>$body");
    log("${Uri.https(AppUrls.base, AppUrls.phoneAuth)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.phoneAuth)}===============>${response.body}");
    if (response.statusCode == 200) {
      return verifyOtpResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<CreateDriverProfileResponseModel> createProfile({
    required Map<String, dynamic> body,
  }) async {
    https.Response response = await https.post(
      Uri.https(AppUrls.base, AppUrls.createProfile),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": getToken()
      },
      body: json.encode(body),
    );
    log(BoxKeys.token);
    log("${Uri.https(AppUrls.base, AppUrls.createProfile)}===============>$body");
    log("${Uri.https(AppUrls.base, AppUrls.createProfile)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.createProfile)}===============>${response.body}");
    if (response.statusCode == 200) {
      return createDriverProfileResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetAllStatesResponseModel> getAllStates() async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.states),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.states)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.states)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getAllStatesResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetAllDistrictsResponseModel> getAllDistricts({
    required Map<String, String> queryParameter,
  }) async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.districts, queryParameter),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.districts)}===============>$queryParameter");
    log("${Uri.https(AppUrls.base, AppUrls.districts)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.districts)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getAllDistrictsResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetAllWorkLocationsResponseModel> getWorkLocation() async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.workLocations),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.workLocations)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.workLocations)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getAllWorkLocationsResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetAllWorkExperienceResponseModel> getWorkExperience() async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.workExperience),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.workExperience)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.workExperience)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getAllWorkExperienceResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetVehicleTypeResponseModel> getVehicleTypes() async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.vehicleTypes),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.vehicleTypes)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.vehicleTypes)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getVehicleTypeResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetTransmissionTypeResponseModel> getTransmissionTypes() async {
    log(getToken());
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.transmissionTypes),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.transmissionTypes)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.transmissionTypes)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getTransmissionTypeResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetDocumentsResponseModel> getDocument({
    Map<String, String>? queryParameter,
  }) async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.document, queryParameter ?? {}),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.document)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.document)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getDocumentsResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<UploadDocumentResponseModel> uploadDocument({
    required body,
  }) async {
    https.Response response = await https.put(
      Uri.https(AppUrls.base, AppUrls.document),
      body: json.encode(body),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.document)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.document)}===============>${response.body}");
    log("${Uri.https(AppUrls.base, AppUrls.document)}===============>${json.encode(body)}");
    if (response.statusCode == 200) {
      return uploadDocumentResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<UploadDocumentResponseModel> addVehicleProof({
    required body,
  }) async {
    https.Response response = await https.put(
      Uri.https(AppUrls.base, AppUrls.vehicleProof),
      body: json.encode(body),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.vehicleProof)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.vehicleProof)}===============>${response.body}");
    log("${Uri.https(AppUrls.base, AppUrls.vehicleProof)}===============>${json.encode(body)}");
    if (response.statusCode == 200) {
      return uploadDocumentResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<AddDriverResponseModel> vehicleDriver({
    required body,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      "Authorization": getToken()
    };
    https.Response response = await https.post(
      Uri.https(AppUrls.base, AppUrls.vehicleDriver),
      body: json.encode(body),
      headers: headers,
    );
    log(headers.toString());
    log("${Uri.https(AppUrls.base, AppUrls.vehicleDriver)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.vehicleDriver)}===============>${response.body}");
    log("${Uri.https(AppUrls.base, AppUrls.vehicleDriver)}===============>${json.encode(body)}");
    if (response.statusCode == 200) {
      return AddDriverResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  static Future<AddDriverResponseModel> changeDriver({
    required body,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      "Authorization": getToken()
    };
    https.Response response = await https.put(
      Uri.https(AppUrls.base, AppUrls.vehicleDriver),
      body: json.encode(body),
      headers: headers,
    );
    log(headers.toString());
    log("${Uri.https(AppUrls.base, AppUrls.vehicleDriver)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.vehicleDriver)}===============>${response.body}");
    log("${Uri.https(AppUrls.base, AppUrls.vehicleDriver)}===============>${json.encode(body)}");
    if (response.statusCode == 200) {
      return AddDriverResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  static Future<UploadDocumentResponseModel> viewVehicleProof(
      {required Map<String, String> body}) async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.vehicleProof, body),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": getToken()
      },
    );

    log("${Uri.https(AppUrls.base, AppUrls.vehicleProof, body)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.vehicleProof, body)}===============>${response.body}");
    if (response.statusCode == 200) {
      return uploadDocumentResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<UploadFileResponseModel> uploadFile({
    required https.MultipartFile files,
    required Map<String, String> fields,
  }) async {
    var request = https.MultipartRequest(
      "POST",
      Uri.https(AppUrls.base, AppUrls.uploadFile),
    );
    request.files.add(files);
    request.fields.addAll((fields));
    request.headers.addAll({"Authorization": getToken()});
    https.StreamedResponse response = await request.send();
    log("${Uri.https(AppUrls.base, AppUrls.uploadFile)}===============>$fields");
    log("${Uri.https(AppUrls.base, AppUrls.uploadFile)}===============>$files");
    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      log("${Uri.https(AppUrls.base, AppUrls.uploadFile)}===============>${response.statusCode}");
      log("${Uri.https(AppUrls.base, AppUrls.uploadFile)}===============>$responseString");

      return uploadFileResponseModelFromJson(responseString);
    } else {
      showErrorMessageBox(" file is not uploaded yet. Facing some errors");
      throw Exception(await response.stream.bytesToString());
    }
  }

  static void showErrorMessageBox(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.red176,
      colorText: AppColors.white,
    );
  }

  static Future<UploadProfilePhotoResponseModel> profileImage(
    https.MultipartFile file,
  ) async {
    var request = https.MultipartRequest(
      "PUT",
      Uri.https(AppUrls.base, AppUrls.profileImage),
    );
    request.files.add(file);
    request.headers.addAll({"Authorization": getToken()});
    https.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      log("${Uri.https(AppUrls.base, AppUrls.profileImage)}===============>${response.statusCode}");
      log("${Uri.https(AppUrls.base, AppUrls.profileImage)}===============>$responseString");
      return uploadProfilePhotoResponseModelFromJson(responseString);
    } else {
      throw Exception(await response.stream.bytesToString());
    }
  }

  static Future<GetProfilePhotoResponseModel> getProfileImage() async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.profileImage),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.profileImage)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.profileImage)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getProfilePhotoResponseModelFromJson(response.body);
    }
    if (response.statusCode == 400) {
      return getProfilePhotoResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetBankAccountResponseModel> getBankAccount() async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.bankAccount),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.bankAccount)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.bankAccount)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getBankAccountResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<UpdateBanksResponseModel> updateBankAccount(
      {required Map<String, String> body}) async {
    https.Response response = await https.put(
        Uri.https(AppUrls.base, AppUrls.bankAccount),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          "Authorization": getToken()
        },
        body: body);
    log("${Uri.https(AppUrls.base, AppUrls.bankAccount)}===============>$body");
    log("${Uri.https(AppUrls.base, AppUrls.bankAccount)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.bankAccount)}===============>${response.body}");
    if (response.statusCode == 200) {
      return updateBanksResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetBanksResponseModel> getBanks() async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.banks),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.banks)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.banks)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getBanksResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetProfileResponseModel> getProfile() async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.profile),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.profile)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.profile)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getProfileResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<UpdateProfileResponseModel> upDateProfile(
      {required Map<String, String> body}) async {
    https.Response response = await https.put(
      Uri.https(AppUrls.base, AppUrls.profile),
      body: body,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.profile)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.profile)}===============>${response.body}");
    if (response.statusCode == 200) {
      return updateProfileResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<AddBankAccountResponseModel> addBankAccount(
      {required Map<String, String> body}) async {
    var response = await https.post(
      Uri.https(AppUrls.base, AppUrls.bankAccount),
      headers: {"Authorization": getToken()},
      body: body,
    );
    log("${Uri.https(AppUrls.base, AppUrls.bankAccount)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.bankAccount)}===============>${response.body}");
    log("${Uri.https(AppUrls.base, AppUrls.bankAccount)}===============>$body");

    if (response.statusCode == 200) {
      return addBankAccountResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetEarningStatusResponseModel> getEarningStatus(
      {required Map<String, String> queryParameter}) async {
    var response = await https.get(
      Uri.https(AppUrls.base, AppUrls.earningStatus, queryParameter),
      headers: {"Authorization": getToken()},
    );
    log("${Uri.https(AppUrls.base, AppUrls.earningStatus)}===============>$queryParameter");
    log("${Uri.https(AppUrls.base, AppUrls.earningStatus)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.earningStatus)}===============>${response.body}");

    if (response.statusCode == 200) {
      return getEarningStatusResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetReviewStatusResponseModel> getReviewsStatus() async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.reviewsStatus),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.reviewsStatus)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.reviewsStatus)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getReviewStatusResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetReviewResponseModel> getReviews() async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.reviews),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.reviews)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.reviews)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getReviewResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetReviewResponseModel> verifyRideOtp(
      {required Map<String, dynamic> body}) async {
    https.Response response = await https.post(
        Uri.https(AppUrls.base, AppUrls.verifyRideOtp),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": getToken()
        },
        body: json.encode(body));
    log("${Uri.https(AppUrls.base, AppUrls.verifyRideOtp)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.verifyRideOtp)}===============>${response.body}");
    log("${Uri.https(AppUrls.base, AppUrls.verifyRideOtp)}===============>${json.encode(body)}");
    if (response.statusCode == 200) {
      return getReviewResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetRidesResponseModel> getRides() async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.rides),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.rides)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.rides)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getRidesResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetRidesDetailsResponseModel> getRideDetails(
      {required Map<String, dynamic> queryParameter}) async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.rideOrderDetails, queryParameter),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.rideDetails)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.rideDetails)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getRidesDetailsResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetNotificationsResponseModel> getNotifications() async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.notifications),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.notifications)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.notifications)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getNotificationsResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetHelpCategoriesResponseModel> getHelpCategories() async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.helpCategories),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.helpCategories)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.helpCategories)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getHelpCategoriesResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<FaqResponseModel> getFaqs(
      {required Map<String, String> queryParameter}) async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.faqs, queryParameter),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.faqs)}===============>$queryParameter");
    log("${Uri.https(AppUrls.base, AppUrls.faqs)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.faqs)}===============>${response.body}");
    if (response.statusCode == 200) {
      return faqResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetEarningListResponseModel> getEarnings(
      {required Map<String, String> queryParameter}) async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.earnings, queryParameter),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.earnings)}===============>$queryParameter");
    log("${Uri.https(AppUrls.base, AppUrls.earnings)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.earnings)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getEarningListResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<UpdatePreferenceResponseModel> savePreference(
      {required Map<String, String> body}) async {
    https.Response response = await https.put(
      Uri.https(
        AppUrls.base,
        AppUrls.savePreference,
      ),
      body: body,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.savePreference)}===============>$body");
    log("${Uri.https(AppUrls.base, AppUrls.savePreference)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.savePreference)}===============>${response.body}");
    if (response.statusCode == 200) {
      return updatePreferenceResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<UpdatePreferenceResponseModel> getPreference() async {
    https.Response response = await https.get(
      Uri.https(
        AppUrls.base,
        AppUrls.savePreference,
      ),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.savePreference)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.savePreference)}===============>${response.body}");
    if (response.statusCode == 200) {
      return updatePreferenceResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<LogoutResponseModel> logout(
      {required Map<String, String> body}) async {
    https.Response response = await https.post(
      Uri.https(
        AppUrls.base,
        AppUrls.logout,
      ),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.logout)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.logout)}===============>${response.body}");
    if (response.statusCode == 200) {
      return logoutResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<LogoutResponseModel> deleteAccount(
      {required Map<String, String> body}) async {
    https.Response response = await https.post(
      Uri.https(
        AppUrls.base,
        AppUrls.deleteAccount,
      ),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.deleteAccount)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.deleteAccount)}===============>${response.body}");
    if (response.statusCode == 200) {
      return logoutResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<LogoutResponseModel> documentRejectionResponse(
      {required Map<String, String> body}) async {
    https.Response response = await https.post(
      Uri.https(
        AppUrls.base,
        AppUrls.documentRejectionResponse,
      ),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.documentRejectionResponse)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.documentRejectionResponse)}===============>${response.body}");
    if (response.statusCode == 200) {
      return logoutResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetVehicleListResponseModel> getVehicles() async {
    https.Response response = await https.get(
      Uri.https(
        AppUrls.base,
        AppUrls.vehicles,
      ),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.vehicles)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.vehicles)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getVehicleListResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<String> getVehicle({required Map<String, String> body}) async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.vehicle, body),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.vehicle, body)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.vehicle, body)}===============>${response.body}");
    if (response.statusCode == 200) {
      return "";
      // return getVehicleListResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<LogoutResponseModel> getVehicleDetail() async {
    https.Response response = await https.get(
      Uri.https(
        AppUrls.base,
        AppUrls.vehicles,
      ),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.vehicles)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.vehicles)}===============>${response.body}");
    if (response.statusCode == 200) {
      return logoutResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<AddVehicleResponseModel> addVehicle(
      {required Map<String, String> body}) async {
    https.Response response = await https.post(
      Uri.https(
        AppUrls.base,
        AppUrls.addVehicles,
      ),
      body: body,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.addVehicles)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.addVehicles)}===============>${response.body}");
    if (response.statusCode == 200) {
      return addVehicleResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<LogoutResponseModel> blockVehicle(
      {required Map<String, dynamic> body}) async {
    https.Response response = await https.put(
      Uri.https(
        AppUrls.base,
        AppUrls.blockVehicle,
      ),
      body: body,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.blockVehicle)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.blockVehicle)}===============>${response.body}");
    if (response.statusCode == 200) {
      return logoutResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<LogoutResponseModel> changeOnlineStatus(
      {required Map<String, dynamic> body}) async {
    https.Response response = await https.put(
      Uri.https(
        AppUrls.base,
        AppUrls.onlineStatus,
      ),
      body: json.encode(body),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": getToken()
      },
    );
    log(json.encode(body));
    log("${Uri.https(AppUrls.base, AppUrls.onlineStatus)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.onlineStatus)}===============>${response.body}");
    if (response.statusCode == 200) {
      return logoutResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetOnlineStatusResponseModel> getOnlineStatus() async {
    https.Response response = await https.get(
      Uri.https(
        AppUrls.base,
        AppUrls.onlineStatus,
      ),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": getToken()
      },
    );

    log("${Uri.https(AppUrls.base, AppUrls.onlineStatus)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.onlineStatus)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getOnlineStatusResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetRideDetailsResponseModel> rideOrderDetails(
      {required Map<String, dynamic> queryParameters}) async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.rideOrderDetails, queryParameters),
      headers: {"Authorization": getToken()},
    );
    log("${Uri.https(AppUrls.base, AppUrls.rideOrderDetails, queryParameters)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.rideOrderDetails, queryParameters)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getRideDetailsResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<ReasonForCancelModel> reasonForCancel() async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.rideCancelReasons),
      headers: {"Authorization": getToken()},
    );
    log("${Uri.https(AppUrls.base, AppUrls.rideCancelReasons)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.rideCancelReasons)}===============>${response.body}");
    if (response.statusCode == 200) {
      return ReasonForCancelModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  static Future<ChangeRideStatusModel> changeRideStatus(
      {required Map<String, dynamic> body}) async {
    https.Response response = await https.put(
      Uri.https(AppUrls.base, AppUrls.changeRideStatus),
      body: json.encode(body),
      headers: {
        "Authorization": getToken(),
        'Content-Type': 'application/json'
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.changeRideStatus)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.changeRideStatus)}===============>${response.body}");
    log("${Uri.https(AppUrls.base, AppUrls.changeRideStatus)}===============>$body");
    if (response.statusCode == 200) {
      return changeRideStatusFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetRideDetailsResponseModel> latestActiveRide() async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.latestActiveRide),
      headers: {
        "Authorization": getToken(),
        'Content-Type': 'application/json'
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.latestActiveRide)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.latestActiveRide)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getRideDetailsResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GetDriverProfileResponseModel> driverProfile({
    required Map<String, dynamic> queryParameter,
  }) async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.driverProfile, queryParameter),
      headers: {
        "Authorization": getToken(),
        'Content-Type': 'application/json'
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.driverProfile)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.driverProfile, queryParameter)}===============>${response.body}");
    if (response.statusCode == 200) {
      return getDriverProfileResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<ProfileImageModel> getProfilePhoto({
    required Map<String, dynamic> queryParameter,
  }) async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.profilePhoto, queryParameter),
      headers: {
        "Authorization": getToken(),
        'Content-Type': 'application/json'
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.profilePhoto)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.profilePhoto, queryParameter)}===============>${response.body}");
    if (response.statusCode == 200) {
      return profileImageModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<PaymentSuccessModel> getPaymentType({
    required Map<String, dynamic> queryParameter,
  }) async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.paymentType),
      headers: {
        "Authorization": getToken(),
        'Content-Type': 'application/json'
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.paymentType)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.paymentType)}===============>${response.body}");
    log("${Uri.https(AppUrls.base, AppUrls.paymentType)}===============>$queryParameter");
    if (response.statusCode == 200) {
      return paymentSuccessModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<RidePaymentResponseModel> getRidePayment(
      {required Map<String, dynamic> queryParameter}) async {
    https.Response response = await https.get(
      Uri.https(AppUrls.base, AppUrls.getRidePayment, queryParameter),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization": getToken()
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.getRidePayment, queryParameter)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.getRidePayment, queryParameter)}===============>${response.body}");
    if (response.statusCode == 200) {
      return ridePaymentResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<AddStopResponseModel> addStop(
      {required Map<String, dynamic> body}) async {
    https.Response response = await https.post(
      Uri.https(AppUrls.base, AppUrls.addStop),
      body: json.encode(body),
      headers: {
        "Authorization": getToken(),
        'Content-Type': 'application/json'
      },
    );
    log("${Uri.https(AppUrls.base, AppUrls.addStop)}===============>${response.statusCode}");
    log("${Uri.https(AppUrls.base, AppUrls.addStop)}===============>${response.body}");
    log("${Uri.https(AppUrls.base, AppUrls.addStop)}===============>$body");
    if (response.statusCode == 200) {
      return addStopResponseModelFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<GoogleLocationResponse> getCurrentLocation(
      double latitude, double longitude) async {
    https.Response response = await https.get(
      Uri.parse(
          "${AppUrls.googleLocationUrl}$latitude,$longitude${AppUrls.googleApiKeyUrl}"),
    );
    log("${Uri.parse("${AppUrls.googleLocationUrl}$latitude,$longitude${AppUrls.googleApiKeyUrl}")}===============>${response.body}");
    // log("${Uri.parse("${AppUrls.googleLocationUrl}$latitude,$longitude${AppUrls.googleApiKeyUrl}")}===============>${response.body}");
    if (response.statusCode == 200) {
      return googleLocationResponseFromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<WalletResponse> getPartnerWallet() async {
    try {
      https.Response response = await https.get(
        Uri.https(AppUrls.base, AppUrls.walletbalance),
        headers: {
          "Authorization": getToken(),
          'Content-Type': 'application/json'
        },
      );

      log("Partner wallet API ===============>${Uri.https(AppUrls.base, AppUrls.walletbalance)}");
      log("Partner wallet status code ===============>${response.statusCode}");
      log("Partner wallet response ===============>${response.body}");

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        return WalletResponse.fromJson(jsonData);
      } else {
        log("Partner wallet error: ${response.body}");
        throw Exception(response.body);
      }
    } catch (e) {
      log("Partner wallet exception: $e");
      rethrow;
    }
  }
}
