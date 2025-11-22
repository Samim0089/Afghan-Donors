class Profile {
  final String name;
  final String phonenumber;
  final String bloodgroup;
  final String location;

  Profile({
    required this.name,
    required this.phonenumber,
    required this.bloodgroup,
    required this.location,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
      bloodgroup: json['bloodgroup'] ?? '',
      location: json['location'] ?? '',
    );
  }
}
