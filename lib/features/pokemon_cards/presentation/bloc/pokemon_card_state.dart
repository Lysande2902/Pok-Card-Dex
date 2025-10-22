part of 'pokemon_card_bloc.dart';

abstract class PokemonCardState extends Equatable {
  const PokemonCardState();
  @override
  List<Object?> get props => [];
}

class PokemonCardInitial extends PokemonCardState {}

class PokemonCardLoading extends PokemonCardState {}

class PokemonCardLoaded extends PokemonCardState {
  final List<PokemonCard> cards;
  final bool hasReachedMax;

  const PokemonCardLoaded({
    required this.cards,
    required this.hasReachedMax,
  });

  PokemonCardLoaded copyWith({
    List<PokemonCard>? cards,
    bool? hasReachedMax,
  }) => PokemonCardLoaded(
        cards: cards ?? this.cards,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      );

  @override
  List<Object?> get props => [cards, hasReachedMax];
}

class PokemonCardError extends PokemonCardState {
  final String message;
  const PokemonCardError(this.message);

  @override
  List<Object?> get props => [message];
}