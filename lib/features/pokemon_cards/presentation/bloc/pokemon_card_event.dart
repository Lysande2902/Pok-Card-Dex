part of 'pokemon_card_bloc.dart';

@immutable
abstract class PokemonCardEvent extends Equatable {
  const PokemonCardEvent();

  @override
  List<Object> get props => [];
}

class PokemonCardFetched extends PokemonCardEvent {
  final bool isRefresh;
  const PokemonCardFetched({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}

class CardsSearched extends PokemonCardEvent {
  final String query;
  const CardsSearched(this.query);

  @override
  List<Object> get props => [query];
}

class FilterChanged extends PokemonCardEvent {
  final Set<String> newFilters;
  const FilterChanged(this.newFilters);

  @override
  List<Object> get props => [newFilters];
}