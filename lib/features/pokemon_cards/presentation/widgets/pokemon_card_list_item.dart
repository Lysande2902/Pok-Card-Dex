import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/entities/pokemon_card.dart';
import 'package:lista_flutte/features/pokemon_cards/presentation/pages/pokemon_card_detail_page.dart';

class PokemonCardListItem extends StatelessWidget {
  const PokemonCardListItem({super.key, required this.card});

  final PokemonCard card;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PokemonCardDetailPage.route(card: card));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Hero(
              tag: card.id,
              child: CachedNetworkImage(
                imageUrl: card.imageUrl,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 50,
                fit: BoxFit.contain,
              ),
            ),
            title: Text(card.name, style: textTheme.titleLarge),
            subtitle: Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (card.hp != null)
                  Chip(
                    label: Text('HP ${card.hp}', style: textTheme.bodySmall),
                    padding: EdgeInsets.zero,
                  ),
                if (card.types?.isNotEmpty ?? false)
                  ...card.types!.map(
                    (type) => Chip(
                      label: Text(type, style: textTheme.bodySmall),
                      padding: EdgeInsets.zero,
                    ),
                  ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}