import 'dart:convert';

    Login loginFromJson(String str) => Login.fromJson(json.decode(str));
class Login {
    int id;
    String email;
    String name;
    String role;
    String refreshToken;
    DateTime createdAt;
    DateTime updatedAt;
    String accessToken;

    Login({
        required this.id,
        required this.email,
        required this.name,
        required this.role,
        required this.refreshToken,
        required this.createdAt,
        required this.updatedAt,
        required this.accessToken,
    });


    factory Login.fromJson(Map<String, dynamic> json) => Login(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        role: json["role"],
        refreshToken: json["refresh_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        accessToken: json["access_token"],
    );

}
