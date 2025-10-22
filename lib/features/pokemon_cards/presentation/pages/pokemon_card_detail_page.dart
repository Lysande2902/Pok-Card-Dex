import 'package:flutter/material.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/entities/pokemon_card.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/entities/attack.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/entities/resistance.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/entities/weakness.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokemonCardDetailPage extends StatelessWidget {
  final PokemonCard card;

  const PokemonCardDetailPage({super.key, required this.card});

  static Route<void> route({required PokemonCard card}) {
    return MaterialPageRoute(
      builder: (_) => PokemonCardDetailPage(card: card),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(card.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCardImage(context),
            const SizedBox(height: 24),
            _buildCardInfoSection(textTheme),
            if (card.attacks?.isNotEmpty == true) ...[
              const SizedBox(height: 24),
              _buildAttacksSection(textTheme, card.attacks!),
            ],
            if (card.weaknesses?.isNotEmpty == true || card.resistances?.isNotEmpty == true) ...[
              const SizedBox(height: 24),
              _buildWeaknessResistanceSection(textTheme),
            ],
            if (card.flavorText != null) ...[
              const SizedBox(height: 24),
              _buildFlavorTextSection(textTheme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCardImage(BuildContext context) {
    return Center(
      child: Hero(
        tag: card.id,
        child: CachedNetworkImage(
          imageUrl: card.images.large,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.contain,
          height: 400,
        ),
      ),
    );
  }

  Widget _buildCardInfoSection(TextTheme textTheme) {
    return _buildSection(
      title: 'Información',
      textTheme: textTheme,
      children: [
        _buildInfoRow('Supertype:', card.supertype, textTheme), 
        if (card.subtypes?.isNotEmpty == true)
          _buildInfoRow('Subtypes:', card.subtypes!.join(', '), textTheme),
        if (card.hp != null) _buildInfoRow('HP:', card.hp!, textTheme),
        if (card.types?.isNotEmpty == true)
          _buildInfoRow('Types:', card.types!.join(', '), textTheme),
      ],
    );
  }

  Widget _buildAttacksSection(TextTheme textTheme, List<Attack> attacks) {
    return _buildSection(
      title: 'Ataques',
      textTheme: textTheme,
      children: attacks.map((attack) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${attack.name} - ${attack.damage}',
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (attack.text != null) Text(attack.text!, style: textTheme.bodyMedium),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeaknessResistanceSection(TextTheme textTheme) {
    return Row(
      children: [
        if (card.weaknesses?.isNotEmpty == true)
          Expanded(
            child: _buildSection(
              title: 'Debilidades',
              textTheme: textTheme,
              children: card.weaknesses!.map((Weakness w) => Text('${w.type} ${w.value}')).toList(),
            ),
          ),
        if (card.resistances?.isNotEmpty == true)
          Expanded(
            child: _buildSection(
              title: 'Resistencias',
              textTheme: textTheme,
              children: card.resistances!.map((Resistance r) => Text('${r.type} ${r.value}')).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildFlavorTextSection(TextTheme textTheme) {
    return _buildSection(
      title: 'Descripción',
      textTheme: textTheme,
      children: [
        Text(
          card.flavorText!,
          style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String? value, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan( 
          style: textTheme.bodyLarge,
          children: [
            TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' ${value ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required TextTheme textTheme, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.headlineSmall),
        const Divider(),
        ...children,
      ],
    );
  }
}
