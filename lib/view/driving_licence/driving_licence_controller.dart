import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waiver_driver/backend/model/chauffeur_proof/chauffeur_proof_model.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/constants/enums/enums.dart';

import '../../backend/api/api_services/api_services.dart';
import '../../backend/model/aadhar_card/aadhar_card_model.dart';
import '../../core/constants/get_storage_constants.dart';



class DrivingLicenceControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DrivingLicenceController());
  }
}

class DrivingLicenceController extends GetxController {
  @override
  void onInit() async {
    try {
      isLoading.value = true;
      drivingLisence = Get.arguments;
      imageList.value = drivingLisence?.documentProof?.files ?? [];
      print(imageList.length);
      print(drivingLisence?.documentProof?.files?.length);
      if ((drivingLisence?.documentProof?.rejection?.reason ?? "") != "") {
        isRejected = true;
        rejectionID = drivingLisence?.documentProof?.id ?? "";
        rejectionReason =
            drivingLisence?.documentProof?.rejection?.reason ?? "";
        userResponseToRejection.text =
            drivingLisence?.documentProof?.rejection?.userResponse ?? "";
      }
    } finally {
      isLoading.value = false;
    }
  }

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  bool isRejected = false;
  String? rejectionID;
  GlobalKey<FormState> uploadProofLisenceFormKey = GlobalKey();

  String rejectionReason = "";
  TextEditingController userResponseToRejection = TextEditingController();
  AddProofItemModel? drivingLisence;
  RxList<FileElement> imageList = <FileElement>[].obs;

  static DrivingLicenceController get to => Get.find();
  RxString drivingLicenceFrontSide = "".obs;
  RxString drivingLicenceBackSide = "".obs;
  RxBool showErrorMessageDrivingLicence = false.obs;
  RxString errorMessageDrivingLicence = "".obs;
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
          files: file, fields: {"document_type": DocumentType.aadhar});
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
    if (imageList.isEmpty) {
      showErrorMessageDrivingLicence.value = true;
      errorMessageDrivingLicence.value =
          "Please upload both sides of aadhar card";
    } else {
      var response = await ApiServices.uploadDocument(body: {
        "files": imageList.map((element) => element.file).toList(),
        "document_type": DocumentType.license
      });
      if (response.data?.files?.isNotEmpty ?? false) {
        drivingLisence?.documentProof?.files = (response.data?.files ?? [])
            .map((e) => FileElement(file: e))
            .toList();
        drivingLisence?.approvalStatus.value =
            ApprovalStatus.waitingForApproval;
        Get.back();
      }
    }
  }
}
