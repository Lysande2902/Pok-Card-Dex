import 'package:lista_flutte/features/pokemon_cards/domain/entities/resistance.dart';

class ResistanceModel extends Resistance {
  const ResistanceModel({
    required super.type,
    required super.value,
  });

  factory ResistanceModel.fromJson(Map<String, dynamic> json) {
    return ResistanceModel(
      type: json['type'] as String,
      value: json['value'] as String,
    );
  }
}