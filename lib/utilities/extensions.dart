extension StringValidation on String {
  /// ✅ Email Validation
  bool get isValidEmail {
    final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(this);
  }

  /// ✅ Phone Number Validation (Only 10 Digits)
  bool get isValidPhoneNumber {
    final RegExp phoneRegex = RegExp(r"^[0-9]{10}$");
    return phoneRegex.hasMatch(this);
  }

  /// ✅ Name Validation (First & Last Name, No Spaces at Start/End, No Special Characters)
  bool get isValidName {
    final RegExp nameRegex = RegExp(r"^(?! )[A-Za-z]+( [A-Za-z]+)*(?<! )$");
    return nameRegex.hasMatch(this);
  }

  /// ✅ Password Validation (Min 8 chars, 1 letter, 1 number, 1 special char)
  bool get isValidPassword {
    final RegExp passwordRegex =
    RegExp(r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$");
    return passwordRegex.hasMatch(this);
  }
  bool get isValidWebsite {
    final RegExp websiteRegex = RegExp(
        r"^(?!.*\d{3,})(?!.*[!@#$%^&*()_+=-]{2,})[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$"
    );
    return websiteRegex.hasMatch(this);
  }


}
