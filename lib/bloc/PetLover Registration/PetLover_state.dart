
class PetLoverState {
  final bool? isEmailValid;
  final bool? isPasswordValid;
  final bool? isPasswordConfirmValid;
  final bool? isPhoneValid;
  final bool? isSubmitting;
  final bool? isSuccess;
  final bool? isFailure;
  final String? photoPath;

  bool? get isFormValid => isEmailValid! && isPasswordValid!;

  PetLoverState(
      {this.isEmailValid,
        this.isPasswordValid,
        this.isPasswordConfirmValid,
        this.isPhoneValid,
        this.isSubmitting,
        this.isSuccess,
        this.isFailure,
        this.photoPath
      });

  factory PetLoverState.initial() {
    return PetLoverState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmValid: true,
      isPhoneValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory PetLoverState.loading() {
    return PetLoverState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmValid: true,
      isPhoneValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory PetLoverState.failure() {
    return PetLoverState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmValid: true,
      isPhoneValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory PetLoverState.success() {
    return PetLoverState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmValid: true,
      isPhoneValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  PetLoverState update({
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isPasswordConfirmValid,
    bool? isPhoneValid,
    String? photoPath
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
        isPasswordConfirmValid:isPasswordConfirmValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
        photoPath: photoPath
    );
  }

  PetLoverState copyWith({
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isPasswordConfirmValid,
    bool? isPhoneValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? photoPath,
  }) {
    return PetLoverState(
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

