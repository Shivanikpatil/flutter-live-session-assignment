import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/session_model.dart';

abstract class SessionRemoteDataSource {
  Future<List<SessionModel>> getSessions();
}

class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {
  @override
  Future<List<SessionModel>> getSessions() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      final String response = await rootBundle.loadString('assets/data/sessions.json');
      final List<dynamic> data = json.decode(response);
      final List<SessionModel> sessions = data.map((json) => SessionModel.fromJson(json)).toList();
      
      // Make dates dynamic relative to current time
      final now = DateTime.now();
      final random = Random();
      
      return sessions.map((session) {
        DateTime dynamicDate;
        String status = session.status.toLowerCase();
        
        if (status == 'live') {
          // Current time for live sessions
          dynamicDate = now.subtract(Duration(minutes: random.nextInt(15)));
        } else if (status == 'upcoming') {
          // Future 2-6 days
          dynamicDate = now.add(Duration(
            days: 2 + random.nextInt(5), 
            hours: random.nextInt(12),
            minutes: random.nextInt(60),
          ));
        } else {
          // Completed: Past 2-6 days
          dynamicDate = now.subtract(Duration(
            days: 2 + random.nextInt(5), 
            hours: random.nextInt(12),
            minutes: random.nextInt(60),
          ));
        }
        
        return session.copyWith(startTime: dynamicDate);
      }).toList();
    } catch (e) {
      throw Exception('Failed to load sessions from mock API');
    }
  }
}
