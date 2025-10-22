import 'package:lista_flutte/features/pokemon_cards/domain/entities/pokemon_card_images.dart';

class PokemonCardImagesModel extends PokemonCardImages {
  const PokemonCardImagesModel({
    required super.small,
    required super.large,
  });

  factory PokemonCardImagesModel.fromJson(Map<String, dynamic> json) {
    return PokemonCardImagesModel(
      small: json['small'] as String,
      large: json['large'] as String,
    );
  }

  PokemonCardImages toEntity() => this;
}