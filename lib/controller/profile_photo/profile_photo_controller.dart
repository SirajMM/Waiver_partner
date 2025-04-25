import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waiver_driver/backend/model/chauffeur_proof/chauffeur_proof_model.dart';

import '../../core/colors/app_colors.dart';


class ProfilePhotoControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfilePhotoController());
  }
}

class ProfilePhotoController extends GetxController {
  static ProfilePhotoController get to => Get.find();
  @override
  void onInit() {
    super.onInit();
    profilePhotoItem = Get.arguments;
    profilePhoto.value =
        profilePhotoItem?.documentProof?.files?.first.file ?? "";
  }

  RxString profilePhoto = "".obs;
  AddProofItemModel? profilePhotoItem;
  RxBool showErrorMessageProfilePhoto = false.obs;
  uploadPhoto({
    required ImageSource source,
  }) async {
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
      profilePhoto.value = cropperImage?.path ?? "";
      showErrorMessageProfilePhoto.value = false;
    }
    Get.back();
  }

  uploadDocument() {
    if (profilePhoto.value.isEmpty) {
      showErrorMessageProfilePhoto.value = true;
    } else {
      Get.back();
    }
  }
}
