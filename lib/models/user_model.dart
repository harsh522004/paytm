// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id;
  final String username;
  final String firstname;
  final String lastname;
  final String password;

  UserModel(
      {required this.id,
      required this.username,
      required this.firstname,
      required this.lastname,
      required this.password});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] as String,
      username: map['username'] as String,
      firstname: map['firstname'] as String,
      lastname: map['lastname'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AccountModel {
  final String id;
  final String userId;
  final double balance;

  AccountModel({required this.id, required this.userId, required this.balance});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'balance': balance,
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map['_id'] as String,
      userId: map['userId'] as String,
      balance: map['balance'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountModel.fromJson(String source) =>
      AccountModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
