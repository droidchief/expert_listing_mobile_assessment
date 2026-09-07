import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../../core/error/failure.dart';
import '../../data/composer_repository.dart';
import '../../data/upload_repository.dart';
import '../../domain/location_option.dart';
import '../../domain/media_draft.dart';
import 'composer_state.dart';

class ComposerCubit extends Cubit<ComposerState> {
  ComposerCubit({
    required ComposerRepository repository,
    required UploadRepository uploadRepository,
  })  : _repository = repository,
        _uploadRepository = uploadRepository,
        super(const ComposerState());

  final ComposerRepository _repository;
  final UploadRepository _uploadRepository;

  static const int _longestEdge = 1600;
  static const int _quality = 80;

  void setPostType(String postType) {
    final Set<String> validTransactions = switch (postType) {
      'property' => ComposerState.propertyTransactionTypes,
      'request' => ComposerState.requestTransactionTypes,
      _ => const {},
    };
    final bool keepsTransaction =
        validTransactions.contains(state.transactionType);

    emit(state.copyWith(
      postType: postType,
      clearTransactionType: !keepsTransaction,
      // Property details only apply to `property` posts.
      clearPriceAmount: postType != 'property',
      clearPricePeriod: postType != 'property',
      clearBedrooms: postType != 'property',
      clearBathrooms: postType != 'property',
      clearParkingSpaces: postType != 'property',
    ));
  }

  void setBody(String body) => emit(state.copyWith(body: body));

  void setTransactionType(String value) =>
      emit(state.copyWith(transactionType: value));

  void setLocation(LocationOption location) =>
      emit(state.copyWith(location: location));

  void clearLocation() => emit(state.copyWith(clearLocation: true));

  void setPriceAmount(num? value) => emit(
        value == null
            ? state.copyWith(clearPriceAmount: true)
            : state.copyWith(priceAmount: value),
      );

  void setPricePeriod(String? value) => emit(
        value == null
            ? state.copyWith(clearPricePeriod: true)
            : state.copyWith(pricePeriod: value),
      );

  void setBedrooms(int? value) => emit(
        value == null
            ? state.copyWith(clearBedrooms: true)
            : state.copyWith(bedrooms: value),
      );

  void setBathrooms(int? value) => emit(
        value == null
            ? state.copyWith(clearBathrooms: true)
            : state.copyWith(bathrooms: value),
      );

  void setParkingSpaces(int? value) => emit(
        value == null
            ? state.copyWith(clearParkingSpaces: true)
            : state.copyWith(parkingSpaces: value),
      );

  /// Compresses and uploads immediately — by the time the user taps Post,
  /// the bytes are already in Storage.
  Future<void> addImage(String localPath) async {
    if (state.media.length >= ComposerState.maxMedia) return;

    final String id = _generateId();
    final draft = MediaDraft(
      id: id,
      localPath: localPath,
      position: state.media.length,
    );
    emit(state.copyWith(media: [...state.media, draft]));
    await _upload(id, localPath);
  }

  void removeImage(String id) {
    final List<MediaDraft> remaining =
        state.media.where((m) => m.id != id).toList();
    final List<MediaDraft> reindexed = [
      for (var i = 0; i < remaining.length; i++)
        remaining[i].copyWith(position: i),
    ];
    emit(state.copyWith(media: reindexed));
  }

  Future<void> retryUpload(String id) async {
    final int index = state.media.indexWhere((m) => m.id == id);
    if (index == -1) return;
    final MediaDraft draft = state.media[index];
    _updateMedia(id, (m) => m.copyWith(uploadState: MediaUploadState.uploading));
    await _upload(id, draft.localPath);
  }

  Future<void> _upload(String id, String localPath) async {
    try {
      final Uint8List originalBytes = await File(localPath).readAsBytes();
      final (int originalWidth, int originalHeight) =
          await _decodeDimensions(originalBytes);
      final (int targetWidth, int targetHeight) =
          _targetDimensions(originalWidth, originalHeight);

      final Uint8List compressed = await FlutterImageCompress.compressWithList(
        originalBytes,
        minWidth: targetWidth,
        minHeight: targetHeight,
        quality: _quality,
        format: CompressFormat.webp,
      );

      final (int finalWidth, int finalHeight) =
          await _decodeDimensions(compressed);

      final signed = await _uploadRepository.signUpload(
        bucket: 'post-media',
        contentType: 'image/webp',
        byteSize: compressed.length,
      );

      await _uploadRepository.uploadBytes(
        signedUrl: signed.signedUrl,
        bytes: compressed,
        contentType: 'image/webp',
        onProgress: (sent, total) {
          if (total <= 0) return;
          _updateMedia(id, (m) => m.copyWith(progress: sent / total));
        },
      );

      _updateMedia(
        id,
        (m) => m.copyWith(
          uploadState: MediaUploadState.uploaded,
          progress: 1,
          storagePath: signed.path,
          publicUrl: signed.publicUrl,
          widthPx: finalWidth,
          heightPx: finalHeight,
          mimeType: 'image/webp',
          byteSize: compressed.length,
        ),
      );
    } catch (_) {
      _updateMedia(id, (m) => m.copyWith(uploadState: MediaUploadState.failed));
    }
  }

  void _updateMedia(String id, MediaDraft Function(MediaDraft) update) {
    final List<MediaDraft> media = [
      for (final m in state.media)
        if (m.id == id) update(m) else m,
    ];
    emit(state.copyWith(media: media));
  }

  Future<void> submit() async {
    if (!state.isValid || state.status == ComposerStatus.submitting) return;
    emit(state.copyWith(status: ComposerStatus.submitting, clearFailure: true));
    try {
      final String id = await _repository.createPost(
        postType: state.postType,
        body: state.body.trim(),
        transactionType: state.transactionType,
        locationId: state.location?.id,
        priceAmount: state.priceAmount,
        pricePeriod: state.pricePeriod,
        bedrooms: state.bedrooms,
        bathrooms: state.bathrooms,
        parkingSpaces: state.parkingSpaces,
        media: state.media,
      );
      emit(state.copyWith(status: ComposerStatus.success, createdPostId: id));
    } on Failure catch (f) {

      emit(state.copyWith(status: ComposerStatus.failure, failure: f));
    }
  }

  Future<(int, int)> _decodeDimensions(Uint8List bytes) async {
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frame = await codec.getNextFrame();
    final int width = frame.image.width;
    final int height = frame.image.height;
    frame.image.dispose();
    return (width, height);
  }

  (int, int) _targetDimensions(int width, int height) {
    final int longest = width > height ? width : height;
    if (longest <= _longestEdge) return (width, height);
    final double scale = _longestEdge / longest;
    return ((width * scale).round(), (height * scale).round());
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 32)}';
}
