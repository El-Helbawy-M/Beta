// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'handler.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterCurrentState extends RegisterState {
  final CurrentState currentState;

  RegisterCurrentState({required this.currentState});

  RegisterCurrentState copyWith({
    CurrentState? currentState,
  }) {
    return RegisterCurrentState(
      currentState: currentState ?? this.currentState,
    );
  }
}

enum CurrentState { mainScreen, infoType, infoDuration, infoCounts }
