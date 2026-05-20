import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/registrar_alumno_screen.dart';
import 'screens/listar_alumnos_screen.dart';
import 'screens/preguntas_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.bg,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const GestionEscolarApp());
}

class GestionEscolarApp extends StatelessWidget {
  const GestionEscolarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduGestión',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.light(
          primary:    AppColors.primary,
          secondary:  AppColors.primaryMid,
          surface:    AppColors.white,
          error:      AppColors.error,
          onPrimary:  Colors.white,
          onSurface:  AppColors.textDark,
          onSecondary: Colors.white,
        ),
        // Transiciones suaves tipo iOS en todas las plataformas
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS:     CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux:   CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS:   CupertinoPageTransitionsBuilder(),
          },
        ),
        splashFactory:    NoSplash.splashFactory,
        highlightColor:   Colors.transparent,
        dividerColor:     AppColors.border,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bg,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.primary),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/':          (_) => const LoginScreen(),
        '/home':      (_) => const HomeScreen(),
        '/perfil':    (_) => const PerfilScreen(),
        '/registrar': (_) => const RegistrarAlumnoScreen(),
        '/listar':    (_) => const ListarAlumnosScreen(),
        '/preguntas': (_) => const PreguntasScreen(),
      },
    );
  }
}
