import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'features/pokemon_cards/data/datasources/pokemon_card_remote_data_source.dart';
import 'features/pokemon_cards/data/repositories/pokemon_card_repository_impl.dart';
import 'features/pokemon_cards/domain/repositories/pokemon_card_repository.dart';
import 'features/pokemon_cards/domain/usecases/get_pokemon_cards.dart';
import 'features/pokemon_cards/presentation/bloc/pokemon_card_bloc.dart';

final sl = GetIt.instance;

const String kPokemonTcgApiKey = String.fromEnvironment('POKEMON_TCG_API_KEY');

Future<void> init() async {
  // External
  sl.registerLazySingleton<Dio>(() {
    final options = BaseOptions(
      baseUrl: 'https://api.pokemontcg.io/v2',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        if (kPokemonTcgApiKey.isNotEmpty) 'X-Api-Key': kPokemonTcgApiKey,
      },
    );
    return Dio(options);
  });

  // Data sources
  sl.registerLazySingleton<PokemonCardRemoteDataSource>(
    () => PokemonCardRemoteDataSourceImpl(dio: sl()),
  );

  // Repository
  sl.registerLazySingleton<PokemonCardRepository>(
    () => PokemonCardRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton<GetPokemonCards>(() => GetPokemonCards(sl()));

  // BLoC
  sl.registerFactory<PokemonCardBloc>(() => PokemonCardBloc(getPokemonCards: sl()));
}