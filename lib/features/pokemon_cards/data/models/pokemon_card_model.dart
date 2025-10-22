import 'package:lista_flutte/features/pokemon_cards/domain/entities/pokemon_card.dart';
import 'package:lista_flutte/features/pokemon_cards/data/models/attack_model.dart';
import 'package:lista_flutte/features/pokemon_cards/data/models/pokemon_card_images_model.dart';
import 'package:lista_flutte/features/pokemon_cards/data/models/resistance_model.dart';
import 'package:lista_flutte/features/pokemon_cards/data/models/weakness_model.dart';


class PokemonCardModel extends PokemonCard {
  const PokemonCardModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.images,
    super.supertype,
    super.subtypes,
    super.hp,
    super.types,
    super.rarity,
    super.flavorText,
    super.attacks,
    super.weaknesses,
    super.resistances,
  });
  
  factory PokemonCardModel.fromJson(Map<String, dynamic> json) {
    return PokemonCardModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['images']['small'] as String,
      images: PokemonCardImagesModel.fromJson(json['images']),
      supertype: json['supertype'],
      subtypes: json['subtypes']?.cast<String>(),
      hp: json['hp'],
      types: json['types']?.cast<String>(),
      rarity: json['rarity'],
      flavorText: json['flavorText'],
      attacks: (json['attacks'] as List?)?.map((e) => AttackModel.fromJson(e)).toList(),
      weaknesses: (json['weaknesses'] as List?)?.map((e) => WeaknessModel.fromJson(e)).toList(),
      resistances: (json['resistances'] as List?)?.map((e) => ResistanceModel.fromJson(e)).toList(),
    );
  }

  PokemonCard toEntity() => this;
}