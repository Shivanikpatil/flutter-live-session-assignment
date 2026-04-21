import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/chat_message.dart';
import 'live_session_event.dart';
import 'live_session_state.dart';

/// Business Logic Component (BLoC) for handling live session interactions.
/// Manages the real-time timer, community chat simulation, and participant count.
class LiveSessionBloc extends Bloc<LiveSessionEvent, LiveSessionState> {
  Timer? _timer;
  Timer? _chatTimer;
  final Random _random = Random();

  /// Mock data for Indian community chat feel.
  final List<String> _indianNames = [
    'Ananya', 'Rahul', 'Priya', 'Arjun', 'Ishani', 'Vikram', 'Kavya', 'Ishaan',
    'Meera', 'Rohan', 'Zara', 'Kabir', 'Sana', 'Aryan', 'Riya', 'Yash',
    'Aditi', 'Dev', 'Sneha', 'Karan'
  ];

  /// Realistic gym comments used for simulation.
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
    // Registering event handlers
    on<StartSession>(_onStartSession);
    on<TimerTicked>(_onTimerTicked);
    on<NewMessageReceived>(_onNewMessageReceived);
    on<SendMessageEvent>(_onSendMessage);
  }

  /// Initializes timers for the session broadcast and chat simulation.
  void _onStartSession(StartSession event, Emitter<LiveSessionState> emit) {
    // Session Timer: Ticks every 1 second
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(TimerTicked(timer.tick));
    });

    // Chat Simulator: Receives a new message every 5 seconds
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

  /// Updates the elapsed duration and simulates audience growth.
  void _onTimerTicked(TimerTicked event, Emitter<LiveSessionState> emit) {
    int newParticipantCount = state.participantCount;
    // Every 3 seconds, add 1-3 new viewers to the participant count
    if (event.duration % 3 == 0) {
      newParticipantCount += _random.nextInt(3) + 1;
    }
    
    emit(state.copyWith(
      secondsElapsed: event.duration,
      participantCount: newParticipantCount,
    ));
  }

  /// Appends a newly received simulated message to the state.
  void _onNewMessageReceived(NewMessageReceived event, Emitter<LiveSessionState> emit) {
    final updatedMessages = List<ChatMessage>.from(state.messages)..add(event.message);
    emit(state.copyWith(messages: updatedMessages));
  }

  /// Handles manual user input from the chat text field.
  /// [event.message] contains the text content sent by the user.
  void _onSendMessage(SendMessageEvent event, Emitter<LiveSessionState> emit) {
    final userMessage = ChatMessage(
      id: const Uuid().v4(),
      senderName: 'You', // Displayed with special styling in the UI
      message: event.message,
      timestamp: DateTime.now(),
    );
    final updatedMessages = List<ChatMessage>.from(state.messages)..add(userMessage);
    emit(state.copyWith(messages: updatedMessages));
  }

  /// Clean up resources when the BLoC is disposed to prevent memory leaks.
  @override
  Future<void> close() {
    _timer?.cancel();
    _chatTimer?.cancel();
    return super.close();
  }
}
