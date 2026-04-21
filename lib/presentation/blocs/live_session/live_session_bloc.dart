import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/chat_message.dart';
import 'live_session_event.dart';
import 'live_session_state.dart';

class LiveSessionBloc extends Bloc<LiveSessionEvent, LiveSessionState> {
  Timer? _timer;
  Timer? _chatTimer;
  final Random _random = Random();

  final List<String> _indianNames = [
    'Ananya', 'Rahul', 'Priya', 'Arjun', 'Ishani', 'Vikram', 'Kavya', 'Ishaan',
    'Meera', 'Rohan', 'Zara', 'Kabir', 'Sana', 'Aryan', 'Riya', 'Yash',
    'Aditi', 'Dev', 'Sneha', 'Karan'
  ];

  final List<String> _gymComments = [
    'Loving this workout! 🏋️‍♂️',
    'Great energy today! 🔥',
    'Feeling the burn! 💪',
    'Indian fitness is on another level! 🇮🇳',
    'Amazing session, coach! 🙌',
    'Can\'t wait for the next one!',
    'This HIIT is intense! 💦',
    'Best gym platform ever!',
    'Who else is joining from Mumbai? 🏙️',
    'Feeling stronger already!',
    'Killer move! 💀💪',
    'Super motivated right now!',
    'The instructor is awesome! 🌟',
    'Joining from Bangalore! ✌️',
    'Let\'s go team! 🚀'
  ];

  LiveSessionBloc() : super(const LiveSessionState(participantCount: 120)) {
    on<StartSession>(_onStartSession);
    on<TimerTicked>(_onTimerTicked);
    on<NewMessageReceived>(_onNewMessageReceived);
    on<SendMessageEvent>(_onSendMessage);
  }

  void _onStartSession(StartSession event, Emitter<LiveSessionState> emit) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(TimerTicked(timer.tick));
    });

    _chatTimer?.cancel();
    _chatTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final name = _indianNames[_random.nextInt(_indianNames.length)];
      final comment = _gymComments[_random.nextInt(_gymComments.length)];
      
      add(NewMessageReceived(ChatMessage(
        id: const Uuid().v4(),
        senderName: name,
        message: comment,
        timestamp: DateTime.now(),
      )));
    });
  }

  void _onTimerTicked(TimerTicked event, Emitter<LiveSessionState> emit) {
    // Simulate increasing viewers: add 1-3 viewers every few seconds
    int newParticipantCount = state.participantCount;
    if (event.duration % 3 == 0) {
      newParticipantCount += _random.nextInt(3) + 1;
    }
    
    emit(state.copyWith(
      secondsElapsed: event.duration,
      participantCount: newParticipantCount,
    ));
  }

  void _onNewMessageReceived(NewMessageReceived event, Emitter<LiveSessionState> emit) {
    final updatedMessages = List<ChatMessage>.from(state.messages)..add(event.message);
    emit(state.copyWith(messages: updatedMessages));
  }

  void _onSendMessage(SendMessageEvent event, Emitter<LiveSessionState> emit) {
    final userMessage = ChatMessage(
      id: const Uuid().v4(),
      senderName: 'You',
      message: event.message,
      timestamp: DateTime.now(),
    );
    final updatedMessages = List<ChatMessage>.from(state.messages)..add(userMessage);
    emit(state.copyWith(messages: updatedMessages));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _chatTimer?.cancel();
    return super.close();
  }
}
