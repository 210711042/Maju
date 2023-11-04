import 'dart:typed_data';

class Users {
  final int? id;
  String? username, email, password, address, phone;
  // DateTime? birth;
  Uint8List? profile_image;

  Users(
      {this.id,
      this.username,
      this.email,
      this.password,
      this.address,
      this.phone,
      this.profile_image});
}
