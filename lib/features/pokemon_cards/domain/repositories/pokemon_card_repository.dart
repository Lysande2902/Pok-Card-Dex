import 'package:lista_flutte/features/pokemon_cards/domain/entities/pokemon_card.dart';

abstract class PokemonCardRepository {
  Future<List<PokemonCard>> getCards(int page, int pageSize);
}