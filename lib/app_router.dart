import 'package:go_router/go_router.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/entities/pokemon_card.dart';
import 'package:lista_flutte/features/pokemon_cards/presentation/pages/cards_page.dart';
import 'package:lista_flutte/features/pokemon_cards/presentation/pages/pokemon_card_detail_page.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CardsPage(),
    ),
    GoRoute(
      path: '/card/:id',
      builder: (context, state) {
        final card = state.extra as PokemonCard;
        return PokemonCardDetailPage(card: card);
      },
    ),
  ],
);
