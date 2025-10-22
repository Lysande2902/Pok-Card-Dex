import 'package:equatable/equatable.dart';

class Weakness extends Equatable {
  final String type;
  final String value;

  const Weakness({required this.type, required this.value});

  @override
  List<Object> get props => [type, value];
}