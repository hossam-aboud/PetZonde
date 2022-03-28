abstract class User {
  String  uid;
String name;
String? photo;
String email;
String phone;

User({required this.uid,
  required this.name,
  this.photo,
  required this.email,
  required this.phone,});
}

class Vet extends User {

 String experience;
 String degree;
 String  specialty;

 Vet({required String uid,
   required String name,
  String? photo,
   required String email,
   required String phone,
   required this.experience,
   required this.degree,
   required this.specialty}) :
       super(uid: uid, name: name, email: email, phone: phone, photo: photo);


}

class Org extends User {
  String description;
  String location;
  String website, license;

  Org({required String uid,
    required String name,
    String? photo,
    required String email,
    required String phone,
    required this.location,
    required this.description,
    required this.website,
    required this.license,
  }) :
        super(uid: uid, name: name, email: email, phone: phone, photo: photo);

}