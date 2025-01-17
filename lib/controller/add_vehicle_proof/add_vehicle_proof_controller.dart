import 'package:flutter/material.dart';
import 'package:flutter_custom_utils/flutter_custom_utils.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:waiver_driver/backend/model/chauffeur_proof/chauffeur_proof_model.dart';
import 'package:waiver_driver/backend/model/fleet_home_page/fleet_home_page_model.dart';
import 'package:waiver_driver/backend/model/registration_certificate/registration_certificate_model.dart';
import 'package:waiver_driver/core/constants/enums/enums.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';

import '../../core/constants/get_storage_constants.dart';




class AddVehicleProofControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddVehicleProofController());
  }
}

class AddVehicleProofController extends GetxController {
  static AddVehicleProofController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    vehicle = Get.arguments;
    registrationCertificate.vehicleID = vehicle?.id!;
    vehicleInsurance.vehicleID = vehicle?.id!;
    vehiclePermit.vehicleID = vehicle?.id!;
    vehicleProof = vehicle?.proof;

    registrationCertificate.images.value = vehicleProof
            ?.firstWhereOrNull((element) =>
                element.proofType == DocumentType.registrationCerifcatre)
            ?.files ??
        [];
    registrationCertificate.status.value = checkApprovalStatus(
      proofDocument: vehicleProof ?? [],
      documentType: DocumentType.registrationCerifcatre,
    );

    vehicleInsurance.images.value = vehicleProof
            ?.firstWhereOrNull(
                (element) => element.proofType == DocumentType.vehicleInsuracne)
            ?.files ??
        [];
    vehicleInsurance.status.value = checkApprovalStatus(
      proofDocument: vehicleProof ?? [],
      documentType: DocumentType.vehicleInsuracne,
    );

    vehiclePermit.images.value = vehicleProof
            ?.firstWhereOrNull(
                (element) => element.proofType == DocumentType.vechilePemit)
            ?.files ??
        [];
    vehiclePermit.status.value = checkApprovalStatus(
      proofDocument: vehicleProof ?? [],
      documentType: DocumentType.vechilePemit,
    );
    vehicleImage.images.value = vehicleProof
            ?.firstWhereOrNull(
                (element) => element.proofType == DocumentType.vechileImage)
            ?.files ??
        [];
    vehicleImage.status.value = checkApprovalStatus(
      proofDocument: vehicleProof ?? [],
      documentType: DocumentType.vechileImage,
    );
  }

  ApprovalStatus checkApprovalStatus(
      {required List<ProofDocument> proofDocument,
      required String documentType}) {
    ProofDocument? document = proofDocument
        .firstWhereOrNull((element) => element.proofType == documentType);

    return document?.status == ChauffeurProofApprovalType.approved
        ? ApprovalStatus.approved
        : document?.status == ChauffeurProofApprovalType.waitingForApproval
            ? ApprovalStatus.waitingForApproval
            : document?.status == ChauffeurProofApprovalType.rejected
                ? ApprovalStatus.rejected
                : ApprovalStatus.notUpload;
  }

  List<ProofDocument>? vehicleProof;

  FleetVehicle? vehicle;
  ProofModel registrationCertificate = ProofModel(
    text: "Registration Certificate( RC)",
    subText:
        "Please upload the specified document with consideration of the below given instructions",
    images: <FileElement>[].obs,
    status: ApprovalStatus.notUpload.obs,
    type: DocumentType.registrationCerifcatre,
    isProfile: true,
    maxPhotos: 2,
    aspectRatio: const CropAspectRatio(
      ratioX: 16,
      ratioY: 9,
    ),
  );
  ProofModel vehicleInsurance = ProofModel(
    text: "Vehicle Insurance",
    subText:
        "Please upload the specified document with consideration of the below given instructions",
    images: <FileElement>[].obs,
    status: ApprovalStatus.notUpload.obs,
    type: DocumentType.vehicleInsuracne,
    maxPhotos: 2,
    aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
  );
  ProofModel vehiclePermit = ProofModel(
    text: "Vehicle Permit",
    subText:
        "Please upload the specified document with consideration of the below given instructions",
    images: <FileElement>[].obs,
    status: ApprovalStatus.notUpload.obs,
    type: DocumentType.vechilePemit,
    maxPhotos: 2,
    aspectRatio: const CropAspectRatio(
      ratioX: 16,
      ratioY: 9,
    ),
  );
  ProofModel vehicleImage = ProofModel(
    text: "Vehicle Image",
    subText:
        "Please upload the specified document with consideration of the below given instructions",
    images: <FileElement>[].obs,
    status: ApprovalStatus.notUpload.obs,
    type: DocumentType.vechileImage,
    maxPhotos: 4,
    aspectRatio: const CropAspectRatio(
      ratioX: 16,
      ratioY: 9,
    ),
  );

  RxBool showTermsAndConditionsError = false.obs;
  RxBool isAgreedToTermsAndConditions = false.obs;

  submit() {
    if (!isAgreedToTermsAndConditions.value) {
      showTermsAndConditionsError.value = true;
    } else {
      Get.back();
      Get.showSnackbar(
        GetSnackBar(
          duration: 5.cSeconds,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          messageText: const AppSnackBar(
            text: "All documents  are uploaded and are waiting for approval",
          ),
        ),
      );
    }
  }
}
