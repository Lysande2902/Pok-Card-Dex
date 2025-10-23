import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_flutte/features/pokemon_cards/presentation/bloc/pokemon_card_bloc.dart';
import 'package:lista_flutte/features/pokemon_cards/presentation/widgets/filter_drawer.dart';
import 'package:lista_flutte/features/pokemon_cards/presentation/widgets/pokemon_card_list_item.dart'; // Asegúrate de que este archivo exista

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  bool _isSearching = false;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PokemonCardBloc>().add(const PokemonCardFetched(isRefresh: true));

    _searchController.addListener(() {
      // Notificar al BLoC de cada cambio en la búsqueda.
      context.read<PokemonCardBloc>().add(CardsSearched(_searchController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 1. Transición animada para la barra de búsqueda
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _isSearching
              ? TextField(
                  key: const ValueKey('SearchBar'), // Clave para la animación
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white.withAlpha(179)), // 0.7 opacity
                    // 2. Botón para limpiar la búsqueda
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: () => _searchController.clear(),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                )
              : const Text(
                  'PokéCard Dex',
                  key: ValueKey('AppBarTitle'), // Clave para la animación
                ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  // Dispara manualmente la búsqueda con texto vacío para reiniciar la lista.
                  context.read<PokemonCardBloc>().add(const CardsSearched(''));
                }
              });
            },
          ),
        ],
      ),
      // 3. Indicador de filtros activos en el Drawer
      drawer: BlocProvider.value(
        value: BlocProvider.of<PokemonCardBloc>(context),
        child: BlocBuilder<PokemonCardBloc, PokemonCardState>(
          builder: (context, state) {
            return FilterDrawer(
              activeFilters: state.activeFilters,
            );
          },
        ),
      ),
      body: BlocBuilder<PokemonCardBloc, PokemonCardState>(
        builder: (context, state) {
          // Muestra el indicador de carga para el estado inicial y de carga principal.
          if (state is PokemonCardInitial || (state is PokemonCardLoading && state.cards.isEmpty)) {
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
          if (state is PokemonCardLoaded || state is PokemonCardPaginationError) {
            final cards = state.cards;

            if (state.cards.isEmpty) {
              return const Center(child: Text('No se encontraron cartas.'));
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state is PokemonCardLoaded && state.hasReachedMax
                    ? cards.length + 1 // +1 para el mensaje de "fin de la lista"
                    : cards.length + 1, // +1 para el spinner o el error de paginación
                itemBuilder: (context, index) {
                  if (index >= cards.length) {
                    if (state is PokemonCardPaginationError) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(state.message, textAlign: TextAlign.center),
                            const SizedBox(height: 8),
                            ElevatedButton(onPressed: _retryFetch, child: const Text('Reintentar')),
                          ],
                        ),
                      );
                    }
                    if (state is PokemonCardLoaded && state.hasReachedMax) {
                      return const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Center(child: Text('Has llegado al final')));
                    }
                    // Muestra el spinner al final si no hemos llegado al máximo y no hay error.
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return PokemonCardListItem(card: cards[index]);
                },
              ),
            );
          }
          // Fallback para cualquier otro estado (poco probable)
          return const Center(child: Text('Estado inesperado'));
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
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