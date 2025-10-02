import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:crop_your_image/crop_your_image.dart' hide ImageCropper;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import '../../core/widgets/CustomImageCropper/CustomImageCropperWidget.dart';

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

  //  uploadPhoto({required ImageSource source}) async {
  //    XFile? imageFile = await ImagePicker().pickImage(source: source);

  //    if (imageFile != null) {
  //      final File file1 = File(imageFile.path);
  //      final int fileSize = await file1.length();
  //      print("******************* File size before cropping: ${fileSize} bytes");
  //      CroppedFile? cropperImage = await ImageCropper().cropImage(
  //        sourcePath: imageFile.path,
  //        aspectRatio: aspectRatio,

  //        // Add padding here

  //        compressQuality: 50,
  //        maxWidth: 300,
  //        maxHeight: 300,
  //        // Specific UI settings for Android
  //        uiSettings: [
  //          AndroidUiSettings(
  //            cropStyle: CropStyle.rectangle,
  //            toolbarTitle: '',
  //            hideBottomControls: true,
  //            lockAspectRatio: true,
  //            showCropGrid: false,
  //            toolbarColor: AppColors.black,
  //            toolbarWidgetColor: AppColors.white,
  //            initAspectRatio: CropAspectRatioPreset.original,
  //            // Add padding specific settings
  //            cropFrameColor: AppColors.white,
  //            cropFrameStrokeWidth: 5,
  //            aspectRatioPresets: [
  //              CropAspectRatioPreset.original,
  //              CropAspectRatioPreset.square,
  //              CropAspectRatioPreset.ratio4x3,
  //              CropAspectRatioPresetCustom(),
  //            ],
  //          ),
  //          IOSUiSettings(
  //            title: 'Cropper',
  //            // iOS-specific padding can be added similarly if needed
  //          ),
  //        ],
  //      );
  //      http.MultipartFile file = await http.MultipartFile.fromPath(
  //        "file",
  //        cropperImage?.path ?? "",
  //      );
  //      // UploadFileResponseModel response =
  //      //     await ApiServices.uploadFile(files: file, fields: fields);
  //      // String imagePath = response.data?.file ?? "";
  //      // imagePathShow.value = imagePath;
  //      // imageList.insert(0, FileElement(file: imagePath));
  //      final File file2 = File(cropperImage!.path);
  //      final int fileSize1 = await file1.length();
  //      print("******************* File size After cropping: ${fileSize} bytes");
  //      try {
  //        // Attempt to upload the file
  //        UploadFileResponseModel response =
  //            await ApiServices.uploadFile(files: file, fields: fields);

  //        // Check if response contains valid data
  //        if (response.data != null) {
  //          String imagePath = response.data?.file ?? "";
  //          imagePathShow.value = imagePath;
  //          imageList.insert(0, FileElement(file: imagePath));
  //        } else {
  //          // Handle case where response doesn't contain expected data
  //          print("Upload successful but no file data returned");
  //          throw Exception("No file data in response");
  //        }
  //      } catch (uploadError) {
  //        // Log the error for debugging
  //        print("Error during file upload process: $uploadError");

  //        // Handle the error appropriately
  //        // You could show a user-friendly message
  //        Future.delayed(Duration(milliseconds: 100), () {
  //          Get.snackbar(
  //            "Upload Failed",
  //            "Unable to upload image facing Some issues . Please try again later.",
  //            snackPosition: SnackPosition.BOTTOM,
  //            backgroundColor: AppColors.red176,
  //            colorText: AppColors.white,
  //          );
  //        });

  //        // Optionally rethrow or handle differently based on your app's needs
  //        // rethrow;
  //      }
  //    }
  //    Get.back();
  //  }
  final RxBool isUploading = false.obs;

  //  uploadPhoto({required ImageSource source}) async {
  //    // Set loading state to true at the beginning
  //    isUploading.value = true;

  //    try {
  //      XFile? imageFile = await ImagePicker().pickImage(source: source);

  //      if (imageFile != null) {
  //        final File file1 = File(imageFile.path);
  //        final int fileSize = await file1.length();
  //        print(
  //            "******************* File size before cropping: ${fileSize} bytes");

  //        CroppedFile? cropperImage = await ImageCropper().cropImage(
  //          sourcePath: imageFile.path,
  //          aspectRatio: aspectRatio,
  //          compressQuality: 85, // Increased from 50 to 85 for better quality
  //          maxWidth: 1200, // Increased from 300 to 1200
  //          maxHeight: 1200,
  //          uiSettings: [
  //            AndroidUiSettings(
  //              cropStyle: CropStyle.rectangle,
  //              toolbarTitle: '',
  //              hideBottomControls: true,
  //              lockAspectRatio: true,
  //              showCropGrid: false,
  //              toolbarColor: AppColors.black,
  //              toolbarWidgetColor: AppColors.white,
  //              initAspectRatio: CropAspectRatioPreset.original,
  //              cropFrameColor: AppColors.white,
  //              cropFrameStrokeWidth: 5,
  //              aspectRatioPresets: [
  //                CropAspectRatioPreset.original,
  //                CropAspectRatioPreset.square,
  //                CropAspectRatioPreset.ratio4x3,
  //                CropAspectRatioPresetCustom(),
  //              ],
  //            ),
  //            IOSUiSettings(
  //              title: 'Cropper',
  //            ),
  //          ],
  //        );

  //        // Exit if user cancels cropping
  //        if (cropperImage == null) {
  //          isUploading.value = false;
  //          Get.back();
  //          return;
  //        }

  //        http.MultipartFile file = await http.MultipartFile.fromPath(
  //          "file",
  //          cropperImage.path,
  //        );

  //        // final File file2 = File(cropperImage.path);
  //        // final int fileSize1 = await file1.length();
  //        // print("******************* File size After cropping: ${fileSize} bytes");

  //        try {
  //          // Attempt to upload the file
  //          UploadFileResponseModel response =
  //              await ApiServices.uploadFile(files: file, fields: fields);

  //          // Check if response contains valid data
  //          if (response.data != null) {
  //            String imagePath = response.data?.file ?? "";
  //            imagePathShow.value = imagePath;
  //            imageList.insert(0, FileElement(file: imagePath));
  //          } else {
  //            // Handle case where response doesn't contain expected data
  //            print("Upload successful but no file data returned");
  //            throw Exception("No file data in response");
  //          }
  //        } catch (uploadError) {
  //          // Log the error for debugging
  //          print("Error during file upload process: $uploadError");

  //          // Handle the error appropriately
  //          Future.delayed(Duration(milliseconds: 100), () {
  //            Get.snackbar(
  //              "Upload Failed",
  //              "Unable to upload image facing Some issues. Please try again later.",
  //              snackPosition: SnackPosition.BOTTOM,
  //              backgroundColor: AppColors.red176,
  //              colorText: AppColors.white,
  //            );
  //          });

  //          isUploading.value = false;
  //          return;
  //        }
  //      }

  //      // Clear loading state
  //      isUploading.value = false;
  //      Get.back();
  //    } catch (e) {
  //      // Handle any unexpected errors
  //      print("Unexpected error in uploadPhoto: $e");
  //      isUploading.value = false;

  //      // Show error message
  //      Get.snackbar(
  //        "Error",
  //        "An unexpected error occurred. Please try again.",
  //        snackPosition: SnackPosition.BOTTOM,
  //        backgroundColor: AppColors.red176,
  //        colorText: AppColors.white,
  //      );
  //    }
  //  }
// @@@@@@@@@@@@@@@@@@@@@@@@
  // uploadPhoto({required ImageSource source}) async {
  //   isUploading.value = true;

  //   try {
  //     XFile? imageFile = await ImagePicker().pickImage(source: source);

  //     if (imageFile != null) {
  //       final File file1 = File(imageFile.path);
  //       final int fileSize = await file1.length();
  //       print("File size before cropping: ${fileSize} bytes");

  //       // Option 1: Use the simple custom cropper (Recommended)
  //       CroppedFile? croppedFile = await showCustomImageCropper(
  //         imagePath: imageFile.path,
  //         aspectRatio: aspectRatio,
  //       );

  //       // Option 2: Use dialog wrapper for more control
  //       // CroppedFile? croppedFile = await showDialog<CroppedFile>(
  //       //   context: Get.context!,
  //       //   barrierDismissible: false,
  //       //   builder: (context) => CropperDialog(
  //       //     imagePath: imageFile.path,
  //       //     aspectRatio: aspectRatio,
  //       //   ),
  //       // );

  //       // Exit if user cancels cropping
  //       if (croppedFile == null) {
  //         isUploading.value = false;
  //         return;
  //       }

  //       http.MultipartFile file = await http.MultipartFile.fromPath(
  //         "file",
  //         croppedFile.path,
  //       );

  //       try {
  //         UploadFileResponseModel response =
  //             await ApiServices.uploadFile(files: file, fields: fields);

  //         if (response.data != null) {
  //           String imagePath = response.data?.file ?? "";
  //           imagePathShow.value = imagePath;
  //           imageList.insert(0, FileElement(file: imagePath));
  //         } else {
  //           print("Upload successful but no file data returned");
  //           throw Exception("No file data in response");
  //         }
  //         Get.back();
  //       } catch (uploadError) {
  //         print("Error during file upload process: $uploadError");
  //         Get.back();
  //         Future.delayed(Duration(milliseconds: 100), () {
  //           Get.snackbar(
  //             "Upload Failed",
  //             "Unable to upload image. Please try again later.",
  //             snackPosition: SnackPosition.BOTTOM,
  //             backgroundColor: AppColors.red176,
  //             colorText: AppColors.white,
  //           );
  //         });

  //         isUploading.value = false;
  //         return;
  //       }
  //     }

  //     isUploading.value = false;
  //   } catch (e) {
  //     print("Unexpected error in uploadPhoto: $e");
  //     isUploading.value = false;

  //     Get.snackbar(
  //       "Error",
  //       "An unexpected error occurred. Please try again.",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: AppColors.red176,
  //       colorText: AppColors.white,
  //     );
  //   }
  // }

  // Future<CroppedFile?> showCustomImageCropper({
  //   required String imagePath,
  //   CropAspectRatio? aspectRatio,
  // }) async {
  //   return await ImageCropper().cropImage(
  //     sourcePath: imagePath,
  //     aspectRatio: aspectRatio,
  //     compressQuality: 85,
  //     maxWidth: 1200,
  //     maxHeight: 1200,
  //     uiSettings: [
  //       AndroidUiSettings(
  //         toolbarTitle: 'Crop Image',
  //         toolbarColor: Colors.black,
  //         toolbarWidgetColor: Colors.white,
  //         activeControlsWidgetColor: Colors.orange,
  //         backgroundColor: Colors.black,
  //         cropFrameColor: Colors.white,
  //         cropGridColor: Colors.white.withOpacity(0.5),
  //         cropFrameStrokeWidth: 2,
  //         cropGridStrokeWidth: 1,
  //         initAspectRatio: CropAspectRatioPreset.original,
  //         lockAspectRatio: aspectRatio != null,
  //         hideBottomControls: false,
  //         // Add these properties:
  //         showCropGrid: true,
  //         dimmedLayerColor: Colors.black.withOpacity(0.8),
  //       ),
  //       IOSUiSettings(
  //         title: 'Crop Image',
  //         aspectRatioLockEnabled: aspectRatio != null,
  //         resetAspectRatioEnabled: false,
  //         aspectRatioPickerButtonHidden: true,
  //         rotateButtonsHidden: false,
  //         doneButtonTitle: 'Done',
  //         cancelButtonTitle: 'Cancel',
  //       ),
  //     ],
  //   );
  // }
  // @@@@@@@@@@@@@@@@@@@@@@@@@
  uploadPhoto({required ImageSource source}) async {
    isUploading.value = true;

    try {
      XFile? imageFile = await ImagePicker().pickImage(source: source);

      if (imageFile != null) {
        final File file1 = File(imageFile.path);
        final int fileSize = await file1.length();
        print("File size before cropping: $fileSize bytes");

        // Use custom cropper with bottom buttons for better UX
        String? croppedPath = await showDialog<String>(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) => CustomImageCropperDialog(
            imagePath: imageFile.path,
            aspectRatio:
                aspectRatio?.ratioX != null && aspectRatio?.ratioY != null
                    ? aspectRatio!.ratioX / aspectRatio!.ratioY
                    : null,
          ),
        );

        // Exit if user cancels cropping
        if (croppedPath == null) {
          isUploading.value = false;
          return;
        }

        http.MultipartFile file = await http.MultipartFile.fromPath(
          "file",
          croppedPath,
        );

        try {
          UploadFileResponseModel response =
              await ApiServices.uploadFile(files: file, fields: fields);

          if (response.data != null) {
            String imagePath = response.data?.file ?? "";
            imagePathShow.value = imagePath;
            imageList.insert(0, FileElement(file: imagePath));
            log("image uploaded");
            // Clean up temporary cropped file
            try {
              await File(croppedPath).delete();
            } catch (e) {
              print("Could not delete temp file: $e");
            }
          } else {
            print("Upload successful but no file data returned");
            throw Exception("No file data in response");
          }
          Get.back();
        } catch (uploadError) {
          print("Error during file upload process: $uploadError");
          Get.back();
          Future.delayed(Duration(milliseconds: 100), () {
            Get.snackbar(
              "Upload Failed",
              "Unable to upload image. Please try again later.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.red176,
              colorText: AppColors.white,
            );
          });

          isUploading.value = false;
          return;
        }
      }

      isUploading.value = false;
    } catch (e) {
      print("Unexpected error in uploadPhoto: $e");
      isUploading.value = false;

      Get.snackbar(
        "Error",
        "An unexpected error occurred. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.red176,
        colorText: AppColors.white,
      );
    }
  }
// uploadPhoto({required ImageSource source}) async {
//   // Set loading state to true at the beginning
//   isUploading.value = true;

//   try {
//     XFile? imageFile = await ImagePicker().pickImage(source: source);

//     if (imageFile != null) {
//       final File file1 = File(imageFile.path);
//       final int fileSize = await file1.length();
//       print("******************* File size before cropping: ${fileSize} bytes");

//       // Read image as bytes for the new cropper
//       Uint8List imageBytes = await file1.readAsBytes();

//       // Show custom cropper with bottom controls
//       Uint8List? croppedBytes = await showCustomCropperDialog(
//         context: Get.context!,
//         imageBytes: imageBytes,
//         aspectRatio: aspectRatio,
//       );

//       // Exit if user cancels cropping
//       if (croppedBytes == null) {
//         isUploading.value = false;
//         Get.back();
//         return;
//       }

//       // Save cropped image to temporary file
//       final Directory tempDir = await getTemporaryDirectory();
//       final String tempPath = '${tempDir.path}/cropped_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
//       final File croppedFile = File(tempPath);
//       await croppedFile.writeAsBytes(croppedBytes);

//       http.MultipartFile file = await http.MultipartFile.fromPath(
//         "file",
//         croppedFile.path,
//       );

//       try {
//         // Attempt to upload the file
//         UploadFileResponseModel response =
//             await ApiServices.uploadFile(files: file, fields: fields);

//         // Check if response contains valid data
//         if (response.data != null) {
//           String imagePath = response.data?.file ?? "";
//           imagePathShow.value = imagePath;
//           imageList.insert(0, FileElement(file: imagePath));
//         } else {
//           // Handle case where response doesn't contain expected data
//           print("Upload successful but no file data returned");
//           throw Exception("No file data in response");
//         }
//       } catch (uploadError) {
//         // Log the error for debugging
//         print("Error during file upload process: $uploadError");

//         // Handle the error appropriately
//         Future.delayed(Duration(milliseconds: 100), () {
//           Get.snackbar(
//             "Upload Failed",
//             "Unable to upload image facing Some issues. Please try again later.",
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: AppColors.red176,
//             colorText: AppColors.white,
//           );
//         });

//         isUploading.value = false;
//         return;
//       }
//     }

//     // Clear loading state
//     isUploading.value = false;
//     Get.back();
//   } catch (e) {
//     // Handle any unexpected errors
//     print("Unexpected error in uploadPhoto: $e");
//     isUploading.value = false;

//     // Show error message
//     Get.snackbar(
//       "Error",
//       "An unexpected error occurred. Please try again.",
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: AppColors.red176,
//       colorText: AppColors.white,
//     );
//   }
// }

//  Custom cropper dialog with guaranteed bottom controls
// Future<Uint8List?> showCustomCropperDialog({
//   required BuildContext context,
//   required Uint8List imageBytes,
//   CropAspectRatio? aspectRatio,
// }) async {
//   final CropController cropController = CropController();
//   Uint8List? croppedImage;
//   bool isProcessing = false;

//   return showDialog<Uint8List?>(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext dialogContext) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return Dialog.fullscreen(
//             child: Scaffold(
//               backgroundColor: Colors.black,
//               body: Column(
//                 children: [
//                   // Top instruction bar
//                   Container(
//                     color: Colors.black87,
//                     padding: EdgeInsets.only(
//                       top: MediaQuery.of(context).padding.top + 10,
//                       bottom: 10,
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Adjust crop area and tap ✓ below',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Crop widget takes up most of the screen
//                   Expanded(
//                     child: Container(
//                       color: Colors.black,
//                       child: Crop(
//                         image: imageBytes,
//                         controller: cropController,
//                         onCropped: (croppedData) {
//                           // croppedData is CropResult, extract the Uint8List
//                           final Uint8List imageBytes = croppedData.croppedImage;
//                           setState(() {
//                             croppedImage = imageBytes;
//                             isProcessing = false;
//                           });
//                           Navigator.of(dialogContext).pop(imageBytes);
//                         },
//                         aspectRatio: aspectRatio?.ratioX != null && aspectRatio?.ratioY != null
//                             ? aspectRatio!.ratioX / aspectRatio!.ratioY
//                             : null,
//                         // Removed initialSize as it's not a valid parameter
//                         withCircleUi: false,
//                         baseColor: Colors.blue.shade900,
//                         maskColor: Colors.white.withAlpha(100),
//                         radius: 0,
//                         fixCropRect: true,
//                         interactive: true,
//                       ),
//                     ),
//                   ),

//                   // Bottom control buttons - GUARANTEED to be at bottom
//                   Container(
//                     color: Colors.black87,
//                     padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
//                     child: SafeArea(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           // Cancel button
//                           GestureDetector(
//                             onTap: isProcessing ? null : () {
//                               Navigator.of(dialogContext).pop(null);
//                             },
//                             child: Container(
//                               padding: EdgeInsets.all(20),
//                               decoration: BoxDecoration(
//                                 color: isProcessing ? Colors.grey : Colors.red,
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.3),
//                                     blurRadius: 10,
//                                     offset: Offset(0, 3),
//                                   ),
//                                 ],
//                               ),
//                               child: Icon(
//                                 Icons.close,
//                                 color: Colors.white,
//                                 size: 35,
//                               ),
//                             ),
//                           ),

//                           // Confirm button (tick mark) - THIS WILL BE AT THE BOTTOM!
//                           GestureDetector(
//                             onTap: isProcessing ? null : () {
//                               setState(() {
//                                 isProcessing = true;
//                               });
//                               cropController.crop();
//                             },
//                             child: Container(
//                               padding: EdgeInsets.all(20),
//                               decoration: BoxDecoration(
//                                 color: isProcessing ? Colors.grey : Colors.green,
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.3),
//                                     blurRadius: 10,
//                                     offset: Offset(0, 3),
//                                   ),
//                                 ],
//                               ),
//                               child: isProcessing
//                                   ? SizedBox(
//                                       width: 35,
//                                       height: 35,
//                                       child: CircularProgressIndicator(
//                                         color: Colors.white,
//                                         strokeWidth: 4,
//                                       ),
//                                     )
//                                   : Icon(
//                                       Icons.check,
//                                       color: Colors.white,
//                                       size: 35,
//                                     ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }

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
