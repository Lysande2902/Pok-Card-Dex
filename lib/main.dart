import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/entities/pokemon_card.dart';
import 'package:lista_flutte/features/pokemon_cards/presentation/bloc/pokemon_card_bloc.dart';
import 'package:lista_flutte/features/pokemon_cards/presentation/pages/pokemon_card_detail_page.dart';
import 'package:lista_flutte/features/pokemon_cards/presentation/pages/cards_page.dart';
import 'package:lista_flutte/injection_container.dart' as di;

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await di.init();
  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (_) => di.sl<PokemonCardBloc>(),
        // El splash se quitará cuando la primera pantalla se construya
        child: const CardsPage(),
      ),
      routes: [
        GoRoute(
          path: 'card/:id',
          builder: (context, state) {
            final card = state.extra as PokemonCard?;
            if (card == null) {
              // Manejar el caso en que no se pasen datos, quizás redirigir o mostrar error.
              return const Scaffold(body: Center(child: Text('Carta no encontrada')));
            }
            return PokemonCardDetailPage(card: card);
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Una vez que la app está lista para dibujar su primer frame, quitamos el splash.
    // Esto asegura una transición suave.
    FlutterNativeSplash.remove();

    return MaterialApp.router(
      title: 'PokéCard Dex',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark), useMaterial3: true),
      themeMode: ThemeMode.system, // Respeta la configuración del sistema (claro/oscuro)
      routerConfig: _router,
    );
  }
}