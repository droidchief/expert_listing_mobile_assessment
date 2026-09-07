import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'signed_upload.g.dart';

@JsonSerializable()
class SignedUpload extends Equatable {
  const SignedUpload({
    required this.bucket,
    required this.path,
    required this.token,
    required this.signedUrl,
    required this.publicUrl,
  });

  factory SignedUpload.fromJson(Map<String, dynamic> json) =>
      _$SignedUploadFromJson(json);

  final String bucket;
  final String path;
  final String token;
  final String signedUrl;
  final String publicUrl;

  Map<String, dynamic> toJson() => _$SignedUploadToJson(this);

  @override
  List<Object?> get props => [bucket, path, token, signedUrl, publicUrl];
}
