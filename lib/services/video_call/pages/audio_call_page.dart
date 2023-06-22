import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../chats/model/chat_model.dart';

/// JoinChannelAudio Example
class AudioCallPage extends StatefulWidget {
  /// Construct the [AudioCallPage]
  const AudioCallPage(this.chat, {Key? key}) : super(key: key);
  final ChatModel chat;

  @override
  State<StatefulWidget> createState() => _State();
}

const String appId = '1ed862ccc609403c8eec5d2f34e8565a';
const String channelId = 'BETACall';
const int uID = 0;
const String token =
    '007eJxTYHhy9db1y8vPpGclGh9tjFwuwlq4MmyV4MTg/SJRNWweLw4rMBimpliYGSUnJ5sZWJoYGCdbpKYmm6YYpRmbpFqYmpkmcu3rSWkIZGQ4khbJyMgAgSA+B4OTa4ijc2JODgMDABz8IOE=';

class _State extends State<AudioCallPage> {
  late final RtcEngine _engine;
  bool isJoined = false,
      openMicrophone = true,
      enableSpeakerphone = true,
      playEffect = false;
  bool _enableInEarMonitoring = false;
  double _recordingVolume = 100,
      _playbackVolume = 100,
      _inEarMonitoringVolume = 100;
  late TextEditingController _controller;
  ChannelProfileType _channelProfileType =
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
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
    ));

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
      _enableInEarMonitoring = false;
      _recordingVolume = 100;
      _playbackVolume = 100;
      _inEarMonitoringVolume = 100;
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

  _switchEffect() async {
    if (playEffect) {
      await _engine.stopEffect(1);
      setState(() {
        playEffect = false;
      });
    } else {
      final path =
          (await _engine.getAssetAbsolutePath("assets/Sound_Horizon.mp3"))!;
      await _engine.playEffect(
          soundId: 1,
          filePath: path,
          loopCount: 0,
          pitch: 1,
          pan: 1,
          gain: 100,
          publish: true);
      // .then((value) {
      setState(() {
        playEffect = true;
      });
    }
  }

  _onChangeInEarMonitoringVolume(double value) async {
    _inEarMonitoringVolume = value;
    await _engine.setInEarMonitoringVolume(_inEarMonitoringVolume.toInt());
    setState(() {});
  }

  _toggleInEarMonitoring(value) async {
    try {
      await _engine.enableInEarMonitoring(
          enabled: value,
          includeAudioFilters: EarMonitoringFilterType.earMonitoringFilterNone);
      _enableInEarMonitoring = value;
      setState(() {});
    } catch (e) {
      // Do nothing
    }
  }

  @override
  Widget build(BuildContext context) {
    final channelProfileType = [
      ChannelProfileType.channelProfileLiveBroadcasting,
      ChannelProfileType.channelProfileCommunication,
    ];
    final items = channelProfileType
        .map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                e.toString().split('.')[1],
              ),
            ))
        .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/images/splash.png",
          width: 60,
        ),
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
                  onTap: () {},
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
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
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

//Stack(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               TextField(
//                 controller: _controller,
//                 decoration: const InputDecoration(hintText: 'Channel ID'),
//               ),
//               const Text('Channel Profile: '),
//               DropdownButton<ChannelProfileType>(
//                   items: items,
//                   value: _channelProfileType,
//                   onChanged: isJoined
//                       ? null
//                       : (v) async {
//                           setState(() {
//                             _channelProfileType = v!;
//                           });
//                         }),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: ElevatedButton(
//                       onPressed: isJoined ? _leaveChannel : _joinChannel,
//                       child: Text('${isJoined ? 'Leave' : 'Join'} channel'),
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//           Align(
//               alignment: Alignment.bottomRight,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     ElevatedButton(
//                       onPressed: _switchMicrophone,
//                       child: Text('Microphone ${openMicrophone ? 'on' : 'off'}'),
//                     ),
//                     ElevatedButton(
//                       onPressed: isJoined ? _switchSpeakerphone : null,
//                       child:
//                           Text(enableSpeakerphone ? 'Speakerphone' : 'Earpiece'),
//                     ),
//                     if (!kIsWeb)
//                       ElevatedButton(
//                         onPressed: isJoined ? _switchEffect : null,
//                         child: Text('${playEffect ? 'Stop' : 'Play'} effect'),
//                       ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         const Text('RecordingVolume:'),
//                         Slider(
//                           value: _recordingVolume,
//                           min: 0,
//                           max: 400,
//                           divisions: 5,
//                           label: 'RecordingVolume',
//                           onChanged: isJoined
//                               ? (double value) async {
//                                   setState(() {
//                                     _recordingVolume = value;
//                                   });
//                                   await _engine
//                                       .adjustRecordingSignalVolume(value.toInt());
//                                 }
//                               : null,
//                         )
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         const Text('PlaybackVolume:'),
//                         Slider(
//                           value: _playbackVolume,
//                           min: 0,
//                           max: 400,
//                           divisions: 5,
//                           label: 'PlaybackVolume',
//                           onChanged: isJoined
//                               ? (double value) async {
//                                   setState(() {
//                                     _playbackVolume = value;
//                                   });
//                                   await _engine
//                                       .adjustPlaybackSignalVolume(value.toInt());
//                                 }
//                               : null,
//                         )
//                       ],
//                     ),
//                     Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Row(mainAxisSize: MainAxisSize.min, children: [
//                           const Text('InEar Monitoring Volume:'),
//                           Switch(
//                             value: _enableInEarMonitoring,
//                             onChanged: isJoined ? _toggleInEarMonitoring : null,
//                             activeTrackColor: Colors.grey[350],
//                             activeColor: Colors.white,
//                           )
//                         ]),
//                         if (_enableInEarMonitoring)
//                           SizedBox(
//                               width: 300,
//                               child: Slider(
//                                 value: _inEarMonitoringVolume,
//                                 min: 0,
//                                 max: 100,
//                                 divisions: 5,
//                                 label:
//                                     'InEar Monitoring Volume $_inEarMonitoringVolume',
//                                 onChanged: isJoined
//                                     ? _onChangeInEarMonitoringVolume
//                                     : null,
//                               ))
//                       ],
//                     ),
//                   ],
//                 ),
//               ))
//         ],
//       )
