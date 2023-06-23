import 'dart:developer';
import 'dart:math' as math;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../chats/model/chat_model.dart';

class AudioCallPage extends StatefulWidget {
  const AudioCallPage(this.chat, {Key? key}) : super(key: key);
  final ChatModel chat;

  @override
  State<StatefulWidget> createState() => _State();
}

const String appId = '1ed862ccc609403c8eec5d2f34e8565a';
const String channelId = 'BETACall';
final int uID = math.Random().nextInt(1000);
const String token =
    '007eJxTYOD4a+Q23yZF2fTAvYVH9j88pbNX0sGR48jEuypMi349cT2lwGCYmmJhZpScnGxmYGliYJxskZqabJpilGZskmphamaa6Gk6NaUhkJHhjnAWEyMDBIL4HAxOriGOzok5OQwMANLRIEU=';

class _State extends State<AudioCallPage> {
  late final RtcEngine _engine;
  bool isJoined = false,
      openMicrophone = true,
      enableSpeakerphone = true,
      playEffect = false;
  late TextEditingController _controller;
  final ChannelProfileType _channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: channelId);
    _initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> _initEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(appId: appId));

    _engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        log('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        log('[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        log('[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        setState(() {
          isJoined = false;
        });
      },
    ));

    await _engine.enableAudio();
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioGameStreaming,
    );

    _joinChannel();
  }

  _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }

    await _engine.joinChannel(
        token: token,
        channelId: _controller.text,
        uid: uID,
        options: ChannelMediaOptions(
          channelProfile: _channelProfileType,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ));
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
    setState(() {
      isJoined = false;
      openMicrophone = true;
      enableSpeakerphone = true;
      playEffect = false;
    });
  }

  _switchMicrophone() async {
    // await await _engine.muteLocalAudioStream(!openMicrophone);
    await _engine.enableLocalAudio(!openMicrophone);
    setState(() {
      openMicrophone = !openMicrophone;
    });
  }

  _switchSpeakerphone() async {
    await _engine.setEnableSpeakerphone(!enableSpeakerphone);
    setState(() {
      enableSpeakerphone = !enableSpeakerphone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/images/splash.png",
          width: 60,
        ),
        actions: [
          if (!isJoined)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: const [
                  Text(
                    'Starting Call',
                    style: TextStyle(color: Colors.white),
                  ),
                  CircularProgressIndicator()
                ],
              ),
            )
        ],
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(widget.chat.doctorPhoto),
                      ),
                    ),
                  ),
                  Text(
                    widget.chat.doctorName,
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: isJoined ? _switchMicrophone : null,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.mic,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                InkWell(
                  onTap: isJoined
                      ? () async {
                          await _leaveChannel();
                          if (!mounted) return;
                          Navigator.pop(context);
                        }
                      : null,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: isJoined ? Colors.red : Colors.grey,
                    child: const Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                  ),
                ),
                InkWell(
                  onTap: isJoined ? _switchSpeakerphone : null,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.speaker,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
