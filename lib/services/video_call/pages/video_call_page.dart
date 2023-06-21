import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../componants/basic_video_configration_widget.dart';
import '../componants/example_actions_widget.dart';
import '../componants/log_sink.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({Key? key}) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

const String appId = '1ed862ccc609403c8eec5d2f34e8565a';
const String channelId = 'BETACall';
const int uID = 0;
const String token =
    '007eJxTYHhy9db1y8vPpGclGh9tjFwuwlq4MmyV4MTg/SJRNWweLw4rMBimpliYGSUnJ5sZWJoYGCdbpKYmm6YYpRmbpFqYmpkmcu3rSWkIZGQ4khbJyMgAgSA+B4OTa4ijc2JODgMDABz8IOE=';

class _VideoCallPageState extends State<VideoCallPage> {
  late final RtcEngine _engine;

  bool isJoined = false, switchCamera = true, switchRender = true;
  Set<int> remoteUid = {};
  late TextEditingController _controller;
  bool _isUseFlutterTexture = false;
  bool _isUseAndroidSurfaceView = false;
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
        logSink.log('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        logSink.log(
            '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
        logSink.log(
            '[onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');
        setState(() {
          remoteUid.add(rUid);
        });
      },
      onUserOffline:
          (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
        logSink.log(
            '[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');
        setState(() {
          remoteUid.removeWhere((element) => element == rUid);
        });
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        logSink.log(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        setState(() {
          isJoined = false;
          remoteUid.clear();
        });
      },
    ));

    await _engine.enableVideo();
  }

  Future<void> _joinChannel() async {
    await _engine.joinChannel(
      token: token,
      channelId: _controller.text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExampleActionsWidget(
        displayContentBuilder: (context, isLayoutHorizontal) {
          return Stack(
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
                      (e) => SizedBox(
                        width: 120,
                        height: 120,
                        child: AgoraVideoView(
                          controller: VideoViewController.remote(
                            rtcEngine: _engine,
                            canvas: VideoCanvas(uid: e),
                            connection:
                                RtcConnection(channelId: _controller.text),
                            useFlutterTexture: _isUseFlutterTexture,
                            useAndroidSurfaceView: _isUseAndroidSurfaceView,
                          ),
                        ),
                      ),
                    )),
                  ),
                ),
              )
            ],
          );
        },
        actionsBuilder: (context, isLayoutHorizontal) {
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

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'Channel ID'),
              ),
              if (!kIsWeb &&
                  (defaultTargetPlatform == TargetPlatform.android ||
                      defaultTargetPlatform == TargetPlatform.iOS))
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (defaultTargetPlatform == TargetPlatform.iOS)
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Rendered by Flutter texture: '),
                            Switch(
                              value: _isUseFlutterTexture,
                              onChanged: isJoined
                                  ? null
                                  : (changed) {
                                      setState(() {
                                        _isUseFlutterTexture = changed;
                                      });
                                    },
                            )
                          ]),
                    if (defaultTargetPlatform == TargetPlatform.android)
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Rendered by Android SurfaceView: '),
                            Switch(
                              value: _isUseAndroidSurfaceView,
                              onChanged: isJoined
                                  ? null
                                  : (changed) {
                                      setState(() {
                                        _isUseAndroidSurfaceView = changed;
                                      });
                                    },
                            ),
                          ]),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              const Text('Channel Profile: '),
              DropdownButton<ChannelProfileType>(
                items: items,
                value: _channelProfileType,
                onChanged: isJoined
                    ? null
                    : (v) {
                        setState(() {
                          _channelProfileType = v!;
                        });
                      },
              ),
              const SizedBox(
                height: 20,
              ),
              BasicVideoConfigurationWidget(
                rtcEngine: _engine,
                title: 'Video Encoder Configuration',
                setConfigButtonText: const Text(
                  'setVideoEncoderConfiguration',
                  style: TextStyle(fontSize: 10),
                ),
                onConfigChanged: (width, height, frameRate, bitrate) {
                  _engine.setVideoEncoderConfiguration(VideoEncoderConfiguration(
                    dimensions: VideoDimensions(width: width, height: height),
                    frameRate: frameRate,
                    bitrate: bitrate,
                  ));
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: isJoined ? _leaveChannel : _joinChannel,
                      child: Text('${isJoined ? 'Leave' : 'Join'} channel'),
                    ),
                  )
                ],
              ),
              if (defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform == TargetPlatform.iOS) ...[
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _switchCamera,
                  child: Text('Camera ${switchCamera ? 'front' : 'rear'}'),
                ),
              ],
            ],
          );
        },
      ),
    );
    // if (!_isInit) return Container();
  }
}
