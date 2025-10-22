import 'package:equatable/equatable.dart';

class Resistance extends Equatable {
  final String type;
  final String value;

  const Resistance({required this.type, required this.value});

  @override
  List<Object> get props => [type, value];
}