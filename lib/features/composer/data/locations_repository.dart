import '../../../core/error/failure.dart';
import '../../../core/network/dio_client.dart';
import '../domain/location_option.dart';

class LocationsRepository {
  const LocationsRepository(this._dioClient);

  final DioClient _dioClient;

  Future<List<LocationOption>> search({String q = '', int limit = 20}) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/locations',
      queryParameters: {
        'q': ?(q.isEmpty ? null : q),
        'limit': limit,
      },
    );
    try {
      final data = response.data!['data'] as List<dynamic>;
      return data
          .map((e) => LocationOption.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const UnknownFailure('Something went wrong loading locations.');
    }
  }
}
