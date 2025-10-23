import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/entities/pokemon_card.dart';

class PokemonCardListItem extends StatelessWidget {
  const PokemonCardListItem({super.key, required this.card});

  final PokemonCard card;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        context.push('/card/${card.id}', extra: card);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias, // Ensures content respects the rounded corners
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Hero(
                tag: card.id,
                child: CachedNetworkImage(
                  imageUrl: card.imageUrl,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                  errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_outlined),
                  width: 70,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(card.name, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (card.hp != null)
                          Chip(label: Text('HP ${card.hp}')),
                        if (card.types?.isNotEmpty ?? false)
                          ...card.types!.map(
                            (type) => Chip(label: Text(type)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurface.withAlpha(102)), // 0.4 opacity
            ],
          ),
        ),
      ),
    );
  }
}