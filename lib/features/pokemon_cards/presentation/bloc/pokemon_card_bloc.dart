import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../domain/entities/pokemon_card.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/usecases/get_pokemon_cards.dart';

part 'pokemon_card_event.dart';
part 'pokemon_card_state.dart';

class PokemonCardBloc extends Bloc<PokemonCardEvent, PokemonCardState> {
  final GetPokemonCards getPokemonCards;

  PokemonCardBloc({required this.getPokemonCards}) : super(PokemonCardInitial()) {
    on<PokemonCardFetched>(
      _onFetched,
      transformer: (events, mapper) => events
          .debounce(const Duration(milliseconds: 300))
          .switchMap(mapper),
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
        emit(PokemonCardLoading());
        _page = 1;
        final cards = await getPokemonCards(_page, _pageSize);
        emit(PokemonCardLoaded(cards: cards, hasReachedMax: cards.isEmpty));
        return;
      }

      if (currentState is PokemonCardLoaded) {
        if (currentState.hasReachedMax) return;
        _page += 1;
        final cards = await getPokemonCards(_page, _pageSize);
        emit(cards.isEmpty
            ? currentState.copyWith(hasReachedMax: true)
            : PokemonCardLoaded(
                cards: currentState.cards + cards,
                hasReachedMax: false,
              ));
      }
    } catch (e) {
      _emitError(e, emit);
    }
  }

  void _emitError(Object e, Emitter<PokemonCardState> emit) {
    String message = 'Error desconocido al cargar cartas';
    if (e is DioException) {
      final code = e.response?.statusCode;
      final isTimeout = e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout;
      if (isTimeout) {
        message = 'Tiempo de espera excedido. Intenta de nuevo.';
      } else if (code == 401 || code == 403) {
        message = 'Autorización requerida para la API. Define POKEMON_TCG_API_KEY';
      } else if (code == 404) {
        message = 'Recurso no encontrado (404). Verifica el endpoint o parámetros.';
      } else if (code != null) {
        message = 'Fallo HTTP $code: ${e.message ?? 'Error desconocido'}'.trim();
      } else {
        message = e.message ?? message;
      }
    } else {
      message = e.toString();
    }
    emit(PokemonCardError(message));
  }
}