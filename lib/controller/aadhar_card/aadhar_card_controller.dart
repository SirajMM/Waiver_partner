import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waiver_driver/backend/model/aadhar_card/aadhar_card_model.dart';
import 'package:waiver_driver/backend/model/chauffeur_proof/chauffeur_proof_model.dart';
import 'package:waiver_driver/backend/model/registration_certificate/registration_certificate_model.dart';
import 'package:waiver_driver/backend/parser/Aadhar/aadhart_parser.dart';

import '../../backend/api/api_services/api_services.dart';
import '../../core/colors/app_colors.dart';
import '../../core/constants/enums/enums.dart';

// class AadharCardControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => AadharCardController());
//   }
// }

class AadharCardController extends GetxController {
  AadharParser parser;
  AadharCardController({required this.parser});

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
  Rx<String?> imagePathShow = Rx<String?>(null);
  RxBool showErrorMessage = false.obs;
  RxString errorMessage = "".obs;

  uploadPhoto({required ImageSource source}) async {
    XFile? imageFile = await ImagePicker().pickImage(source: source);

    if (imageFile != null) {
      final File file1 = File(imageFile.path);
      final int fileSize = await file1.length();
      print("******************* File size before cropping: ${fileSize} bytes");
      CroppedFile? cropperImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: aspectRatio,

        // Add padding here

        compressQuality: 50,
        maxWidth: 300,
        maxHeight: 300,
        // Specific UI settings for Android
        uiSettings: [
          AndroidUiSettings(
            cropStyle: CropStyle.rectangle,
            toolbarTitle: '',
            hideBottomControls: true,
            lockAspectRatio: true,
            showCropGrid: false,
            toolbarColor: AppColors.black,
            toolbarWidgetColor: AppColors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            // Add padding specific settings
            cropFrameColor: AppColors.white,
            cropFrameStrokeWidth: 5,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPresetCustom(),
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            // iOS-specific padding can be added similarly if needed
          ),
        ],
      );
      http.MultipartFile file = await http.MultipartFile.fromPath(
        "file",
        cropperImage?.path ?? "",
      );
      // UploadFileResponseModel response =
      //     await ApiServices.uploadFile(files: file, fields: fields);
      // String imagePath = response.data?.file ?? "";
      // imagePathShow.value = imagePath;
      // imageList.insert(0, FileElement(file: imagePath));
      final File file2 = File(cropperImage!.path);
      final int fileSize1 = await file1.length();
      print("******************* File size After cropping: ${fileSize} bytes");
      try {
        // Attempt to upload the file
        UploadFileResponseModel response =
            await ApiServices.uploadFile(files: file, fields: fields);

        // Check if response contains valid data
        if (response.data != null) {
          String imagePath = response.data?.file ?? "";
          imagePathShow.value = imagePath;
          imageList.insert(0, FileElement(file: imagePath));
        } else {
          // Handle case where response doesn't contain expected data
          print("Upload successful but no file data returned");
          throw Exception("No file data in response");
        }
      } catch (uploadError) {
        // Log the error for debugging
        print("Error during file upload process: $uploadError");

        // Handle the error appropriately
        // You could show a user-friendly message
        Future.delayed(Duration(milliseconds: 100), () {
          Get.snackbar(
            "Upload Failed",
            "Unable to upload image facing Some issues . Please try again later.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.red176,
            colorText: AppColors.white,
          );
        });

        // Optionally rethrow or handle differently based on your app's needs
        // rethrow;
      }
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

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
