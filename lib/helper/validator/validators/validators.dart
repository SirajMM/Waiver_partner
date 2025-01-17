///All validation function used in the app must be declared here and here only

class Validators {
  //check is the given string is empty or not
  static String? isEmpty({required String? value, String? errorText}) {
    if ((value ?? "").isEmpty) {
      return errorText ?? "This field is required";
    } else {
      return null;
    }
  }

  static String? isSameAs(
      {required String? value,
      required String? confirmText,
      String? errorText}) {
    print(value);
    print(confirmText);
    if ((value ?? "").isEmpty) {
      return "This field is required";
    } else if (value != confirmText) {
      return errorText ?? "Both field has to be same";
    } else {
      return null;
    }
  }

  static String? vehicleNumber({required String? value, String? errorText}) {
    print(value);
    if ((value ?? "").isEmpty) {
      return errorText ?? "This field is required";
    } else if (!(RegExp(r'^[A-Z]{2}[0-9]{1,2}(?: [A-Z])?(?:[A-Z]*)?[0-9]{4}$')
        .hasMatch((value ?? "").toUpperCase()))) {
      return "Please enter a valid vehicle registration number";
    } else {
      return null;
    }
  }

  static String? isEMail({required String? value}) {
    if ((value ?? "").isEmpty) {
      return "This field is required";
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch((value ?? ""))) {
      return "Please enter a valid email";
    } else {
      return null;
    }
  }

  static String? isBankAccountNumber({required String? value}) {
    if ((value ?? "").isEmpty) {
      return "This field is required";
    } else if (!RegExp(r"^\d{9,18}$").hasMatch((value ?? ""))) {
      return "Please enter a valid Account Number";
    } else {
      return null;
    }
  }

  static String? isBankISFCNumber({required String? value}) {
    if ((value ?? "").isEmpty) {
      return "This field is required";
    } else if (!RegExp(r"^[A-Za-z]{4}[a-zA-Z0-9]{7}$")
        .hasMatch((value ?? ""))) {
      return "Please enter a valid IFSC number";
    } else {
      return null;
    }
  }

  static String? isMobile(
      {required String? value, int? minLength, int? maxLength}) {
    if ((value ?? "").isEmpty) {
      return "This field is required";
    } else if ((value ?? "").length > (maxLength ?? 10)) {
      return "Please enter a valid mobile number";
    } else if ((value ?? "").length < (minLength ?? 10)) {
      return "Please enter a valid mobile number";
    } else {
      return null;
    }
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) return 'Please enter a new password';
    if (!value.contains(RegExp(r'[a-z]'))) {
      return "Password should contain at least 1 lower case letter";
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return "Password should contain at least 1 upper case letter";
    }
    if (!value.contains(RegExp(r'[!@#\$&*~]'))) {
      return "Password should contain at least 1 special character";
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return "Password should contain at least 1 number";
    }
    if (value.length <= 8) {
      return "Password should contain at least 8 character";
    }
    return null;
  }
}
