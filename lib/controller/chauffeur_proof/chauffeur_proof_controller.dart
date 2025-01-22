import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:waiver_driver/backend/model/chauffeur_proof/chauffeur_proof_model.dart';
import 'package:waiver_driver/backend/model/registration_certificate/registration_certificate_model.dart';
import 'package:waiver_driver/backend/parser/ChauffeurProof/ChauffeurProof_parser.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';

import '../../backend/api/api_services/api_services.dart';
import '../../backend/api/api_services/urls.dart';
import '../../core/constants/enums/enums.dart';
import '../../helper/router/app_routes/app_routes.dart';
import '../../main.dart';

// class ChauffeurProofControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => ChauffeurProofController());
//   }
// }

class ChauffeurProofController extends GetxController {
  final ChauffeurProof_parser parser;
  ChauffeurProofController({required this.parser});
  @override
  void onInit() async {
    super.onInit();
    Get.lazyPut(() => ApiServices(appBaseUrl: AppUrls.base));
    try {
      isLoading.value = true;
      await Future.wait([getDocument(), getProfileImage(), getBankAccount()]);
      isError.value = false;
    } catch (error) {
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  RxBool isError = false.obs;
  RxBool isLoading = false.obs;

  StreamSubscription<List<ConnectivityResult>>? subscription;
  RxBool isInternetConnected = true.obs;

  static ChauffeurProofController get to => Get.find();
  String chauffeurName = box.read(BoxKeys.userName) ?? "";

//   /// Function to check if the device is connected to the internet
// Future<bool> isConnectedToInternet() async {
//   // Check the connectivity status
//   var connectivityResult = await Connectivity().checkConnectivity();

//   // Determine if the device is connected to a network
//   if (connectivityResult != ConnectivityResult.none) {
//     // Use InternetConnectionChecker to verify the connection to the internet
//     return await InternetConnectionChecker().hasConnection;
//   }

//   // No connectivity detected
//   return false;
// }

  Future<bool> isConnectedToInternet() async {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      bool isConnected =
          await InternetConnectionChecker.createInstance().hasConnection;

      isInternetConnected.value = isConnected;
    });
    return isInternetConnected.value;
  }

  RxBool isAgreedToTermsAndConditions = false.obs;
  RxBool showTermsAndConditionsError = false.obs;
  GetProfilePhotoResponseModel? profilePhotoResponse;
  Future<void> getProfileImage() async {
    profilePhotoResponse = await ApiServices.getProfileImage();
    profilePhoto.status.value =
        profilePhotoResponse?.data?.profileImage?.isNotEmpty ?? false
            ? ApprovalStatus.waitingForApproval
            : ApprovalStatus.notUpload;
  }

  GetBankAccountResponseModel? bankAccountResponse;
  Future<void> getBankAccount() async {
    bankAccountResponse = await ApiServices.getBankAccount();
    bankAccount.status.value = bankAccountResponse?.data?.isVerified ?? false
        ? ApprovalStatus.approved
        : bankAccountResponse?.data?.accountNumber?.isNotEmpty ?? false
            ? ApprovalStatus.waitingForApproval
            : ApprovalStatus.notUpload;
  }

  Future<void> getDocument() async {
    GetDocumentsResponseModel response = await ApiServices.getDocument();

    profilePhoto.images.value = response.data
            ?.firstWhereOrNull(
                (element) => element.documentType == DocumentType.profilePhoto)
            ?.files ??
        [];
    profilePhoto.status.value = checkApprovalStatus(
        proofDocument: response.data ?? [],
        documentType: DocumentType.profilePhoto);

    aadharCard.images.value = response.data
            ?.firstWhereOrNull(
                (element) => element.documentType == DocumentType.aadhar)
            ?.files ??
        [];
    aadharCard.status.value = checkApprovalStatus(
      proofDocument: response.data ?? [],
      documentType: DocumentType.aadhar,
    );

    drivingLicense.images.value = response.data
            ?.firstWhereOrNull(
                (element) => element.documentType == DocumentType.license)
            ?.files ??
        [];
    drivingLicense.status.value = checkApprovalStatus(
        proofDocument: response.data ?? [], documentType: DocumentType.license);

    policeClearanceCertificate.images.value = response.data
            ?.firstWhereOrNull((element) =>
                element.documentType == DocumentType.policeClearanceCertificate)
            ?.files ??
        [];
    policeClearanceCertificate.status.value = checkApprovalStatus(
        proofDocument: response.data ?? [],
        documentType: DocumentType.policeClearanceCertificate);
  }

  ApprovalStatus checkApprovalStatus(
      {required List<ProofDocument> proofDocument,
      required String documentType}) {
    ProofDocument? document = proofDocument
        .firstWhereOrNull((element) => element.documentType == documentType);
    return document?.status == ChauffeurProofApprovalType.approved
        ? ApprovalStatus.approved
        : document?.status == ChauffeurProofApprovalType.waitingForApproval
            ? ApprovalStatus.waitingForApproval
            : document?.status == ChauffeurProofApprovalType.rejected
                ? ApprovalStatus.rejected
                : ApprovalStatus.notUpload;
  }

  ProofModel aadharCard = ProofModel(
    text: "Aadhar Card",
    subText:
        "Please upload the specified document with consideration of the below given instructions",
    images: <FileElement>[].obs,
    status: ApprovalStatus.notUpload.obs,
    type: DocumentType.aadhar,
    isProfile: true,
    maxPhotos: 2,
    aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
  );

  ProofModel profilePhoto = ProofModel(
    text: "Profile Photo",
    subText:
        "Please upload the specified document with consideration of the below given instructions",
    images: <FileElement>[].obs,
    status: ApprovalStatus.notUpload.obs,
    type: DocumentType.profilePhoto,
    isProfile: false,
    maxPhotos: 1,
    aspectRatio: const CropAspectRatio(ratioX: 5, ratioY: 5),
  );
  ProofModel drivingLicense = ProofModel(
    text: "Driving License",
    subText:
        "Please upload the specified document with consideration of the below given instructions",
    images: <FileElement>[].obs,
    status: ApprovalStatus.notUpload.obs,
    type: DocumentType.license,
    isProfile: false,
    maxPhotos: 2,
    aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
  );
  ProofModel policeClearanceCertificate = ProofModel(
    text: "Police Clearance Certificate/"
        "\nOnline platform ID/"
        "\nPan Card",
    subText:
        "Please upload the specified document with consideration of the below given instructions",
    images: <FileElement>[].obs,
    status: ApprovalStatus.notUpload.obs,
    type: DocumentType.policeClearanceCertificate,
    isProfile: false,
    maxPhotos: 1,
    aspectRatio: const CropAspectRatio(ratioX: 9, ratioY: 16),
  );

  ProofModel bankAccount = ProofModel(
    text: "Bank Account",
    subText:
        "Please upload the specified document with consideration of the below given instructions",
    images: <FileElement>[].obs,
    status: ApprovalStatus.waitingForApproval.obs,
    type: DocumentType.none,
  );

  continueTo() {
    if (!isAgreedToTermsAndConditions.value) {
      showTermsAndConditionsError.value = true;
    } else {
      if (profilePhoto.status.value == ApprovalStatus.approved &&
          aadharCard.status.value == ApprovalStatus.approved &&
          drivingLicense.status.value == ApprovalStatus.approved &&
          policeClearanceCertificate.status.value == ApprovalStatus.approved &&
          bankAccount.status.value == ApprovalStatus.approved) {
        Get.toNamed(AppRoutes.home);
      } else if (profilePhoto.status.value ==
              ApprovalStatus.waitingForApproval &&
          aadharCard.status.value == ApprovalStatus.waitingForApproval &&
          drivingLicense.status.value == ApprovalStatus.waitingForApproval &&
          policeClearanceCertificate.status.value ==
              ApprovalStatus.waitingForApproval &&
          bankAccount.status.value == ApprovalStatus.waitingForApproval) {
        Get.toNamed(AppRoutes.waitingForAuthorization);
        // Get.toNamed(AppRoutes.home);
        Get.showSnackbar(
          const GetSnackBar(
            duration: Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(
              text:
                  "All documents  must be uploaded and approved before you can proceed, Please wait",
            ),
          ),
        );
      } else {
        Get.showSnackbar(
          const GetSnackBar(
            duration: Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(
              text:
                  "All documents  must be uploaded and approved before you can proceed, Please wait",
            ),
          ),
        );
      }
    }
  }
}
