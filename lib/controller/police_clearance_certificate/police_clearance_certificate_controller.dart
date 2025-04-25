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




class PoliceClearanceCertificateControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PoliceClearanceCertificateController());
  }
}

class PoliceClearanceCertificateController extends GetxController {
  static PoliceClearanceCertificateController get to => Get.find();
  @override
  void onInit() async {
    super.onInit();
    try {
      isLoading.value = true;
      PoliceClearence = Get.arguments;
      imageList.value = PoliceClearence?.documentProof?.files ?? [];
      print(imageList.length);
      if ((PoliceClearence?.documentProof?.rejection?.reason ?? "") != "") {
        isRejected = true;
        rejectionID = PoliceClearence?.documentProof?.id ?? "";
        rejectionReason =
            PoliceClearence?.documentProof?.rejection?.reason ?? "";
        userResponseToRejection.text =
            PoliceClearence?.documentProof?.rejection?.userResponse ?? "";
      }
    } finally {
      isLoading.value = false;
    }
  }

  GlobalKey<FormState> uploadProofPoliceClearenceFormKey = GlobalKey();
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  bool isRejected = false;
  String? rejectionID;
  String rejectionReason = "";
  TextEditingController userResponseToRejection = TextEditingController();
  AddProofItemModel? PoliceClearence;
  RxList<FileElement> imageList = <FileElement>[].obs;

  RxString policeClearanceCertificate = "".obs;
  RxBool showErrorMessagePoliceClearanceCertificate = false.obs;
  uploadPhoto({
    required ImageSource source,
  }) async {
    XFile? imageFile = await ImagePicker().pickImage(source: source);
    if (imageFile != null) {
      CroppedFile? cropperImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        // cropStyle: CropStyle.rectangle,
        aspectRatio: const CropAspectRatio(ratioX: 9, ratioY: 16),
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
          fields: {"document_type": DocumentType.policeClearanceCertificate});
      String imagePath = response.data?.file ?? "";
      imageList.insert(0, FileElement(file: imagePath));
    }
    Get.back();
  }

  uploadDocument() async {
    if (imageList.value.isEmpty) {
      showErrorMessagePoliceClearanceCertificate.value = true;
    } else {
      var response = await ApiServices.uploadDocument(body: {
        "files": imageList.map((element) => element.file).toList(),
        "document_type": DocumentType.policeClearanceCertificate
      });
      if (response.data?.files?.isNotEmpty ?? false) {
        PoliceClearence?.documentProof?.files = (response.data?.files ?? [])
            .map((e) => FileElement(file: e))
            .toList();
        PoliceClearence?.approvalStatus.value =
            ApprovalStatus.waitingForApproval;
        Get.back();
      }
    }
  }

  documentRejectionResponse() {
    ApiServices.documentRejectionResponse(body: {
      "rejection_id": rejectionID!,
      "response": userResponseToRejection.text,
    });
  }
}
