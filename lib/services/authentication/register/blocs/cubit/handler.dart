import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'state.dart';

class RegisterHandler extends Cubit<RegisterState> {
  RegisterHandler() : super(RegisterInitial()) {
    _intial();
  }

  _intial() {
    emit(RegisterCurrentState(currentState: CurrentState.mainScreen));
  }

  mainNext() {
    if (state is RegisterCurrentState) {
      emit((state as RegisterCurrentState)
          .copyWith(currentState: CurrentState.infoType));
    }
  }

  typeNext() {
    if (state is RegisterCurrentState) {
      emit((state as RegisterCurrentState)
          .copyWith(currentState: CurrentState.infoDuration));
    }
  }

  durationNext() {
    if (state is RegisterCurrentState) {
      emit((state as RegisterCurrentState)
          .copyWith(currentState: CurrentState.infoCounts));
    }
  }

  Decoration getBoxDecoration() {
    return const BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Color(0x00000050),
          offset: Offset(0, 4),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ],
    );
  }
}
