// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signed_upload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignedUpload _$SignedUploadFromJson(Map<String, dynamic> json) => SignedUpload(
  bucket: json['bucket'] as String,
  path: json['path'] as String,
  token: json['token'] as String,
  signedUrl: json['signed_url'] as String,
  publicUrl: json['public_url'] as String,
);

Map<String, dynamic> _$SignedUploadToJson(SignedUpload instance) =>
    <String, dynamic>{
      'bucket': instance.bucket,
      'path': instance.path,
      'token': instance.token,
      'signed_url': instance.signedUrl,
      'public_url': instance.publicUrl,
    };
