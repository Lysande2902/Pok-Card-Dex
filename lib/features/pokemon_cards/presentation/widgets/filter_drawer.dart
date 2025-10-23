import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_flutte/features/pokemon_cards/presentation/bloc/pokemon_card_bloc.dart';

class FilterDrawer extends StatelessWidget {
  final Set<String> activeFilters; // Los filtros actualmente aplicados en el BLoC

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

  // 1. Mapa de iconos para cada tipo de Pokémon
  static const Map<String, IconData> _typeIcons = {
    'Colorless': Icons.brightness_7,
    'Darkness': Icons.nightlight_round,
    'Dragon': Icons.whatshot, // Re-using fire icon for dragon
    'Fairy': Icons.star_border,
    'Fighting': Icons.sports_mma,
    'Fire': Icons.local_fire_department,
    'Grass': Icons.eco,
    'Lightning': Icons.flash_on,
    'Metal': Icons.build,
    'Psychic': Icons.psychology,
    'Water': Icons.water_drop,
  };
  @override
  Widget build(BuildContext context) {
    // Usamos un StatefulWidget interno para manejar la selección temporal de filtros
    return _FilterDrawerContent(
      initialFilters: activeFilters,
      allTypes: _pokemonTypes,
    );
  }
}

class _FilterDrawerContent extends StatefulWidget {
  final Set<String> initialFilters;
  final List<String> allTypes;

  const _FilterDrawerContent({
    required this.initialFilters,
    required this.allTypes,
  });

  @override
  State<_FilterDrawerContent> createState() => _FilterDrawerContentState();
}

class _FilterDrawerContentState extends State<_FilterDrawerContent> {
  late Set<String> _selectedFilters;

  @override
  void initState() {
    super.initState();
    _selectedFilters = Set<String>.from(widget.initialFilters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(16.0), // Controlamos nuestro propio padding
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
            ),
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  Icon(Icons.filter_list, color: Colors.white, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Filtrar por Tipo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: widget.allTypes.map((type) {
                  return FilterChip(
 avatar: Icon(
 FilterDrawer._typeIcons[type] ?? Icons.help_outline,
                      color: _selectedFilters.contains(type) ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface.withAlpha(153), // 0.6 opacity
                    ),
                    label: Text(type),
                    selected: _selectedFilters.contains(type),
                    selectedColor: theme.colorScheme.primary,
                    checkmarkColor: theme.colorScheme.onPrimary,
                    labelStyle: TextStyle(color: _selectedFilters.contains(type) ? theme.colorScheme.onPrimary : null),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedFilters.add(type);
                        } else {
                          _selectedFilters.remove(type);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: _selectedFilters.isNotEmpty
                      ? () {
                          setState(() {
                            _selectedFilters.clear();
                          });
                        }
                      : null,
                  child: const Text('Limpiar Filtros'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<PokemonCardBloc>().add(FilterChanged(_selectedFilters));
                    Navigator.of(context).pop(); // Cierra el drawer
                  },
                  child: const Text('Aplicar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}