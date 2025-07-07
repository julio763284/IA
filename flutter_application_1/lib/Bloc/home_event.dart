// Define los eventos que el BLoC manejará

abstract class PreguntaEvent {}

class PreguntaCambiada extends PreguntaEvent {
  final String pregunta;

  PreguntaCambiada(this.pregunta);
}
