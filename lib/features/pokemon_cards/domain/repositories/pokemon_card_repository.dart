import 'package:lista_flutte/features/pokemon_cards/domain/entities/pokemon_card.dart';

abstract class PokemonCardRepository {
  Future<List<PokemonCard>> getCards({
    required int page,
    required int pageSize,
    String? query,
    Set<String> types,
  });
}