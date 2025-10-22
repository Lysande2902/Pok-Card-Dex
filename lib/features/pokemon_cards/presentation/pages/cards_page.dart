import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_flutte/features/pokemon_cards/presentation/bloc/pokemon_card_bloc.dart';
import 'package:lista_flutte/features/pokemon_cards/presentation/widgets/pokemon_card_list_item.dart'; // Asegúrate de que este archivo exista

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PokemonCardBloc>().add(const PokemonCardFetched(isRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PokéCard Dex'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<PokemonCardBloc, PokemonCardState>(
        builder: (context, state) {
          if (state is PokemonCardInitial || state is PokemonCardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PokemonCardError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(onPressed: _retryFetch, child: const Text('Reintentar')),
                  ],
                ),
              ));
          }
          if (state is PokemonCardLoaded) {
            if (state.cards.isEmpty) {
              return const Center(child: Text('No hay cartas disponibles'));
            }
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.hasReachedMax ? state.cards.length : state.cards.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.cards.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return PokemonCardListItem(card: state.cards[index]);
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    context.read<PokemonCardBloc>().add(const PokemonCardFetched(isRefresh: true));
    // Espera a que el BLoC emita un estado que no sea de carga para completar el refresh
    await context.read<PokemonCardBloc>().stream.firstWhere(
          (state) => state is PokemonCardLoaded || state is PokemonCardError,
        );
  }

  void _retryFetch() {
    context.read<PokemonCardBloc>().add(const PokemonCardFetched(isRefresh: true));
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PokemonCardBloc>().add(const PokemonCardFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}