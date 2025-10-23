part of 'pokemon_card_bloc.dart';

@immutable
abstract class PokemonCardState extends Equatable {
  final List<PokemonCard> cards;
  final bool hasReachedMax;
  final String? searchQuery;
  final Set<String> activeFilters;

  const PokemonCardState({
    this.cards = const [],
    this.hasReachedMax = false,
    this.searchQuery,
    this.activeFilters = const {},
  });

  PokemonCardState copyWith({
    List<PokemonCard>? cards,
    bool? hasReachedMax,
    String? searchQuery,
    Set<String>? activeFilters,
  }) {
    // This method will be implemented by subclasses
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [cards, hasReachedMax, searchQuery, activeFilters];
}

class PokemonCardInitial extends PokemonCardState {}

class PokemonCardLoading extends PokemonCardState {
  const PokemonCardLoading({
    super.searchQuery,
    super.activeFilters,
  });
}

class PokemonCardLoaded extends PokemonCardState {
  const PokemonCardLoaded({
    required super.cards,
    required super.hasReachedMax,
    super.searchQuery,
    super.activeFilters,
  });

  @override
  PokemonCardLoaded copyWith({
    List<PokemonCard>? cards,
    bool? hasReachedMax,
    String? searchQuery,
    Set<String>? activeFilters,
  }) {
    return PokemonCardLoaded(
      cards: cards ?? this.cards,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchQuery: searchQuery ?? this.searchQuery,
      activeFilters: activeFilters ?? this.activeFilters,
    );
  }
}

class PokemonCardError extends PokemonCardState {
  final String message;

  const PokemonCardError(
    this.message, {
    super.searchQuery,
    super.activeFilters,
  });

  @override
  List<Object?> get props => [message, searchQuery, activeFilters];
}