import 'package:dio/dio.dart';
import 'package:lista_flutte/features/pokemon_cards/data/models/pokemon_card_model.dart';

const String kPokemonTcgApiKey = String.fromEnvironment('POKEMON_TCG_API_KEY');

abstract class PokemonCardRemoteDataSource {
  Future<List<PokemonCardModel>> getCards(int page, int pageSize);
}

class PokemonCardRemoteDataSourceImpl implements PokemonCardRemoteDataSource {
  final Dio dio;
  PokemonCardRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PokemonCardModel>> getCards(int page, int pageSize) async {
    final headers = <String, String>{'Accept': 'application/json'};
    if (kPokemonTcgApiKey.isNotEmpty) {
      headers['X-Api-Key'] = kPokemonTcgApiKey;
    }

    const int maxAttempts = 3;
    int attempt = 0;
    DioException? lastError;

    while (attempt < maxAttempts) {
      try {
        final response = await dio.get(
          '/cards',
          queryParameters: {
            'page': page,
            'pageSize': pageSize,
          },
          options: Options(headers: headers),
        );

        if (response.statusCode == 200) {
          final data = response.data as Map<String, dynamic>;
          final list = (data['data'] as List?) ?? [];
          return list
              .map((e) => PokemonCardModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }

        // For non-200, create a descriptive error
        final code = response.statusCode ?? 0;
        final statusText = response.statusMessage ?? '';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'HTTP $code: $statusText',
        );
      } on DioException catch (e) {
        lastError = e;
        final code = e.response?.statusCode ?? 0;
        // Retry on server errors (5xx) with exponential backoff
        if (code >= 500 && code < 600 && attempt < maxAttempts - 1) {
          final delaySeconds = 1 << attempt; // 1, 2, 4
          await Future.delayed(Duration(seconds: delaySeconds));
          attempt++;
          continue;
        }
        rethrow; // non-retryable or last attempt
      }
    }

    // If we exit the loop without returning, throw the last error
    throw lastError ?? Exception('Error desconocido al cargar cartas');
  }
}