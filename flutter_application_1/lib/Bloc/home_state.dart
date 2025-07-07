import 'package:equatable/equatable.dart';

// Define el estado que manejará el BLoC

class PreguntaState extends Equatable {
  final String pregunta;

  const PreguntaState({required this.pregunta});

  PreguntaState copyWith({String? pregunta}) {
    return PreguntaState(
      pregunta: pregunta ?? this.pregunta,
    );
  }

  @override
  List<Object> get props => [pregunta];
}
