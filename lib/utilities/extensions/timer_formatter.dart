import 'dart:ffi';

extension TimerFormatter on num {
  String toTimerFormatte() {
    String minutes = (toInt() ~/ 60).toString();
    String seconds = (toInt() % 60).toInt().toString();
    return "$minutes : $seconds";
  }
}
