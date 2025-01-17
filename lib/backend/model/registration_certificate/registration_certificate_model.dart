import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:waiver_driver/backend/model/chauffeur_proof/chauffeur_proof_model.dart';

import 'package:waiver_driver/core/constants/enums/enums.dart';



class ProofModel {
  String text;
  String subText;

  RxList<FileElement> images;
  Rx<ApprovalStatus> status;
  String type;
  bool? isProfile;
  CropAspectRatio? aspectRatio;
  int? maxPhotos;
  String? vehicleID;
  Rejection? rejection;

  ProofModel({
    required this.text,
    required this.subText,
    required this.images,
    required this.status,
    required this.type,
    this.isProfile,
    this.maxPhotos,
    this.vehicleID,
    this.rejection,
    this.aspectRatio,
  });
}
