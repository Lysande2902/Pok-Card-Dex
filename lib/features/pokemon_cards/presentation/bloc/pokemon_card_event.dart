part of 'pokemon_card_bloc.dart';

abstract class PokemonCardEvent extends Equatable {
  const PokemonCardEvent();

  @override
  List<Object?> get props => [];
}

class PokemonCardFetched extends PokemonCardEvent {
  final bool isRefresh;
  const PokemonCardFetched({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}