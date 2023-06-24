import 'dart:developer' as dev;
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../chats/model/chat_model.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage(this.chat, {Key? key}) : super(key: key);
  final ChatModel chat;

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

const String appId = '1ed862ccc609403c8eec5d2f34e8565a';
const String channelId = 'BETACall';
final int uID = Random().nextInt(1000);
const String token =
    '007eJxTYBAvfKdeqvC5o+P8v7tdLlXLV9huLF36ufALk17B3sbPScwKDIapKRZmRsnJyWYGliYGxskWqanJpilGacYmqRamZqaJfYFTUxoCGRm+NB5jYWSAQBCfg8HJNcTROTEnh4EBAGdpIqM=';

class _VideoCallPageState extends State<VideoCallPage> {
  late final RtcEngine _engine;

  bool isJoined = false,
      switchCamera = true,
      switchRender = true,
      init = false,
      enableAudio = true;
  Set<int> remoteUid = {};
  final bool _isUseFlutterTexture = false;
  final bool _isUseAndroidSurfaceView = false;
  final ChannelProfileType _channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting;

  @override
  void initState() {
    super.initState();

    askForCameraPermission();
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
        dev.log('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        dev.log(
            '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
        dev.log(
            '[onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');
        setState(() {
          remoteUid.add(rUid);
        });
      },
      onUserOffline:
          (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
        dev.log(
            '[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');
        setState(() {
          remoteUid.removeWhere((element) => element == rUid);
        });
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        dev.log(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        setState(() {
          isJoined = false;
          remoteUid.clear();
        });
      },
    ));

    await _engine.enableVideo();
    init = true;
    setState(() {});
    await _joinChannel();
  }

  Future<void> _joinChannel() async {
    await _engine.joinChannel(
      token: token,
      channelId: channelId,
      uid: uID,
      options: ChannelMediaOptions(
        channelProfile: _channelProfileType,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> _leaveChannel() async {
    await _engine.leaveChannel();
  }

  Future<void> _switchCamera() async {
    await _engine.switchCamera();
    setState(() {
      switchCamera = !switchCamera;
    });
  }

  void askForCameraPermission() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      final permissionStatus = await Permission.camera.request();
      if (permissionStatus.isDenied) {
        if (!mounted) return;
        Navigator.pop(context);
      }
    }
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
        backgroundColor: Theme.of(context).colorScheme.secondary,
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
      ),
      body: !init
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.black,
              child: Stack(
                children: [
                  AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine,
                      canvas: const VideoCanvas(uid: 0),
                      useFlutterTexture: _isUseFlutterTexture,
                      useAndroidSurfaceView: _isUseAndroidSurfaceView,
                    ),
                    onAgoraVideoViewCreated: (viewId) {
                      _engine.startPreview();
                    },
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.of(remoteUid.map(
                          (e) => Container(
                            width: 120,
                            height: 120,
                            color: Colors.red,
                            child: AgoraVideoView(
                              controller: VideoViewController.remote(
                                rtcEngine: _engine,
                                canvas: VideoCanvas(uid: e),
                                connection:
                                    const RtcConnection(channelId: channelId),
                                useFlutterTexture: _isUseFlutterTexture,
                                useAndroidSurfaceView: _isUseAndroidSurfaceView,
                              ),
                            ),
                          ),
                        )),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 30,
                    right: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (enableAudio) {
                              await _engine.disableAudio();
                            } else {
                              await _engine.enableAudio();
                            }
                            enableAudio = !enableAudio;
                            setState(() {});
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(
                              enableAudio ? Icons.mic : Icons.mic_off,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await _leaveChannel();
                            if (!mounted) return;
                            Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                isJoined ? Colors.red : Colors.grey,
                            child: const Icon(
                              Icons.call,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: _switchCamera,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(
                              switchCamera
                                  ? Icons.photo_camera_back
                                  : Icons.camera_front,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
    // if (!_isInit) return Container();
  }
}

//ExampleActionsWidget(
//         displayContentBuilder: (context, isLayoutHorizontal) {
//           return ;
//         },
//         // actionsBuilder: (context, isLayoutHorizontal) {
//         //   final channelProfileType = [
//         //     ChannelProfileType.channelProfileLiveBroadcasting,
//         //     ChannelProfileType.channelProfileCommunication,
//         //   ];
//         //   final items = channelProfileType
//         //       .map((e) => DropdownMenuItem(
//         //             value: e,
//         //             child: Text(
//         //               e.toString().split('.')[1],
//         //             ),
//         //           ))
//         //       .toList();
//         //
//         //   return Column(
//         //     mainAxisAlignment: MainAxisAlignment.start,
//         //     crossAxisAlignment: CrossAxisAlignment.start,
//         //     mainAxisSize: MainAxisSize.min,
//         //     children: [
//         //       TextField(
//         //         controller: _controller,
//         //         decoration: const InputDecoration(hintText: 'Channel ID'),
//         //       ),
//         //       if (!kIsWeb &&
//         //           (defaultTargetPlatform == TargetPlatform.android ||
//         //               defaultTargetPlatform == TargetPlatform.iOS))
//         //         Row(
//         //           mainAxisSize: MainAxisSize.min,
//         //           mainAxisAlignment: MainAxisAlignment.start,
//         //           children: [
//         //             if (defaultTargetPlatform == TargetPlatform.iOS)
//         //               Column(
//         //                   mainAxisAlignment: MainAxisAlignment.start,
//         //                   crossAxisAlignment: CrossAxisAlignment.start,
//         //                   mainAxisSize: MainAxisSize.min,
//         //                   children: [
//         //                     const Text('Rendered by Flutter texture: '),
//         //                     Switch(
//         //                       value: _isUseFlutterTexture,
//         //                       onChanged: isJoined
//         //                           ? null
//         //                           : (changed) {
//         //                               setState(() {
//         //                                 _isUseFlutterTexture = changed;
//         //                               });
//         //                             },
//         //                     )
//         //                   ]),
//         //             if (defaultTargetPlatform == TargetPlatform.android)
//         //               Column(
//         //                   mainAxisAlignment: MainAxisAlignment.start,
//         //                   crossAxisAlignment: CrossAxisAlignment.start,
//         //                   mainAxisSize: MainAxisSize.min,
//         //                   children: [
//         //                     const Text('Rendered by Android SurfaceView: '),
//         //                     Switch(
//         //                       value: _isUseAndroidSurfaceView,
//         //                       onChanged: isJoined
//         //                           ? null
//         //                           : (changed) {
//         //                               setState(() {
//         //                                 _isUseAndroidSurfaceView = changed;
//         //                               });
//         //                             },
//         //                     ),
//         //                   ]),
//         //           ],
//         //         ),
//         //       const SizedBox(
//         //         height: 20,
//         //       ),
//         //       const Text('Channel Profile: '),
//         //       DropdownButton<ChannelProfileType>(
//         //         items: items,
//         //         value: _channelProfileType,
//         //         onChanged: isJoined
//         //             ? null
//         //             : (v) {
//         //                 setState(() {
//         //                   _channelProfileType = v!;
//         //                 });
//         //               },
//         //       ),
//         //       const SizedBox(
//         //         height: 20,
//         //       ),
//         //       BasicVideoConfigurationWidget(
//         //         rtcEngine: _engine,
//         //         title: 'Video Encoder Configuration',
//         //         setConfigButtonText: const Text(
//         //           'setVideoEncoderConfiguration',
//         //           style: TextStyle(fontSize: 10),
//         //         ),
//         //         onConfigChanged: (width, height, frameRate, bitrate) {
//         //           _engine
//         //               .setVideoEncoderConfiguration(VideoEncoderConfiguration(
//         //             dimensions: VideoDimensions(width: width, height: height),
//         //             frameRate: frameRate,
//         //             bitrate: bitrate,
//         //           ));
//         //         },
//         //       ),
//         //       const SizedBox(
//         //         height: 20,
//         //       ),
//         //       Row(
//         //         children: [
//         //           Expanded(
//         //             flex: 1,
//         //             child: ElevatedButton(
//         //               onPressed: isJoined ? _leaveChannel : _joinChannel,
//         //               child: Text('${isJoined ? 'Leave' : 'Join'} channel'),
//         //             ),
//         //           )
//         //         ],
//         //       ),
//         //       if (defaultTargetPlatform == TargetPlatform.android ||
//         //           defaultTargetPlatform == TargetPlatform.iOS) ...[
//         //         const SizedBox(
//         //           height: 20,
//         //         ),
//         //         ElevatedButton(
//         //           onPressed: _switchCamera,
//         //           child: Text('Camera ${switchCamera ? 'front' : 'rear'}'),
//         //         ),
//         //       ],
//         //     ],
//         //   );
//         // },
//       )
