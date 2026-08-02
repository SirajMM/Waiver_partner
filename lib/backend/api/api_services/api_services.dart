import 'dart:convert';
import 'dart:io';

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
import '../../../helper/logger.dart';
import '../../model/aadhar_card/aadhar_card_model.dart';
import '../../model/add_driver_fleet/add_driver_model.dart';
import '../../model/chauffeur_proof/chauffeur_proof_model.dart';
import '../../model/earning/earning_model.dart';
import '../../model/login/login_model.dart';
import '../../model/otp/otp_model.dart';
import '../../model/payment';
import '../../model/profile_photo/profile_photo_model.dart';
import '../../model/registration/registration_model.dart';

class ApiServices {
  final String appBaseUrl;
  ApiServices({required this.appBaseUrl});

  static String getToken() {
    return "Bearer ${box.read(BoxKeys.token)}";
  }

  static Future<SendPhoneOtpResponseModel> sendPhoneOtp({
    required Map<String, String> body,
  }) async {
    https.Response response = await ApiClient.instance.post(
      Uri.https(AppUrls.base, AppUrls.sendPhoneOtp),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );
    if (response.statusCode == 200) {
      return sendPhoneOtpResponseModelFromJson(response.body);
    } else {
      throw HttpException(sendPhoneOtpResponseModelFromJson(response.body).error!.nonFieldErrors![0]);
    }
  }

  static Future<VerifyOtpResponseModel> phoneAuth({
    required Map<String, String> body,
  }) async {
    https.Response response = await ApiClient.instance.post(
      Uri.https(AppUrls.base, AppUrls.phoneAuth),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );
    if (response.statusCode == 200) {
      return verifyOtpResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<CreateDriverProfileResponseModel> createProfile({
    required Map<String, dynamic> body,
  }) async {
    https.Response response = await ApiClient.instance.post(
      Uri.https(AppUrls.base, AppUrls.createProfile),
      headers: {'Content-Type': 'application/json', "Authorization": getToken()},
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      return createDriverProfileResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<void> registerVoipToken({required String token}) async {
    await ApiClient.instance.post(
      Uri.https(AppUrls.base, AppUrls.registerVoipToken),
      headers: {'Content-Type': 'application/json', "Authorization": getToken()},
      body: json.encode({"voip_token": token, "device_type": "ios"}),
    );
  }

  static Future<GetAllStatesResponseModel> getAllStates() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.states),
      headers: {'Content-Type': 'application/json', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getAllStatesResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetAllDistrictsResponseModel> getAllDistricts({
    required Map<String, String> queryParameter,
  }) async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.districts, queryParameter),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getAllDistrictsResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetAllWorkLocationsResponseModel> getWorkLocation() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.workLocations),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getAllWorkLocationsResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetAllWorkExperienceResponseModel> getWorkExperience() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.workExperience),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getAllWorkExperienceResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetVehicleTypeResponseModel> getVehicleTypes() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.vehicleTypes),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getVehicleTypeResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetTransmissionTypeResponseModel> getTransmissionTypes() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.transmissionTypes),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getTransmissionTypeResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetDocumentsResponseModel> getDocument({
    Map<String, String>? queryParameter,
  }) async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.document, queryParameter ?? {}),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getDocumentsResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<UploadDocumentResponseModel> uploadDocument({
    required body,
  }) async {
    https.Response response = await ApiClient.instance.put(
      Uri.https(AppUrls.base, AppUrls.document),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return uploadDocumentResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<UploadDocumentResponseModel> addVehicleProof({
    required body,
  }) async {
    https.Response response = await ApiClient.instance.put(
      Uri.https(AppUrls.base, AppUrls.vehicleProof),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return uploadDocumentResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<AddDriverResponseModel> vehicleDriver({
    required body,
  }) async {
    var headers = {'Content-Type': 'application/json', "Authorization": getToken()};
    https.Response response = await ApiClient.instance.post(
      Uri.https(AppUrls.base, AppUrls.vehicleDriver),
      body: json.encode(body),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return AddDriverResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<AddDriverResponseModel> changeDriver({
    required body,
  }) async {
    var headers = {'Content-Type': 'application/json', "Authorization": getToken()};
    https.Response response = await ApiClient.instance.put(
      Uri.https(AppUrls.base, AppUrls.vehicleDriver),
      body: json.encode(body),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return AddDriverResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<UploadDocumentResponseModel> viewVehicleProof(
      {required Map<String, String> body}) async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.vehicleProof, body),
      headers: {'Content-Type': 'application/json', "Authorization": getToken()},
    );

    if (response.statusCode == 200) {
      return uploadDocumentResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
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
    https.StreamedResponse response = await ApiClient.instance.send(request);
    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();

      return uploadFileResponseModelFromJson(responseString);
    } else {
      showErrorMessageBox(" file is not uploaded yet. Facing some errors");
      throw HttpException(await response.stream.bytesToString());
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
    https.StreamedResponse response = await ApiClient.instance.send(request);
    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return uploadProfilePhotoResponseModelFromJson(responseString);
    } else {
      throw HttpException(await response.stream.bytesToString());
    }
  }

  static Future<GetProfilePhotoResponseModel> getProfileImage() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.profileImage),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getProfilePhotoResponseModelFromJson(response.body);
    }
    if (response.statusCode == 400) {
      return getProfilePhotoResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetBankAccountResponseModel> getBankAccount() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.bankAccount),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getBankAccountResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<UpdateBanksResponseModel> updateBankAccount({required Map<String, String> body}) async {
    https.Response response = await ApiClient.instance.put(Uri.https(AppUrls.base, AppUrls.bankAccount),
        headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
        body: body);
    if (response.statusCode == 200) {
      return updateBanksResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetBanksResponseModel> getBanks() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.banks),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getBanksResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetProfileResponseModel> getProfile() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.profile),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getProfileResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<UpdateProfileResponseModel> upDateProfile({required Map<String, String> body}) async {
    https.Response response = await ApiClient.instance.put(
      Uri.https(AppUrls.base, AppUrls.profile),
      body: body,
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return updateProfileResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<AddBankAccountResponseModel> addBankAccount({required Map<String, String> body}) async {
    var response = await ApiClient.instance.post(
      Uri.https(AppUrls.base, AppUrls.bankAccount),
      headers: {"Authorization": getToken()},
      body: body,
    );

    if (response.statusCode == 200) {
      return addBankAccountResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetEarningStatusResponseModel> getEarningStatus(
      {required Map<String, String> queryParameter}) async {
    var response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.earningStatus, queryParameter),
      headers: {"Authorization": getToken()},
    );

    if (response.statusCode == 200) {
      return getEarningStatusResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetReviewStatusResponseModel> getReviewsStatus() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.reviewsStatus),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getReviewStatusResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetReviewResponseModel> getReviews() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.reviews),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getReviewResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetReviewResponseModel> verifyRideOtp({required Map<String, dynamic> body}) async {
    https.Response response = await ApiClient.instance.post(Uri.https(AppUrls.base, AppUrls.verifyRideOtp),
        headers: {'Content-Type': 'application/json', "Authorization": getToken()},
        body: json.encode(body));
    if (response.statusCode == 200) {
      return getReviewResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetReviewResponseModel> getReviewsWithPagination({int? offset, int? limit}) async {
    Map<String, String> queryParams = {};
    if (offset != null) queryParams['offset'] = offset.toString();
    if (limit != null) queryParams['limit'] = limit.toString();

    Uri uri = Uri.https(AppUrls.base, AppUrls.reviews, queryParams);

    https.Response response = await ApiClient.instance.get(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getReviewResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetRidesResponseModel> getRides() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.rides),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getRidesResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetRidesResponseModel> getRidesFromUrl(String url) async {
    try {
      https.Response response = await ApiClient.instance.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
      );


      if (response.statusCode == 200) {
        return getRidesResponseModelFromJson(response.body);
      } else {
        throw HttpException(response.body);
      }
    } catch (e) {
      ApiLog.error('getRidesFromUrl failed', e);
      throw HttpException('Failed to load more rides: $e');
    }
  }

  static Future<GetRidesDetailsResponseModel> getRideDetails(
      {required Map<String, dynamic> queryParameter}) async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.rideOrderDetails, queryParameter),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getRidesDetailsResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetNotificationsResponseModel> getNotifications() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.notifications),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getNotificationsResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetHelpCategoriesResponseModel> getHelpCategories() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.helpCategories),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getHelpCategoriesResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<FaqResponseModel> getFaqs({required Map<String, String> queryParameter}) async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.faqs, queryParameter),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return faqResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetEarningListResponseModel> getEarnings(
      {required Map<String, String> queryParameter}) async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.earnings, queryParameter),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getEarningListResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<UpdatePreferenceResponseModel> savePreference(
      {required Map<String, String> body}) async {
    https.Response response = await ApiClient.instance.put(
      Uri.https(
        AppUrls.base,
        AppUrls.savePreference,
      ),
      body: body,
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return updatePreferenceResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<UpdatePreferenceResponseModel> getPreference() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(
        AppUrls.base,
        AppUrls.savePreference,
      ),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return updatePreferenceResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<void> logout({required Map<String, String> body}) async {
    https.Response response = await ApiClient.instance.post(
      Uri.https(
        AppUrls.base,
        AppUrls.logout,
      ),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      // return logoutResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<LogoutResponseModel> deleteAccount({required Map<String, String> body}) async {
    https.Response response = await ApiClient.instance.post(
      Uri.https(
        AppUrls.base,
        AppUrls.deleteAccount,
      ),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return logoutResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<LogoutResponseModel> documentRejectionResponse(
      {required Map<String, String> body}) async {
    https.Response response = await ApiClient.instance.post(
      Uri.https(
        AppUrls.base,
        AppUrls.documentRejectionResponse,
      ),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return logoutResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetVehicleListResponseModel> getVehicles() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(
        AppUrls.base,
        AppUrls.vehicles,
      ),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getVehicleListResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<String> getVehicle({required Map<String, String> body}) async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.vehicle, body),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return "";
      // return getVehicleListResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<LogoutResponseModel> getVehicleDetail() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(
        AppUrls.base,
        AppUrls.vehicles,
      ),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return logoutResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<AddVehicleResponseModel> addVehicle({required Map<String, String> body}) async {
    https.Response response = await ApiClient.instance.post(
      Uri.https(
        AppUrls.base,
        AppUrls.addVehicles,
      ),
      body: body,
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return addVehicleResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<LogoutResponseModel> blockVehicle({required Map<String, dynamic> body}) async {
    https.Response response = await ApiClient.instance.put(
      Uri.https(
        AppUrls.base,
        AppUrls.blockVehicle,
      ),
      body: body,
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return logoutResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<LogoutResponseModel> changeOnlineStatus({required Map<String, dynamic> body}) async {
    https.Response response = await ApiClient.instance.put(
      Uri.https(
        AppUrls.base,
        AppUrls.onlineStatus,
      ),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return logoutResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<PaymentResponse> createOrder() async {
    try {
      https.Response response = await ApiClient.instance.get(
        Uri.https(
          AppUrls.base, // host
          AppUrls.paymentCreateOrder, // path
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': getToken(), // same as your other call
        },
      );

      // log("➡️ Request Body: ${json.encode(body)}");

      if (response.statusCode == 200 || response.statusCode == 400) {
        // ✅ both success and failed order return your model structure
        return PaymentResponse.fromJson(json.decode(response.body));
      } else {
        throw HttpException(
          "Error ${response.statusCode}: ${response.body}",
        );
      }
    } catch (e) {
      ApiLog.error('createOrder failed', e);
      rethrow;
    }
  }

  static Future<String> confirmPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    final url = Uri.https(
      AppUrls.base,
      AppUrls.paymentSuccess,
    );

    final body = {
      "razorpay_order_id": razorpayOrderId,
      "razorpay_payment_id": razorpayPaymentId,
      "razorpay_signature": razorpaySignature,
    };

    try {
      final response = await ApiClient.instance.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": getToken(), // 👈 same as other APIs
        },
        body: json.encode(body),
      );


      if (response.statusCode == 200) {
        return "✅ Payment confirmed successfully!";
      } else {
        throw HttpException(
          "Error ${response.statusCode}: ${response.body}",
        );
      }
    } catch (e) {
      ApiLog.error('confirmPayment failed', e);
      rethrow;
    }
  }

  static Future<GetOnlineStatusResponseModel> getOnlineStatus() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(
        AppUrls.base,
        AppUrls.onlineStatus,
      ),
      headers: {'Content-Type': 'application/json', "Authorization": getToken()},
    );

    if (response.statusCode == 200) {
      return getOnlineStatusResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetRideDetailsResponseModel> rideOrderDetails(
      {required Map<String, dynamic> queryParameters}) async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.rideOrderDetails, queryParameters),
      headers: {"Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return getRideDetailsResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<ReasonForCancelModel> reasonForCancel() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.rideCancelReasons),
      headers: {"Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return ReasonForCancelModel.fromJson(jsonDecode(response.body));
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<ChangeRideStatusModel> changeRideStatus({required Map<String, dynamic> body}) async {
    https.Response response = await ApiClient.instance.put(
      Uri.https(AppUrls.base, AppUrls.changeRideStatus),
      body: json.encode(body),
      headers: {"Authorization": getToken(), 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return changeRideStatusFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetRideDetailsResponseModel> latestActiveRide() async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.latestActiveRide),
      headers: {"Authorization": getToken(), 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return getRideDetailsResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GetDriverProfileResponseModel> driverProfile({
    required Map<String, dynamic> queryParameter,
  }) async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.driverProfile, queryParameter),
      headers: {"Authorization": getToken(), 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return getDriverProfileResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<ProfileImageModel> getProfilePhoto({
    required Map<String, dynamic> queryParameter,
  }) async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.profilePhoto, queryParameter),
      headers: {"Authorization": getToken(), 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return profileImageModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<PaymentSuccessModel> getPaymentType({
    required Map<String, dynamic> queryParameter,
  }) async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.paymentType),
      headers: {"Authorization": getToken(), 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return paymentSuccessModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<RidePaymentResponseModel> getRidePayment(
      {required Map<String, dynamic> queryParameter}) async {
    https.Response response = await ApiClient.instance.get(
      Uri.https(AppUrls.base, AppUrls.getRidePayment, queryParameter),
      headers: {'Content-Type': 'application/x-www-form-urlencoded', "Authorization": getToken()},
    );
    if (response.statusCode == 200) {
      return ridePaymentResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<AddStopResponseModel> addStop({required Map<String, dynamic> body}) async {
    https.Response response = await ApiClient.instance.post(
      Uri.https(AppUrls.base, AppUrls.addStop),
      body: json.encode(body),
      headers: {"Authorization": getToken(), 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return addStopResponseModelFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<GoogleLocationResponse> getCurrentLocation(double latitude, double longitude) async {
    https.Response response = await ApiClient.instance.get(
      Uri.parse("${AppUrls.googleLocationUrl}$latitude,$longitude${AppUrls.googleApiKeyUrl}"),
    );
    // log("${Uri.parse("${AppUrls.googleLocationUrl}$latitude,$longitude${AppUrls.googleApiKeyUrl}")}===============>${response.body}");
    // log("${Uri.parse("${AppUrls.googleLocationUrl}$latitude,$longitude${AppUrls.googleApiKeyUrl}")}===============>${response.body}");
    if (response.statusCode == 200) {
      return googleLocationResponseFromJson(response.body);
    } else {
      throw HttpException(response.body);
    }
  }

  static Future<WalletResponse> getPartnerWallet() async {
    try {
      https.Response response = await ApiClient.instance.get(
        Uri.https(AppUrls.base, AppUrls.walletbalance),
        headers: {"Authorization": getToken(), 'Content-Type': 'application/json'},
      );


      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        return WalletResponse.fromJson(jsonData);
      } else {
        throw HttpException(response.body);
      }
    } catch (e, s) {
      ApiLog.error('getPartnerWallet failed', e, s);
      rethrow;
    }
  }
}
