// ignore_for_file: unused_field

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/handlers/icon_handler.dart';
import 'package:flutter_project_base/utilities/extensions/timer_formatter.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView(
      {super.key,
      required this.type,
      this.assetPath,
      this.filePath,
      this.networkUrl});
  final VideoType type;
  final String? networkUrl, assetPath, filePath;
  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _controller;
  _checkPathes(String? value) => value != null;

  void _initVideo() {
    switch (widget.type) {
      case VideoType.network:
        if (_checkPathes(widget.networkUrl)) {
          _controller = VideoPlayerController.network(widget.networkUrl!)
            ..initialize().then((value) => setState(() {}));
        } else {
          // show error
        }
        break;
      case VideoType.asset:
        if (_checkPathes(widget.assetPath)) {
          _controller = VideoPlayerController.asset(widget.assetPath!)
            ..initialize().then((value) => setState(() {}));
        } else {
          // show error
        }
        break;
      case VideoType.file:
        if (_checkPathes(widget.filePath)) {
          _controller = VideoPlayerController.file(File(widget.filePath!))
            ..initialize().then((value) => setState(() {}));
        } else {
          // show error
        }
        break;
      default:
    }
    _controller.addListener(() => setState(() {}));
  }

  bool showButtons = true;
  final double _btnWidth = 36, _btnheight = 36;
  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            alignment: Alignment.center,
            children: [
              // Video view
              // ============================================
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),

              // video buttons
              // ============================================
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: GestureDetector(
                  onTap: () => setState(() => showButtons = !showButtons),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    color: !showButtons
                        ? Colors.transparent
                        : Colors.black.withOpacity(.4),
                    child: Visibility(
                      visible: showButtons,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async => _controller.value.isPlaying
                                ? await _controller
                                    .seekTo(Duration(
                                        seconds: _controller
                                                .value.position.inSeconds -
                                            10))
                                    .then((value) => setState(() {}))
                                : null,
                            child: drawSvgIcon("video_icons/backward_10",
                                width: _btnheight,
                                height: _btnheight,
                                iconColor: Colors.white),
                          ),
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 400),
                            crossFadeState: _controller.value.isPlaying
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            firstChild: GestureDetector(
                              onTap: () async => await _controller.play().then(
                                  (value) =>
                                      setState(() => showButtons = false)),
                              child: drawSvgIcon("video_icons/play_bold",
                                  width: _btnheight,
                                  height: _btnheight,
                                  iconColor: Colors.white),
                            ),
                            secondChild: GestureDetector(
                              onTap: () async => await _controller.pause().then(
                                  (value) =>
                                      setState(() => showButtons = true)),
                              child: drawSvgIcon("video_icons/pause_bold",
                                  width: _btnheight,
                                  height: _btnheight,
                                  iconColor: Colors.white),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async => _controller.value.isPlaying
                                ? await _controller
                                    .seekTo(Duration(
                                        seconds: _controller
                                                .value.position.inSeconds +
                                            10))
                                    .then((value) => setState(() {}))
                                : null,
                            child: drawSvgIcon("video_icons/forward_10",
                                width: _btnheight,
                                height: _btnheight,
                                iconColor: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // video progress
              // ============================================
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Visibility(
                  visible: showButtons,
                  child: VideoProgress(
                    onChanged: (value) async {
                      _controller
                          .seekTo(Duration(seconds: value.toInt()))
                          .then((value) => setState(() {}));
                    },
                    currentValue: _controller.value.position.inSeconds,
                    duration: _controller.value.duration.inSeconds,
                  ),
                ),
              )
            ],
          )
        : Container();
  }

  //=====================================================
  //=====================================================
  //=====================================================

  @override
  void initState() {
    _initVideo();
    super.initState();
  }
}

enum VideoType { asset, network, file }

class VideoProgress extends StatelessWidget {
  const VideoProgress(
      {super.key,
      required this.onChanged,
      required this.currentValue,
      required this.duration});
  final Function(num value) onChanged;
  final num currentValue, duration;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider.adaptive(
          value: currentValue.toDouble(),
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Colors.blueGrey[50],
          onChanged: onChanged,
          max: duration.toDouble(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentValue.toTimerFormatte(),
                textDirection: TextDirection.ltr,
              ),
              Text(
                duration.toTimerFormatte(),
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
