import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/colors/app_colors.dart';



class VehiclePermitControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VehiclePermitController());
  }
}

class VehiclePermitController extends GetxController {
  static VehiclePermitController get to => Get.find();
  RxString vehiclePermit = "".obs;
  RxBool showErrorMessageVehiclePermit = false.obs;
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
      vehiclePermit.value = cropperImage?.path ?? "";
      showErrorMessageVehiclePermit.value = false;
    }
    Get.back();
  }

  uploadDocument() {
    if (vehiclePermit.value.isEmpty) {
      showErrorMessageVehiclePermit.value = true;
    } else {
      Get.back();
    }
  }
}
