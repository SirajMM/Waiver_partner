import 'package:get/get.dart';
import 'package:waiver_driver/controller/chauffeur_proof/chauffeur_proof_controller.dart';

class ChauffeurProof_Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChauffeurProofController(parser: Get.find()));
  }
}