import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../main.dart';
import '../blocs/session/session_bloc.dart';
import '../blocs/session/session_event.dart';
import '../blocs/session/session_state.dart';
import '../widgets/session_card.dart';
import 'session_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              title: const Text(
                'FitLive India',
                style: TextStyle(
                  color: AppColors.deepBlue,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
              centerTitle: false,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  backgroundColor: AppColors.lightBlue.withOpacity(0.2),
                  child: const Icon(Icons.person_outline, color: AppColors.royalBlue),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What would you like to do today?',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const CategoryFilter(),
                ],
              ),
            ),
          ),
          BlocBuilder<SessionBloc, SessionState>(
            builder: (context, state) {
              if (state is SessionLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is SessionLoaded) {
                final sessions = state.filteredSessions;
                if (sessions.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('No sessions found in this category')),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final session = sessions[index];
                        return SessionCard(
                          session: session,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SessionDetailsScreen(session: session),
                              ),
                            );
                          },
                        );
                      },
                      childCount: sessions.length,
                    ),
                  ),
                );
              } else if (state is SessionError) {
                return SliverFillRemaining(
                  child: Center(child: Text(state.message)),
                );
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Live', 'Yoga', 'Fitness', 'Meditation'];
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        final selectedCategory = (state is SessionLoaded) ? state.selectedCategory : 'All';
        return SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category == selectedCategory;
              final isLive = category == 'Live';
              
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: () {
                    context.read<SessionBloc>().add(FilterSessions(category));
                  },
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? (isLive ? AppColors.secondary : AppColors.primary) 
                          : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: isSelected 
                        ? [BoxShadow(
                            color: (isLive ? AppColors.secondary : AppColors.primary).withOpacity(0.3), 
                            blurRadius: 8, 
                            offset: const Offset(0, 4)
                          )]
                        : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                      border: Border.all(
                        color: isSelected 
                            ? (isLive ? AppColors.secondary : AppColors.primary) 
                            : Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        if (isLive) ...[
                          Icon(
                            Icons.circle, 
                            size: 8, 
                            color: isSelected ? Colors.white : AppColors.secondary
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
