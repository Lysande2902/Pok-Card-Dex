import 'package:lista_flutte/features/pokemon_cards/data/datasources/pokemon_card_remote_data_source.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/entities/pokemon_card.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/repositories/pokemon_card_repository.dart';

class PokemonCardRepositoryImpl implements PokemonCardRepository {
  final PokemonCardRemoteDataSource remoteDataSource;

  PokemonCardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PokemonCard>> getCards({
    required int page,
    required int pageSize,
    String? query,
    Set<String> types = const {},
  }) async {
    final cardModels = await remoteDataSource.getCards(page, pageSize, query, types);
    return cardModels.map((model) => model.toEntity()).toList();
  }
}