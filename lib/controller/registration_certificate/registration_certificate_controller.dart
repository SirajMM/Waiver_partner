import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waiver_driver/backend/model/aadhar_card/aadhar_card_model.dart';
import 'package:waiver_driver/backend/model/chauffeur_proof/chauffeur_proof_model.dart';


import '../../backend/api/api_services/api_services.dart';

import '../../core/colors/app_colors.dart';
import '../../core/constants/enums/enums.dart';
import '../../core/constants/get_storage_constants.dart';



class RegistrationCertificateControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegistrationCertificateController());
  }
}

class RegistrationCertificateController extends GetxController {
  @override
  void onInit() async {
    try {
      isLoading.value = true;
      registrartionCertificate = Get.arguments;
      imageList.value = registrartionCertificate?.documentProof?.files ?? [];
      print(imageList.length);
      if ((registrartionCertificate?.documentProof?.rejection?.reason ?? "") !=
          "") {
        isRejected = true;
        rejectionID = registrartionCertificate?.documentProof?.id ?? "";
        rejectionReason =
            registrartionCertificate?.documentProof?.rejection?.reason ?? "";
        userResponseToRejection.text =
            registrartionCertificate?.documentProof?.rejection?.userResponse ??
                "";
      }
    } finally {
      isLoading.value = false;
    }
  }

  GlobalKey<FormState> uploadProofAadharCardFormKey = GlobalKey();
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  bool isRejected = false;
  String? rejectionID;
  String rejectionReason = "";
  TextEditingController userResponseToRejection = TextEditingController();
  AddProofItemModel? registrartionCertificate;
  static RegistrationCertificateController get to => Get.find();
  RxList<FileElement> imageList = <FileElement>[].obs;
  RxBool showErrorMessageAadharCard = false.obs;
  RxString errorMessageAadharCard = "".obs;
  uploadPhoto({required ImageSource source, required bool isFrontSide}) async {
    XFile? imageFile = await ImagePicker().pickImage(source: source);
    if (imageFile != null) {
      CroppedFile? cropperImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        // cropStyle: CropStyle.rectangle,
        aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '',
            hideBottomControls: true,
            lockAspectRatio: true,
            showCropGrid: false,
            toolbarColor: AppColors.black,
            toolbarWidgetColor: AppColors.white,
            initAspectRatio: CropAspectRatioPreset.original,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      http.MultipartFile file =
          await http.MultipartFile.fromPath("file", cropperImage?.path ?? "");

      UploadFileResponseModel response = await ApiServices.uploadFile(
          files: file,
          fields: {"document_type": DocumentType.registrationCerifcatre});
      String imagePath = response.data?.file ?? "";
      imageList.insert(0, FileElement(file: imagePath));
    }
    Get.back();
  }

  documentRejectionResponse() {
    ApiServices.documentRejectionResponse(body: {
      "rejection_id": rejectionID!,
      "response": userResponseToRejection.text,
    });
  }

  uploadDocument() async {
    if (imageList.length <= 1) {
      showErrorMessageAadharCard.value = true;
      errorMessageAadharCard.value = "Please upload both sides of aadhar card";
    } else {
      UploadDocumentResponseModel response =
          await ApiServices.addVehicleProof(body: {
        "files": imageList.map((element) => element.file).toList(),
        "document_type": DocumentType.registrationCerifcatre,
        "vehicle_id": DocumentType.registrationCerifcatre
      });

      if (response.data?.files?.isNotEmpty ?? false) {
        registrartionCertificate?.documentProof?.files =
            (response.data?.files ?? [])
                .map((e) => FileElement(file: e))
                .toList();
        registrartionCertificate?.approvalStatus.value =
            ApprovalStatus.waitingForApproval;
        Get.back();
      }
    }
  }
}
