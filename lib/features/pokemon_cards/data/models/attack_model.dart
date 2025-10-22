import 'package:lista_flutte/features/pokemon_cards/domain/entities/attack.dart';

class AttackModel extends Attack {
  const AttackModel({
    required super.name,
    required super.cost,
    required super.convertedEnergyCost,
    required super.damage,
    super.text,
  });

  factory AttackModel.fromJson(Map<String, dynamic> json) {
    return AttackModel(
      name: json['name'] as String,
      cost: (json['cost'] as List).map((e) => e as String).toList(),
      convertedEnergyCost: json['convertedEnergyCost'] as int,
      damage: json['damage'] as String,
      text: json['text'] as String?,
    );
  }

  Attack toEntity() => this;
}