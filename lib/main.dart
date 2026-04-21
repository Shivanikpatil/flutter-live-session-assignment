import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'injection_container.dart' as di;
import 'presentation/blocs/session/session_bloc.dart';
import 'presentation/blocs/session/session_event.dart';
import 'presentation/blocs/booking/booking_bloc.dart';
import 'presentation/views/home_screen.dart';

/// Entry point of the Flutter application.
/// Initializes dependencies and starts the app.
void main() async {
  // Ensures Flutter framework is ready before running async init code
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Dependency Injection (GetIt)
  await di.init();
  
  runApp(const MyApp());
}

/// Centralized color palette based on provided hex codes.
/// Consistent usage ensures a professional and unified brand identity.
class AppColors {
  static const Color primary = Color(0xFF7209B7);    // Deep Purple
  static const Color secondary = Color(0xFFF72585);  // Vibrant Pink (Live)
  static const Color deepBlue = Color(0xFF3A0CA3);   // Text/Heading Blue
  static const Color royalBlue = Color(0xFF4361EE);  // Primary Accent
  static const Color lightBlue = Color(0xFF4CC9F0);  // Secondary Accent
  static const Color background = Color(0xFFF8F9FA); // Light Gray Background
}

/// The root widget of the application.
/// Sets up the Theme and global BLoC providers.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider injects BLoCs at the top level so they are accessible everywhere
    return MultiBlocProvider(
      providers: [
        // SessionBloc handles the list and filtering of gym sessions
        BlocProvider(
          create: (_) => di.sl<SessionBloc>()..add(FetchSessions()),
        ),
        // BookingBloc handles user registrations and rejoint status
        BlocProvider(
          create: (_) => di.sl<BookingBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'FitLive India',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          // Modern Typography using Google Fonts
          textTheme: GoogleFonts.plusJakartaSansTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            tertiary: AppColors.royalBlue,
            surface: AppColors.background,
          ),
          scaffoldBackgroundColor: AppColors.background,
          // Global styling for AppBars
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.deepBlue,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.deepBlue,
            ),
          ),
          // Global styling for consistent buttons
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              textStyle: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Global styling for session cards
          cardTheme: CardThemeData(
            elevation: 2,
            shadowColor: AppColors.primary.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
