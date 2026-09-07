import '../../../core/error/failure.dart';
import '../../../core/network/dio_client.dart';
import '../domain/media_draft.dart';

class ComposerRepository {
  const ComposerRepository(this._dioClient);

  final DioClient _dioClient;

  Future<String> createPost({
    required String postType,
    required String body,
    String? transactionType,
    String? locationId,
    num? priceAmount,
    String? pricePeriod,
    int? bedrooms,
    int? bathrooms,
    int? parkingSpaces,
    List<MediaDraft> media = const [],
  }) async {
    final Map<String, dynamic> payload = {
      'post_type': postType,
      'body': body,
      'transaction_type': ?transactionType,
      'location_id': ?locationId,
      'price_amount': ?priceAmount,
      'price_currency': ?(priceAmount == null ? null : 'NGN'),
      'price_period': ?pricePeriod,
      'bedrooms': ?bedrooms,
      'bathrooms': ?bathrooms,
      'parking_spaces': ?parkingSpaces,
      if (media.isNotEmpty)
        'media': [
          for (final item in media)
            {
              'media_type': 'image',
              'storage_path': item.storagePath,
              'public_url': item.publicUrl,
              'width_px': item.widthPx,
              'height_px': item.heightPx,
              'mime_type': item.mimeType,
              'byte_size': item.byteSize,
              'position': item.position,
            },
        ],
    };

    final response =
        await _dioClient.post<Map<String, dynamic>>('/posts', data: payload);

    try {
      return (response.data!['data'] as Map<String, dynamic>)['id'] as String;
    } catch (_) {
      throw const UnknownFailure('Something went wrong creating your post.');
    }
  }
}
