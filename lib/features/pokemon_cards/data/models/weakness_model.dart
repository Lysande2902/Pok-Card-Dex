import 'package:lista_flutte/features/pokemon_cards/domain/entities/weakness.dart';

class WeaknessModel extends Weakness {
  const WeaknessModel({
    required super.type,
    required super.value,
  });

  factory WeaknessModel.fromJson(Map<String, dynamic> json) {
    return WeaknessModel(
      type: json['type'] as String,
      value: json['value'] as String,
    );
  }
}