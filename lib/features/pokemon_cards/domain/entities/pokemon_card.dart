import 'package:equatable/equatable.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/entities/attack.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/entities/pokemon_card_images.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/entities/resistance.dart';
import 'package:lista_flutte/features/pokemon_cards/domain/entities/weakness.dart';

class PokemonCard extends Equatable {
  final String id;
  final String name;
  final PokemonCardImages images;
  final String imageUrl;
  final String? supertype;
  final List<String>? subtypes;
  final String? hp;
  final List<String>? types;
  final String? rarity;
  final String? flavorText;
  final List<Attack>? attacks;
  final List<Weakness>? weaknesses;
  final List<Resistance>? resistances;

  const PokemonCard({
    required this.id,
    required this.name,
    required this.images,
    required this.imageUrl,
    this.supertype,
    this.subtypes,
    this.hp,
    this.types,
    this.rarity,
    this.flavorText,
    this.attacks,
    this.weaknesses,
    this.resistances,
  });

  @override
  List<Object?> get props => [
        id, name, images, imageUrl, supertype, subtypes, hp, types, rarity,
        flavorText, attacks, weaknesses, resistances,
      ];
}