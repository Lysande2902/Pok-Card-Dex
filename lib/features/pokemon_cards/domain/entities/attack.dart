import 'package:equatable/equatable.dart';

class Attack extends Equatable {
  final String name;
  final List<String> cost;
  final int convertedEnergyCost;
  final String damage;
  final String? text;

  const Attack({
    required this.name,
    required this.cost,
    required this.convertedEnergyCost,
    required this.damage,
    this.text,
  });

  @override
  List<Object?> get props => [name, cost, convertedEnergyCost, damage, text];
}