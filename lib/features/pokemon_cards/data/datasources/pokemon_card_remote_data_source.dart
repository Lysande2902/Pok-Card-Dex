import 'package:dio/dio.dart';
import 'package:lista_flutte/features/pokemon_cards/data/models/pokemon_card_model.dart';

const String kPokemonTcgApiKey = String.fromEnvironment('POKEMON_TCG_API_KEY');

abstract class PokemonCardRemoteDataSource {
  Future<List<PokemonCardModel>> getCards(int page, int pageSize, String? query, Set<String> types);
}

class PokemonCardRemoteDataSourceImpl implements PokemonCardRemoteDataSource {
  final Dio dio;
  PokemonCardRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PokemonCardModel>> getCards(int page, int pageSize, String? query, Set<String> types) async {
    const int maxAttempts = 3;
    int attempt = 0;
    DioException? lastError;

    final queryParts = <String>[];
    if (query != null && query.isNotEmpty) {
      queryParts.add('name:"$query*"');
    }
    // La API requiere que cada tipo se especifique por separado, unidos por OR.
    // Ejemplo: types:Fire OR types:Water
    if (types.isNotEmpty) {
      queryParts.add(types.map((type) => 'types:$type').join(' OR '));
    }

    final queryParameters = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };
    if (queryParts.isNotEmpty) {
      // Une las diferentes partes de la consulta con AND.
      queryParameters['q'] = queryParts.join(' AND ');
    }

    while (attempt < maxAttempts) {
      try {
        final response = await dio.get(
          '/cards',
          queryParameters: queryParameters,
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
        final isRetryable = 
            // Errores de servidor (500, 502, 503, etc.)
            (code >= 500 && code < 600) ||
            // Errores de timeout de conexión o recepción
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout;

        // Reintentar en errores de servidor o timeouts, con espera exponencial.
        if (isRetryable && attempt < maxAttempts - 1) {
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