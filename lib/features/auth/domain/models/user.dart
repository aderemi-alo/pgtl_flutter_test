class User {
  String? id;
  String? email;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.createdAt,
    this.updatedAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => User(
    id: id ?? this.id,
    email: email ?? this.email,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory User.fromJson(Map<String, dynamic>? json) => User(
    id: json?["id"],
    email: json?["email"],
    phoneNumber: json?["phoneNumber"],
    firstName: json?["firstName"],
    lastName: json?["lastName"],
    createdAt:
        json?["createdAt"] == null
            ? null
            : DateTime.tryParse(json?["createdAt"]),
    updatedAt:
        json?["updatedAt"] == null
            ? null
            : DateTime.tryParse(json?["updatedAt"]),
  );

  Map<String, dynamic>? toJson() => {
    "id": id,
    "email": email,
    "phoneNumber": phoneNumber,
    "firstName": firstName,
    "lastName": lastName,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
