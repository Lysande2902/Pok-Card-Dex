import 'package:lista_flutte/features/pokemon_cards/data/datasources/pokemon_card_remote_data_source.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/entities/pokemon_card.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/repositories/pokemon_card_repository.dart';

class PokemonCardRepositoryImpl implements PokemonCardRepository {
  final PokemonCardRemoteDataSource remoteDataSource;
  PokemonCardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PokemonCard>> getCards(int page, int pageSize) async {
    final models = await remoteDataSource.getCards(page, pageSize);
    return models.map((m) => m.toEntity()).toList();
  }
}