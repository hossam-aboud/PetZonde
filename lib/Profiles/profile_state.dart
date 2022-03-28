import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {

  final bool? isSubmitting;
  final bool? isSuccess;
  final bool? isFailure;
 // final String? photoPath;

  ProfileState(
      {
        this.isSubmitting,
        this.isSuccess,
        this.isFailure,
      });

  factory ProfileState.initial() {
    return ProfileState(
        isSubmitting: false,
        isSuccess: false,
        isFailure: false
    );
  }

  factory ProfileState.loading() {
    return ProfileState(
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory ProfileState.failure() {
    return ProfileState(

      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory ProfileState.success() {
    return ProfileState(

      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  // ProfileState update({
  //   bool? isEmailValid,
  //   bool? isPasswordValid,
  //   bool? isPasswordConfirmValid,
  //   bool? isPhoneValid,
  //   String? photoPath
  // }) {
  //   return copyWith(
  //       isEmailValid: isEmailValid,
  //       isPasswordValid: isPasswordValid,
  //       isPasswordConfirmValid: isPasswordConfirmValid,
  //       isPhoneValid: isPhoneValid,
  //       isSubmitting: false,
  //       isSuccess: false,
  //       isFailure: false,
  //       photoPath: photoPath
  //   );
  // }

  ProfileState copyWith({

    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
  }) {
    return ProfileState(
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
    );
  }


  List<Object?> get props => [];
}

