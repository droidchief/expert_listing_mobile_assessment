import '../../../core/error/failure.dart';
import '../../../core/network/dio_client.dart';
import '../domain/filter_options.dart';

class FiltersRepository {
  const FiltersRepository(this._dioClient);

  final DioClient _dioClient;

  Future<FilterOptions> getFilterOptions() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/filters/options',
    );
    try {
      return FilterOptions.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    } catch (_) {
      throw const UnknownFailure('Something went wrong loading filters.');
    }
  }
}
