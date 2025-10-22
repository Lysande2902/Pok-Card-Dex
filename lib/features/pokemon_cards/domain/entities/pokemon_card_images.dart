import 'package:equatable/equatable.dart';

class PokemonCardImages extends Equatable {
  final String small;
  final String large;

  const PokemonCardImages({
    required this.small,
    required this.large,
  });

  @override
  List<Object> get props => [small, large];
}