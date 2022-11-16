import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel {
  @JsonKey(name: 'userId', defaultValue: 0)
  final int? userId;
  @JsonKey(name: 'id', defaultValue: 0)
  final int? id;
  @JsonKey(name: 'title', defaultValue: '')
  final String? title;

  LoginModel({
    this.userId,
    this.id,
    this.title,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);

  @override
  LoginModel fromJson(Map<String, dynamic> json) {
    return LoginModel.fromJson(json);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
