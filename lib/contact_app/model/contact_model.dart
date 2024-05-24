import 'package:objectbox/objectbox.dart';

@Entity()
// @JsonSerializable()
class ContactModel {
  @Id()
  int id;
  String name;
  String email;
  String number;
  ContactModel({
    this.id = 0,
    required this.name,
    required this.number,
    required this.email,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      name: json["name"],
      number: json["number"],
      email: json["email"],
    );
  }
}
