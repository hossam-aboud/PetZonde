class orgRegisterState {
  final bool? isEmailValid;
  final bool? isPasswordValid;
  final bool? isPasswordConfirmValid;
  final bool? isPhoneValid;
  final bool? isSubmitting;
  final bool? isSuccess;
  final bool? isFailure;
  final String? photoPath;

  bool? get isFormValid => isEmailValid! && isPasswordValid! && isPasswordConfirmValid! && isPhoneValid!;

  orgRegisterState(
      {this.isEmailValid,
        this.isPasswordValid,
        this.isPasswordConfirmValid,
        this.isPhoneValid,
        this.isSubmitting,
        this.isSuccess,
        this.isFailure,
        this.photoPath
      });

  factory orgRegisterState.initial() {
    return orgRegisterState(
        isEmailValid: true,
        isPasswordValid: true,
        isPasswordConfirmValid: true,
        isPhoneValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false
    );
  }

  factory orgRegisterState.loading() {
    return orgRegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmValid: true,
      isPhoneValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory orgRegisterState.failure() {
    return orgRegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmValid: true,
      isPhoneValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory orgRegisterState.success() {
    return orgRegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmValid: true,
      isPhoneValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  orgRegisterState update({
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isPasswordConfirmValid,
    bool? isPhoneValid,
    String? photoPath
  }) {
    return copyWith(
        isEmailValid: isEmailValid,
        isPasswordValid: isPasswordValid,
        isPasswordConfirmValid: isPasswordConfirmValid,
        isPhoneValid: isPhoneValid,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false,
        photoPath: photoPath
    );
  }

  orgRegisterState copyWith({
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isPasswordConfirmValid,
    bool? isPhoneValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? photoPath,
  }) {
    return orgRegisterState(
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isPasswordConfirmValid: isPasswordConfirmValid ?? this.isPasswordConfirmValid,
        isPhoneValid: isPhoneValid ?? this.isPhoneValid,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        photoPath: photoPath ?? this.photoPath
    );
  }
}