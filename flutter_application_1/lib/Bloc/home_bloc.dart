import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class PreguntaBloc extends Bloc<PreguntaEvent, PreguntaState> {
  PreguntaBloc() : super(const PreguntaState(pregunta: '')) {
    on<PreguntaCambiada>((event, emit) {
      emit(state.copyWith(pregunta: event.pregunta));
    });
  }
}
