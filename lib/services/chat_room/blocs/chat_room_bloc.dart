import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/config/app_events.dart';
import 'package:flutter_project_base/config/app_states.dart';
import 'package:flutter_project_base/utilities/extensions/date_formatter.dart';

import '../models/message_model.dart';

class ChatRoomBloc extends Bloc<AppEvents, AppStates> {
  ChatRoomBloc() : super(Start()) {
    on<Send>(_sendMessage);
  }

  List<MessageModel> messages = [
    MessageModel(
        message: "كيف حالك",
        isSender: false,
        state: 2,
        time: "12:45",
        senderImageUrl:
            "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"),
    MessageModel(
        message: "هل انت بخير اليوم ؟",
        isSender: false,
        state: 2,
        time: "1:00",
        senderImageUrl:
            "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png")
  ];

  void _sendMessage(AppEvents event, Emitter emit) {
    emit(Loading());
    String message = event.arrgument as String;
    messages.add(MessageModel(
        message: message,
        isSender: true,
        state: 1,
        time: DateTime.now().toHoursMinutesSeconds()));
    try {
      // TODO: write the code of sending the message here
    } catch (e) {}
    emit(Done());
  }
}
