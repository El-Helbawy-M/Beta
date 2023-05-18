// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'handler.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterCurrentState extends RegisterState {
  final CurrentState currentState;
  String? typeValue;
  String? durationValue;
  String? countValue;

  RegisterCurrentState({
    required this.currentState,
    this.typeValue,
    this.durationValue,
    this.countValue,
  });

  RegisterCurrentState copyWith({
    CurrentState? currentState,
    String? typeValue,
    String? durationValue,
    String? countValue,
  }) {
    return RegisterCurrentState(
      currentState: currentState ?? this.currentState,
      typeValue: typeValue ?? this.typeValue,
      durationValue: durationValue ?? this.durationValue,
      countValue: countValue ?? this.countValue,
    );
  }
}

enum CurrentState { mainScreen, infoType, infoDuration, infoCounts }
