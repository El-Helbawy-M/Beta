import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'state.dart';

class RegisterHandler extends Cubit<RegisterState> {
  RegisterHandler() : super(RegisterInitial()) {
    _intial();
  }

  _intial() {
    emit(
      RegisterCurrentState(
        currentState: CurrentState.mainScreen,
        typeValue: null,
        durationValue: null,
        countValue: null,
      ),
    );
  }

  mainNext() {
    if (state is RegisterCurrentState) {
      emit((state as RegisterCurrentState).copyWith(
        currentState: CurrentState.infoType,
      ));
    }
  }

  updateTypeValue({required String typeValue}) {
    emit((state as RegisterCurrentState).copyWith(
      typeValue: typeValue,
    ));
  }

  typeNext() {
    if (state is RegisterCurrentState) {
      emit(
        (state as RegisterCurrentState).copyWith(
            currentState: CurrentState.infoDuration,
            typeValue: (state as RegisterCurrentState).typeValue),
      );
    }
  }

  updateDurationValue({required String durationValue}) {
    emit((state as RegisterCurrentState).copyWith(
      typeValue: (state as RegisterCurrentState).typeValue,
      durationValue: durationValue,
    ));
  }

  durationNext() {
    if (state is RegisterCurrentState) {
      emit(
        (state as RegisterCurrentState).copyWith(
          currentState: CurrentState.infoCounts,
          typeValue: (state as RegisterCurrentState).typeValue,
          durationValue: (state as RegisterCurrentState).durationValue,
        ),
      );
    }
  }

//TODO: DO THE 2 METHODS FOR THE COUNT VALUE
  updateCountValue({required String countValue}) {
    emit((state as RegisterCurrentState).copyWith(
      typeValue: (state as RegisterCurrentState).typeValue,
      durationValue: (state as RegisterCurrentState).typeValue,
      countValue: countValue,
    ));
  }

  countNext() {
    if (state is RegisterCurrentState) {
      emit(
        (state as RegisterCurrentState).copyWith(
          typeValue: (state as RegisterCurrentState).typeValue,
          durationValue: (state as RegisterCurrentState).durationValue,
          countValue: (state as RegisterCurrentState).countValue,
        ),
      );
    }
  }

//TODO: DO THE METHOD FOR THE BACK BUTTON

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
