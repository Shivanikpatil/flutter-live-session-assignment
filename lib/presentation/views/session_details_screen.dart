import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../../../domain/entities/session.dart';
import '../blocs/booking/booking_bloc.dart';
import '../blocs/booking/booking_event.dart';
import '../blocs/booking/booking_state.dart';
import '../blocs/session/session_bloc.dart';
import '../blocs/session/session_event.dart';
import '../blocs/session/session_state.dart';
import 'live_session_screen.dart';

class SessionDetailsScreen extends StatelessWidget {
  final Session session;

  const SessionDetailsScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          context.read<SessionBloc>().add(FetchSessions());
        } else if (state is BookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.secondary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          Session currentSession = session;
          if (state is SessionLoaded) {
            try {
              currentSession = state.sessions.firstWhere((s) => s.id == session.id);
            } catch (_) {}
          }

          final bool isLive = currentSession.status.toLowerCase() == 'live';

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: 'session_image_${currentSession.id}',
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(currentSession.imageUrl, fit: BoxFit.cover),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.4),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.3),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isLive ? AppColors.secondary : AppColors.royalBlue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                currentSession.status.toUpperCase(),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.lightBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                currentSession.category,
                                style: const TextStyle(color: AppColors.royalBlue, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          currentSession.title,
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.deepBlue),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const CircleAvatar(radius: 18, backgroundColor: AppColors.lightBlue),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Session by', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                Text(
                                  currentSession.instructor,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.deepBlue),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'About Session',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.deepBlue),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentSession.description,
                          style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.6),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              InfoRow(
                                icon: Icons.calendar_today_rounded,
                                label: 'Date',
                                value: DateFormat('EEEE, MMM dd').format(currentSession.startTime),
                              ),
                              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                              InfoRow(
                                icon: Icons.access_time_filled_rounded,
                                label: 'Time',
                                value: DateFormat('hh:mm a').format(currentSession.startTime),
                              ),
                              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                              InfoRow(
                                icon: Icons.timer_rounded,
                                label: 'Duration',
                                value: '${currentSession.duration} minutes',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomSheet: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
              ),
              child: _buildActionButton(context, currentSession),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, Session currentSession) {
    if (currentSession.status == 'live') {
      final String buttonText = currentSession.hasJoined ? 'REJOIN SESSION' : 'JOIN LIVE NOW';
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        onPressed: () {
          if (!currentSession.hasJoined) {
            context.read<BookingBloc>().add(JoinSessionEvent(currentSession.id));
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LiveSessionScreen(session: currentSession)),
          ).then((_) => context.read<SessionBloc>().add(FetchSessions()));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle_outline),
            const SizedBox(width: 12),
            Text(buttonText),
          ],
        ),
      );
    }

    if (currentSession.isBooked) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green[200]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle_outline, color: Colors.green),
            SizedBox(width: 12),
            Text('ALREADY REGISTERED', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    return ElevatedButton(
      onPressed: () => context.read<BookingBloc>().add(BookSessionEvent(currentSession.id)),
      child: const Text('RESERVE MY SPOT'),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 22, color: AppColors.royalBlue),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.deepBlue)),
          ],
        ),
      ],
    );
  }
}
