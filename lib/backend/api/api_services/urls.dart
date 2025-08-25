class WebSocketUrl {
  static String base = "wss://api.waiverapp.in";
  static String liveLocation = "/ws/live-location/?";
}

class AppUrls {
  // static String base = "waiver-api.ajmalk.com";
  // static String base = "165.22.221.172";
  static String base = "api.waiverapp.in";
  // static String base = "165.22.221.172:8000";

  static String baseUrlForImage = "https://waiver-api.ajmalk.com";
  static String googleLocationUrl =
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=";
  static String googleApiKeyUrl =
      "&key=AIzaSyC1x7klS50K1WXb6p8D7BcbqkCKm2wrrYU";
  static String sendPhoneOtp = "/api/v1/core/send-phone-otp/";
  static String rideOrderDetails = "/api/v1/ride/ride-details/";
  static String phoneAuth = "/api/v1/core/phone-auth/";
  static String driverProfile = "/api/v1/fleet/driver-profile/";
  // static String createProfile = "/api/v1/core/profile/";
  static String createProfile = "/api/v2/profile/";
  static String onlineStatus = "api/v2/core/change-online-status/";
  static String states = "/api/v1/core/states/";
  static String districts = "/api/v1/core/state-districts/";
  static String workLocations = "/api/v1/core/work-locations/";
  static String workExperience = "/api/v1/core/work-experience/";
  static String vehicleTypes = "api/v1/core/vehicle-types/";
  static String transmissionTypes = "/api/v1/core/transmission-types/";
  static String document = "/api/v1/core/document/";
  static String vehicleProof = "/api/v1/fleet/vehicle-proof/";
  static String vehicleDriver = "api/v1/fleet/vehicle-driver/";
  static String profileImage = "/api/v1/core/profile-image/";
  static String bankAccount = "/api/v1/core/bank-account/";
  static String banks = "/api/v1/core/banks/";
  // static String profile = "/api/v1/core/profile/";
  static String profile = "/api/v2/profile/";
  static String profilePhoto = "/api/v1/core/document/";
  static String savePreference = "/api/v1/core/save-preference/";
  static String logout = "/api/v1/core/logout/";
  static String deleteAccount = "/api/v1/core/delete-account/";
  static String uploadFile = "/api/v1/core/upload-file/";
  static String documentRejectionResponse =
      "/api/v1/core/document-rejection-response/";

  static String earningStatus = "/api/v1/home/earnings-stat";
  static String vehicles = "/api/v1/fleet/vehicles/";
  static String vehicle = "/api/v1/fleet/vehicle/";
  static String addVehicles = "/api/v1/fleet/add-vehicle/";
  static String blockVehicle = "/api/v1/fleet/block-vehicle/";

  static String reviewsStatus = "/api/v1/home/reviews-stat/";
  static String verifyRideOtp = "/api/v1/ride/verify-ride-otp/";
  static String reviews = "/api/v1/home/reviews/";
  static String rides = "/api/v1/home/rides/";
  static String rideDetails = "/api/v1/home/ride-details/";
  static String notifications = "/api/v1/home/notifications/";
  static String helpCategories = "/api/v1/home/help-categories/";
  static String faqs = "/api/v1/home/faqs/";
  static String earnings = "/api/v1/home/earnings/";
  static String latestActiveRide = "/api/v1/ride/latest-active-ride/";
  static String changeRideStatus = "/api/v2/change-ride-status/";
  static String rideCancelReasons = "/api/v1/ride/ride-cancel-reasons/";
  static String paymentType = "/api/v1/ride/payment-type/";
  static String getRidePayment = "/api/v1/ride/ride-payment/";
  static String addStop = "/api/v1/ride/add-ride-stop/";
  static String walletbalance = "/api/v1/ride/partner-wallet/";
  static String paymentCreateOrder = "/api/v2/payment-to-waiver/order/";
  static String paymentSuccess = "/api/v2/payment-to-waiver/success/";
}
