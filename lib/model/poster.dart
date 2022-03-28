class Poster {
  String id;
  String name;
  String phoneNum;
  String? img;
  String? description;
  String? website;
  String? city;

  factory Poster.fromPLSnapshot(Map<String, dynamic> data) {
    return Poster(
        data['uid'],
        data['first name']+' '+data['last name'],
        data['phone number'],
        data['photoUrl'],
    );
  }

  factory Poster.fromOrgSnapshot(Map<String, dynamic> data) {
    return Poster(
      data['uid'],
      data['name'],
      data['phone'],
      data['photoUrl'],
      description:  data['description'],
      website:  data['website'],
      city:  data['city'],
    );
  }
  Poster(this.id, this.name, this.phoneNum, this.img, {this.description, this.website, this.city});
}