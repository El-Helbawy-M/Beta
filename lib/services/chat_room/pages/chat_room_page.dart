import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/config/app_events.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import 'package:flutter_project_base/utilities/components/arrow_back.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';

import '../../../config/app_states.dart';
import '../blocs/chat_room_bloc.dart';
import '../widgets/message_card.dart';

class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<ChatRoomBloc>(context);
    return CustomPageBody(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .2,
        leading: Row(
          children: [
            const SizedBox(width: 16),
            const ArrowBack(),
            const SizedBox(width: 8),
            Stack(
              alignment: Alignment.center,
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg"),
                ),
                Positioned(
                  right: 36,
                  top: 36,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        leadingWidth: 86,
        titleSpacing: 12,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "محمد احمد",
              style: AppTextStyles.w600.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              "متصل",
              style: AppTextStyles.w600.copyWith(fontSize: 11, color: Colors.green),
            ),
          ],
        ),
        actions: [
          Icon(Icons.video_camera_front, color: Theme.of(context).colorScheme.primary),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.call, color: Theme.of(context).colorScheme.primary),
          ),
          Icon(Icons.more_vert_outlined, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
        ],
      ),
      //=================================================================================================
      //=================================================================================================
      //=================================================================================================
      //=================================================================================================
      //=================================================================================================
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatRoomBloc, AppStates>(builder: (context, state) {
              if (state is Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is Error) {
                return Center(child: Text(state.toString()));
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        ...List.generate(
                          bloc.messages.length,
                          (index) => MessageCard(
                            message: bloc.messages[index],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
          ),
          Divider(
            height: 0,
            color: Theme.of(context).dividerColor,
          ),
          ChatTextField(
            onSend: (value) => bloc.add(Send(arrgument: value)),
          ),
        ],
      ),
    );
  }
}

class ChatTextField extends StatefulWidget {
  const ChatTextField({
    super.key,
    this.onSend,
  });
  final Function(String)? onSend;
  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextField(
                controller: controller,
                onChanged: (value) => setState(() {}),
                keyboardType: TextInputType.multiline,
                expands: true,
                maxLines: null,
                minLines: null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  hintText: "اكتب رسالة ...",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          drawSvgIcon("image", width: 24, height: 24, iconColor: Theme.of(context).colorScheme.primary),
          if (controller.text.isNotEmpty) const SizedBox(width: 8),
          if (controller.text.isNotEmpty)
            RotatedBox(
              quarterTurns: 3,
              child: GestureDetector(
                onTap: () => setState(
                  () {
                    widget.onSend?.call(controller.text);
                    controller.clear();
                  },
                ),
                child: drawSvgIcon(
                  "send",
                  width: 24,
                  height: 24,
                  iconColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
