import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import '../../domain/entities/session.dart';
import '../../main.dart';
import '../blocs/live_session/live_session_bloc.dart';
import '../blocs/live_session/live_session_event.dart';
import '../blocs/live_session/live_session_state.dart';

class LiveSessionScreen extends StatefulWidget {
  final Session session;

  const LiveSessionScreen({super.key, required this.session});

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen> with WidgetsBindingObserver {
  late VideoPlayerController _videoController;
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    const videoUrl = 'https://videos.pexels.com/video-files/4367540/4367540-sd_640_360_30fps.mp4';
    _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    
    try {
      await _videoController.initialize();
      if (mounted) {
        setState(() {});
        _videoController.play();
        _videoController.setLooping(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chatController.dispose();
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_videoController.value.isInitialized) return;
    if (state == AppLifecycleState.paused) {
      _videoController.pause();
    } else if (state == AppLifecycleState.resumed) {
      _videoController.play();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LiveSessionBloc()..add(StartSession()),
      child: BlocListener<LiveSessionBloc, LiveSessionState>(
        listenWhen: (previous, current) => previous.messages.length != current.messages.length,
        listener: (context, state) => _scrollToBottom(),
        child: Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.black,
                        child: Center(
                          child: _hasError
                              ? const VideoErrorWidget()
                              : _videoController.value.isInitialized
                                  ? AspectRatio(
                                      aspectRatio: _videoController.value.aspectRatio,
                                      child: VideoPlayer(_videoController),
                                    )
                                  : const CircularProgressIndicator(color: AppColors.lightBlue),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black.withOpacity(0.6), Colors.transparent, Colors.black.withOpacity(0.4)],
                            ),
                          ),
                        ),
                      ),
                      // Top Overlay Controls with Increasing Viewers
                      Positioned(
                        top: 20,
                        left: 20,
                        right: 20,
                        child: BlocBuilder<LiveSessionBloc, LiveSessionState>(
                          builder: (context, state) {
                            return Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.circle, size: 8, color: Colors.white),
                                      const SizedBox(width: 8),
                                      const Text('LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                      const SizedBox(width: 12),
                                      Text(state.formattedDuration, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.white10),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.remove_red_eye, size: 14, color: AppColors.lightBlue),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${state.participantCount}', 
                                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                CircleAvatar(
                                  backgroundColor: Colors.black26,
                                  child: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      // Instructor Overlay with Today's Date
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.session.title,
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  DateFormat('EEE, MMM dd').format(DateTime.now()),
                                  style: const TextStyle(color: AppColors.lightBlue, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                const Text('•', style: TextStyle(color: Colors.white54)),
                                const SizedBox(width: 8),
                                Text(
                                  'Coach ${widget.session.instructor}',
                                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Chat Area
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(2))),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('Live Community Chat', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.deepBlue, fontSize: 15)),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: BlocBuilder<LiveSessionBloc, LiveSessionState>(
                            builder: (context, state) {
                              return ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                itemCount: state.messages.length,
                                itemBuilder: (context, index) {
                                  final msg = state.messages[index];
                                  final isMe = msg.senderName == 'You';
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (!isMe)
                                          CircleAvatar(
                                            radius: 14,
                                            backgroundColor: AppColors.lightBlue.withOpacity(0.2),
                                            child: Text(msg.senderName[0], style: const TextStyle(fontSize: 10, color: AppColors.royalBlue, fontWeight: FontWeight.bold)),
                                          ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(msg.senderName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: isMe ? AppColors.primary : Colors.grey[600])),
                                              const SizedBox(height: 2),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                                decoration: BoxDecoration(
                                                  color: isMe ? AppColors.primary.withOpacity(0.05) : Colors.grey[50],
                                                  borderRadius: BorderRadius.circular(16).copyWith(topLeft: Radius.zero),
                                                ),
                                                child: Text(msg.message, style: TextStyle(color: Colors.grey[800], fontSize: 13)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        // Chat Input
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Builder(
                                  builder: (chatContext) => TextField(
                                    controller: _chatController,
                                    decoration: InputDecoration(
                                      hintText: 'Say something...',
                                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    ),
                                    onSubmitted: (val) {
                                      if (val.trim().isNotEmpty) {
                                        chatContext.read<LiveSessionBloc>().add(SendMessageEvent(val));
                                        _chatController.clear();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Builder(
                                builder: (chatContext) => InkWell(
                                  onTap: () {
                                    if (_chatController.text.trim().isNotEmpty) {
                                      chatContext.read<LiveSessionBloc>().add(SendMessageEvent(_chatController.text));
                                      _chatController.clear();
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VideoErrorWidget extends StatelessWidget {
  const VideoErrorWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.cloud_off_rounded, color: AppColors.lightBlue, size: 60),
        const SizedBox(height: 16),
        const Text('Stream Connection Lost', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Please check your network and try again', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14)),
      ],
    );
  }
}
