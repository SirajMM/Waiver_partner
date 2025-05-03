import 'dart:ui';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '../../main.dart';
import '../colors/app_colors.dart';

class BoxKeys {
  static String userType = "userType";
  static String userTypeCode = "userTypeCode";
  static String token = "token";
  static String userName = "userName";
  static String userID = "userID";
  static String userImage = "userImage";
  static String deviceId = "deviceId";
  static String baseUrl = "baseUrl";
  static String rideId = "rideId";
  static String baseUrlImage = "baseUrlImage";
  static String isVerified = "isVerified";
  static String isRegistered = "isRegistered";
  static String darkMode = "0";
  static String paymentType = "paymentType";
  static String lastLocation = "lastLocation";
  static String  buildNumber = "buildNumber";
  static String  version = "version";
  static String  isTaken = "isAssinged";
}

class UserType {
  static String chauffeur = "chauffeur";
  static String fleet = "fleet";
  static String driver = "driver";
}

class UserTypeCode {
  static String chauffeur = "CHR";
  static String fleet = "FTR";
  static String driver = "DVR";
}

class ChauffeurProofApprovalType {
  static String notUpload = "notUpload";
  static String waitingForApproval = "PDG";
  static String approved = "ACE";
  static String rejected = "RJD";
}

class DocumentType {
  static String aadhar = "ADR";
  static String profilePhoto = "PPO";
  static String license = "LCS";
  static String policeClearanceCertificate = "CLS";
  static String registrationCerifcatre = "RJS";
  static String vehicleInsuracne = "VIS";
  static String vechilePemit = "VPS";
  static String vechileImage = "VIM";
  static String none = "none";
}

class NotificationType {
  static String payment = "PYT";
  static String cashBack = "CBT";
  static String discount = "DST";
}

class EarningType {
  static String payment = "RFE";
  static String ride = "ITE";
}

class VehicleApprovalStatus {
  static String active = "ACE";
  static String pending = "PDG";
  static String blocked = "BCD";
}

enum ShowTimerState { timer, text, loading }

class RideStatus {
  static String requested = "RED";
  static String accepted = "ACD";
  static String cancelled = "CAD";
  static String onGoing = "ONG";
  static String completed = "COD";
  static String paused = "PSD";
  static String resumed = "RSD";
  static String reachedPickUp = "RDP";
  static String reachedDropOff = "RDF";
  static String paymentInitiated = "PID";
  static String paymentCompleted = "PCD";
}

class RiderStatus {
  static String save = "save";
  static String ride = "ride";
}

class AppConstants {
  static LocationData? locationData;
  static Position? currentPosition;

  static Color getColor() {
    String user = box.read(BoxKeys.userTypeCode);
    if (user == UserTypeCode.driver) {
      return AppColors.orange;
    } else if (user == UserTypeCode.chauffeur) {
      return AppColors.blue;
    } else {
      return AppColors.yellow;
    }
  }

  static Color getButtonTextColor() {
    String user = box.read(BoxKeys.userTypeCode);
    if (user == UserTypeCode.fleet) {
      return AppColors.black;
    } else {
      return AppColors.white;
    }
  }
}
