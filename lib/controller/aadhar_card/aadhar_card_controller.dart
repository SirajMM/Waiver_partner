import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waiver_driver/backend/model/aadhar_card/aadhar_card_model.dart';
import 'package:waiver_driver/backend/model/chauffeur_proof/chauffeur_proof_model.dart';
import 'package:waiver_driver/backend/model/registration_certificate/registration_certificate_model.dart';

import '../../backend/api/api_services/api_services.dart';
import '../../core/colors/app_colors.dart';
import '../../core/constants/enums/enums.dart';




class AadharCardControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AadharCardController());
  }
}

class AadharCardController extends GetxController {
  static AadharCardController get to => Get.find();

  @override
  void onInit() async {
    super.onInit();
    try {
      isLoading.value = true;
      ProofModel arguments = Get.arguments;
      vehicleID = arguments.vehicleID;
      imageList.value = arguments.images;
      rejection = arguments.rejection;
      maxImages = arguments.maxPhotos;
      status = arguments.status;
      text = arguments.text;
      subtext = arguments.subText;
      type = arguments.type;
      vehicleId = arguments.vehicleID;
      aspectRatio = arguments.aspectRatio;
      (vehicleID ?? "").isEmpty
          ? fields.addAll({"document_type": arguments.type})
          : fields.addAll({"proof_type": arguments.type});
      fields.addAllIf(vehicleID != null,
          {"vehicle_id": (arguments.vehicleID ?? 0).toString()});
    } finally {
      isLoading.value = false;
    }
  }

  String? type;
  String? vehicleID;
  int? maxImages;
  GlobalKey<FormState> formKeyRejection = GlobalKey();
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  Rejection? rejection;
  Map<String, String> fields = {};
  String? text;
  String? subtext;
  String? vehicleId;
  CropAspectRatio? aspectRatio;
  List<CropAspectRatioPreset>? aspectRatioPresets;
  RxList<FileElement> imageList = <FileElement>[].obs;
  TextEditingController userResponseToRejection = TextEditingController();
  Rx<ApprovalStatus?> status = Rx<ApprovalStatus?>(null);

  RxBool showErrorMessage = false.obs;
  RxString errorMessage = "".obs;
  uploadPhoto({required ImageSource source}) async {
    XFile? imageFile = await ImagePicker().pickImage(source: source);
    if (imageFile != null) {
      CroppedFile? cropperImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: aspectRatio,
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
      http.MultipartFile file = await http.MultipartFile.fromPath(
        "file",
        cropperImage?.path ?? "",
      );
      UploadFileResponseModel response =
          await ApiServices.uploadFile(files: file, fields: fields);
      String imagePath = response.data?.file ?? "";
      imageList.insert(0, FileElement(file: imagePath));
    }
    Get.back();
  }

  documentRejectionResponse() {
    ApiServices.documentRejectionResponse(body: {
      "rejection_id": "",
      "response": userResponseToRejection.text,
    });
    Get.back();
    Get.back();
    status.value = ApprovalStatus.waitingForApproval;
  }

  uploadDocument() async {
    if (imageList.length < (maxImages ?? 2)) {
      showErrorMessage.value = true;
      errorMessage.value =
          "Please upload both sides of the document, For ${text?.toLowerCase()} both sides are required";
    } else {
      if ((vehicleId ?? "").isEmpty) {
        Map<String, dynamic> body = {
          "files": imageList.map((element) => element.file).toList(),
        };

        UploadDocumentResponseModel response =
            await ApiServices.uploadDocument(body: {
          "files": imageList.map((element) => element.file).toList(),
          "document_type": type,
        });
        if (response.data?.files?.isNotEmpty ?? false) {
          imageList.value = (response.data?.files ?? [])
              .map((e) => FileElement(file: e))
              .toList();
          status.value = ApprovalStatus.waitingForApproval;
          Get.back();
        }
      } else {
        var response = await ApiServices.addVehicleProof(body: {
          "files": imageList.map((element) => element.file).toList(),
          "proof_type": type,
          "vehicle_id": vehicleId
        });
        if (response.data?.files?.isNotEmpty ?? false) {
          imageList.value = (response.data?.files ?? [])
              .map((e) => FileElement(file: e))
              .toList();
          status.value = ApprovalStatus.waitingForApproval;
          Get.back();
        }
      }
    }
  }
}
