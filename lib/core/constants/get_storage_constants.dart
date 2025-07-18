import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart'
    show AppSnackBar;

import '../../helper/router/app_routes/route.dart';
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
  static String buildNumber = "buildNumber";
  static String version = "version";
  static String isTaken = "isAssinged";
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
  static String favRideRequested = "FRED";
  static String favRideCancelled = "FCAD";
}

class RiderStatus {
  static String save = "save";
  static String ride = "ride";
}

class AppConstants {
  static LocationData? locationData;
  static Position? currentPosition;

  static Color getColor() {
    String user = box.read(BoxKeys.userTypeCode)??'none';
    if (user == UserTypeCode.driver) {
      return AppColors.orange;
    } else if (user == UserTypeCode.chauffeur) {
      return AppColors.blue;
    } else if(user == UserTypeCode.fleet) {
      return AppColors.yellow;
    } else{
        return AppColors.blue;
    }
  }

  static Color getButtonTextColor() {
    String user = box.read(BoxKeys.userTypeCode)??"none";
    if (user == UserTypeCode.fleet) {
      return AppColors.black;
    } else if(user == UserTypeCode.chauffeur|| user == UserTypeCode.driver) {
      return AppColors.white;
    }else {
      return AppColors.white;
    }
  }

  static String formatSecondsToHrAndMin(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    // int seconds = totalSeconds % 60;

    return '${hours}h ${minutes}m';
  }

  static String formatSecondsToHrAndMinForDouble(double totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    // int seconds = totalSeconds % 60;

    return '${hours}h ${minutes}m';
  }

  static String metersToKilometersFormatted(double meters) {
    double kilometers = meters / 1000;
    return '${kilometers.toStringAsFixed(2)} km';
  }

  static void handleError(Object e, {StackTrace? s}) {
    log('Error: $e ', error: e, stackTrace: s);
    String errorMessage;
    if (e is SocketException) {
      errorMessage = 'Network error: ${e.message}';
    } else if (e is HttpException) {
      try {
        final error = jsonDecode(e.message);
        if (error['code'] == "authentication_failed") {
          Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
          box.erase();

          Get.showSnackbar(GetSnackBar(
              duration: Duration(seconds: 5),
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.zero,
              messageText: AppSnackBar(
                  text: 'You\'r session has expired. Please Re-login')));
          return;
        }
        errorMessage = error['message'] ??
            (error['messages'] is List && error['messages'].isNotEmpty
                ? error['messages'][0]['message']
                : null) ??
            'Something went wrong';
      } catch (_) {
        errorMessage = 'Something went wrong';
      }
    } else if (e is TimeoutException) {
      errorMessage = 'Request timed out. Please try again.';
    } else if (e is ClientException) {
      errorMessage = 'Connection failed: ${e.message}';
    } else if (e is FormatException) {
      errorMessage = e.message;
    } else if (e is Exception) {
      String fullError = e.toString();
      errorMessage = fullError.startsWith('Exception: ')
          ? fullError.substring('Exception: '.length)
          : fullError;
    } else if (e is Error) {
      errorMessage = e.toString();
    } else {
      errorMessage = e.toString();
    }

    if (errorMessage.isEmpty ||
        errorMessage == 'Exception' ||
        errorMessage == e.runtimeType.toString()) {
      errorMessage = 'An unexpected error occurred. Please try again.';
    }

    Get.showSnackbar(GetSnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        messageText: AppSnackBar(text: errorMessage)));
  }
}
