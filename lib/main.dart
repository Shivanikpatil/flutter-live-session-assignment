import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'injection_container.dart' as di;
import 'presentation/blocs/session/session_bloc.dart';
import 'presentation/blocs/session/session_event.dart';
import 'presentation/blocs/booking/booking_bloc.dart';
import 'presentation/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class AppColors {
  static const Color primary = Color(0xFF7209B7);
  static const Color secondary = Color(0xFFF72585);
  static const Color deepBlue = Color(0xFF3A0CA3);
  static const Color royalBlue = Color(0xFF4361EE);
  static const Color lightBlue = Color(0xFF4CC9F0);
  static const Color background = Color(0xFFF8F9FA);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<SessionBloc>()..add(FetchSessions()),
        ),
        BlocProvider(
          create: (_) => di.sl<BookingBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'FitLive India',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
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
