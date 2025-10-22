import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/entities/pokemon_card.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/entities/pokemon_card_images.dart'; // This import will now work
import 'package:lista_flutte/features/pokemon_cards/domain/usecases/get_pokemon_cards.dart';
import 'package:lista_flutte/features/pokemon_cards/presentation/bloc/pokemon_card_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPokemonCards extends Mock implements GetPokemonCards {}

void main() {
  late PokemonCardBloc pokemonCardBloc;
  late MockGetPokemonCards mockGetPokemonCards;

  setUp(() {
    mockGetPokemonCards = MockGetPokemonCards();
    pokemonCardBloc = PokemonCardBloc(getPokemonCards: mockGetPokemonCards);
  });

  tearDown(() {
    pokemonCardBloc.close();
  });

  final tCards = [
    const PokemonCard(
      id: '1',
      name: 'Pikachu',
      images: PokemonCardImages(small: 'url1_small', large: 'url1_large'),
      imageUrl: 'url1_small',
    ),
    const PokemonCard(
      id: '2',
      name: 'Charmander',
      images: PokemonCardImages(small: 'url2_small', large: 'url2_large'),
      imageUrl: 'url2_small',
    ),
  ];

  test('initial state should be PokemonCardInitial', () {
    expect(pokemonCardBloc.state, PokemonCardInitial());
  });

  group('PokemonCardFetched', () {
    blocTest<PokemonCardBloc, PokemonCardState>(
      'emits [PokemonCardLoading, PokemonCardLoaded] when PokemonCardFetched is added and succeeds.',
      build: () {
        when(() => mockGetPokemonCards(1, 20)).thenAnswer((_) async => tCards);
        return pokemonCardBloc;
      },
      act: (bloc) => bloc.add(const PokemonCardFetched(isRefresh: true)),
      expect: () => <PokemonCardState>[
        PokemonCardLoading(),
        PokemonCardLoaded(cards: tCards, hasReachedMax: false),
      ],
      verify: (_) {
        verify(() => mockGetPokemonCards(1, 20)).called(1);
      },
    );

    blocTest<PokemonCardBloc, PokemonCardState>(
      'emits [PokemonCardLoading, PokemonCardError] when PokemonCardFetched is added and fails.',
      build: () {
        when(() => mockGetPokemonCards(1, 20)).thenThrow(
          DioException(requestOptions: RequestOptions(path: '')),
        );
        return pokemonCardBloc;
      },
      act: (bloc) => bloc.add(const PokemonCardFetched(isRefresh: true)),
      expect: () => <PokemonCardState>[
        PokemonCardLoading(),
        const PokemonCardError('Error desconocido al cargar cartas'),
      ],
      verify: (_) {
        verify(() => mockGetPokemonCards(1, 20)).called(1);
      },
    );

    blocTest<PokemonCardBloc, PokemonCardState>(
      'emits [PokemonCardLoaded with more cards] when fetching next page.',
      build: () {
        when(() => mockGetPokemonCards(2, 20)).thenAnswer((_) async => tCards);
        return pokemonCardBloc;
      },
      seed: () => PokemonCardLoaded(
        cards: [
          const PokemonCard(
            id: '0',
            name: 'Bulbasaur',
            images: PokemonCardImages(small: 'url0_small', large: 'url0_large'),
            imageUrl: 'url0_small',
          ),
        ],
        hasReachedMax: false,
      ),
      act: (bloc) => bloc.add(const PokemonCardFetched()),
      wait: const Duration(milliseconds: 300), // Esperar por el debounce
      expect: () => <PokemonCardState>[
        PokemonCardLoaded(
          cards: [
            const PokemonCard(
              id: '0',
              name: 'Bulbasaur',
              images: PokemonCardImages(small: 'url0_small', large: 'url0_large'),
              imageUrl: 'url0_small',
            ),
            ...tCards,
          ],
          hasReachedMax: false,
        ),
      ],
      verify: (_) {
        verify(() => mockGetPokemonCards(2, 20)).called(1);
      },
    );
  });
}