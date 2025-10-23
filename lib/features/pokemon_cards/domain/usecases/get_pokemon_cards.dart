import 'package:lista_flutte/features/pokemon_cards/domain/entities/pokemon_card.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/repositories/pokemon_card_repository.dart';

class GetPokemonCards {
  final PokemonCardRepository repository;

  GetPokemonCards(this.repository);

  Future<List<PokemonCard>> call({
    required int page,
    required int pageSize,
    String? query,
    Set<String> types = const {},
  }) {
    return repository.getCards(
        page: page, pageSize: pageSize, query: query, types: types);
  }
}