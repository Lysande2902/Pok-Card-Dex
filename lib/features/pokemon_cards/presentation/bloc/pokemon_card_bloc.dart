import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../domain/entities/pokemon_card.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/usecases/get_pokemon_cards.dart';

part 'pokemon_card_event.dart';
part 'pokemon_card_state.dart';

class PokemonCardPaginationError extends PokemonCardState {
  final String message;

  const PokemonCardPaginationError({
    required super.cards,
    required this.message,
  });
}


class PokemonCardBloc extends Bloc<PokemonCardEvent, PokemonCardState> {
  final GetPokemonCards getPokemonCards;

  PokemonCardBloc({required this.getPokemonCards}) : super(PokemonCardInitial()) {
    on<PokemonCardFetched>(
      _onFetched,
      // No debounce needed for fetching, it should be immediate.
    );
    on<CardsSearched>(
      _onSearched,
      transformer: (events, mapper) => events
          .debounce(const Duration(milliseconds: 500))
          .switchMap(mapper),
    );
    on<FilterChanged>(
      _onFilterChanged,
    );
  }

  int _page = 1;
  static const int _pageSize = 20;

  Future<void> _onFetched(
    PokemonCardFetched event,
    Emitter<PokemonCardState> emit,
  ) async {
    final currentState = state;
    try {
      if (event.isRefresh || currentState is PokemonCardInitial || currentState is PokemonCardError) {
        // Para un refresco, siempre usamos los filtros y la consulta del estado actual.
        // Los otros manejadores (búsqueda/filtro) son responsables de poner el estado correcto ANTES de llamar a refresh.
        emit(PokemonCardLoading(searchQuery: state.searchQuery, activeFilters: state.activeFilters));
        _page = 1;
        final cards = await getPokemonCards(
            page: _page, pageSize: _pageSize, query: state.searchQuery, types: state.activeFilters);
        emit(PokemonCardLoaded(
          cards: cards, hasReachedMax: cards.isEmpty,
          searchQuery: state.searchQuery, activeFilters: state.activeFilters
        ));
        return;
      }

      if (currentState is PokemonCardLoaded) {
        if (currentState.hasReachedMax) return;
        _page += 1;
        final cards = await getPokemonCards(
            page: _page, pageSize: _pageSize, query: currentState.searchQuery, types: currentState.activeFilters);
        emit(cards.isEmpty
            ? currentState.copyWith(hasReachedMax: true)
            : PokemonCardLoaded(
                cards: currentState.cards + cards,
                hasReachedMax: false, 
                searchQuery: currentState.searchQuery, 
                activeFilters: currentState.activeFilters,
              ));
      }
    } catch (e) {
      // Si el error ocurre durante la paginación, emitir un estado de error de paginación
      // para no perder las cartas ya cargadas.
      if (currentState is PokemonCardLoaded) {
        emit(PokemonCardPaginationError(
          cards: currentState.cards,
          message: _getErrorMessage(e),
        ));
      } else {
        _emitError(e, emit);
      }
    }
  }

  Future<void> _onSearched(
    CardsSearched event,
    Emitter<PokemonCardState> emit,
  ) async {
    emit(PokemonCardLoading(searchQuery: event.query, activeFilters: state.activeFilters));
    try {
      _page = 1;
      final cards = await getPokemonCards(
          page: _page, pageSize: _pageSize, query: event.query, types: state.activeFilters);
      emit(PokemonCardLoaded(cards: cards, hasReachedMax: cards.isEmpty, searchQuery: event.query, activeFilters: state.activeFilters));
    } catch (e) {
      _emitError(e, emit);
    }
  }

  Future<void> _onFilterChanged(
    FilterChanged event,
    Emitter<PokemonCardState> emit,
  ) async {
    // Immediately update the UI with the new filters, then fetch.
    emit(PokemonCardLoading(searchQuery: state.searchQuery, activeFilters: event.newFilters));
    // Trigger a refresh with the new filters.
    add(const PokemonCardFetched(isRefresh: true));
  }

  String _getErrorMessage(Object e) {
    String message = 'Error desconocido al cargar cartas';
    if (e is DioException) {
      final code = e.response?.statusCode;
      final isTimeout = e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout;
      if (isTimeout) {
        message = 'Tiempo de espera excedido. Intenta de nuevo.';
      } else if (code == 401 || code == 403) {
        message = 'Autorización requerida. Revisa tu clave de API.';
      } else if (code == 404) {
        message = 'No se encontraron resultados (404).';
      } else if (code != null) {
        message = 'Fallo HTTP $code: ${e.message ?? 'Error desconocido'}'.trim();
      } else {
        message = e.message ?? message;
      }
    } else {
      message = e.toString();
    }
    return message;
  }

  void _emitError(Object e, Emitter<PokemonCardState> emit) {
    final message = _getErrorMessage(e);
    emit(PokemonCardError(message, searchQuery: state.searchQuery, activeFilters: state.activeFilters));
  }
}