import 'package:equatable/equatable.dart';

enum MediaUploadState { uploading, uploaded, failed }

class MediaDraft extends Equatable {
  const MediaDraft({
    required this.id,
    required this.localPath,
    required this.position,
    this.uploadState = MediaUploadState.uploading,
    this.progress = 0,
    this.storagePath,
    this.publicUrl,
    this.widthPx,
    this.heightPx,
    this.mimeType,
    this.byteSize,
  });

  final String id;
  final String localPath;
  final int position;
  final MediaUploadState uploadState;
  final double progress;
  final String? storagePath;
  final String? publicUrl;
  final int? widthPx;
  final int? heightPx;
  final String? mimeType;
  final int? byteSize;

  bool get isUploaded => uploadState == MediaUploadState.uploaded;

  MediaDraft copyWith({
    String? id,
    String? localPath,
    int? position,
    MediaUploadState? uploadState,
    double? progress,
    String? storagePath,
    String? publicUrl,
    int? widthPx,
    int? heightPx,
    String? mimeType,
    int? byteSize,
  }) =>
      MediaDraft(
        id: id ?? this.id,
        localPath: localPath ?? this.localPath,
        position: position ?? this.position,
        uploadState: uploadState ?? this.uploadState,
        progress: progress ?? this.progress,
        storagePath: storagePath ?? this.storagePath,
        publicUrl: publicUrl ?? this.publicUrl,
        widthPx: widthPx ?? this.widthPx,
        heightPx: heightPx ?? this.heightPx,
        mimeType: mimeType ?? this.mimeType,
        byteSize: byteSize ?? this.byteSize,
      );

  @override
  List<Object?> get props => [
        id,
        localPath,
        position,
        uploadState,
        progress,
        storagePath,
        publicUrl,
        widthPx,
        heightPx,
        mimeType,
        byteSize,
      ];
}
