
class PetLover{
   String firstName;
   String lastName;
   String uid;
   String email;
   String password;
   String phoneNum;
   String? img ;
   String city;
   String birthDate;
   bool isValidForRegistration;

  factory PetLover.empty() {
    return PetLover( "", "", "","", "", "", "", "", "",false);
  }

   factory PetLover.fromSnapshot(Map<String, dynamic> data) {
     return PetLover(
         data['first name'],data['last name'], data['uid'], data['email'], '',
         data['phone number'], data['photoUrl'], data['city'],data['birth date'], true
     );
   }

  PetLover(
     this.firstName,
     this.lastName,
     this.uid,
     this.email,
     this.password,
     this.phoneNum,
     this.img,
     this.city,
     this.birthDate,
      this.isValidForRegistration
  );
  PetLover copyWith({
        String? firstName,
        String? lastName,
        String? email,
        String? password,
        String? phoneNum,
        String? img ,
        String? city,
        String? birthDate,
       required isValid}) {
    return PetLover(
        firstName ?? this.firstName,
        lastName ?? this.lastName,
        uid  ,
        email ?? this.email,
        password ?? this.password,
        phoneNum ?? this.phoneNum,
        img ?? this.img,
        city ?? this.city,
        birthDate ?? this.birthDate,
        isValid);
  }
}

