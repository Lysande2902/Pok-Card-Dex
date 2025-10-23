import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_flutte/features/pokemon_cards/presentation/bloc/pokemon_card_bloc.dart';

class FilterDrawer extends StatelessWidget {
  final Set<String> activeFilters;

  const FilterDrawer({super.key, required this.activeFilters});

  static const List<String> _pokemonTypes = [
    'Colorless',
    'Darkness',
    'Dragon',
    'Fairy',
    'Fighting',
    'Fire',
    'Grass',
    'Lightning',
    'Metal',
    'Psychic',
    'Water',
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text(
              'Filtrar por Tipo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ..._pokemonTypes.map((type) {
            return CheckboxListTile(
              title: Text(type),
              value: activeFilters.contains(type),
              onChanged: (bool? value) {
                final newFilters = Set<String>.from(activeFilters);
                if (value == true) {
                  newFilters.add(type);
                } else {
                  newFilters.remove(type);
                }
                context.read<PokemonCardBloc>().add(FilterChanged(newFilters));
              },
            );
          }),
        ],
      ),
    );
  }
}