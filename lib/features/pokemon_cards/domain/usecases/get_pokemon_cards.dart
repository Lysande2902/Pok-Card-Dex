import 'package:lista_flutte/features/pokemon_cards/domain/entities/pokemon_card.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/repositories/pokemon_card_repository.dart';

class GetPokemonCards {
  final PokemonCardRepository repository;
  GetPokemonCards(this.repository);

  Future<List<PokemonCard>> call(int page, int pageSize) {
    return repository.getCards(page, pageSize);
  }
}