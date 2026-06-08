import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'inactivity_detector.dart';
import 'fcm_service.dart';
import 'secure_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase (requiere google-services.json en Android)
  try {
    await Firebase.initializeApp();
    await FCMService.initialize();
  } catch (e) {
    debugPrint('Firebase no inicializado: $e (Asegúrate de agregar google-services.json)');
  }

  // Inicializar datos sensibles de prueba
  await SecureStorageService.initializeDefaultData();

  runApp(const SecureAppWrapper());
}

class SecureAppWrapper extends StatelessWidget {
  const SecureAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalKey<NavigatorState>();

    return InactivityDetector(
      timeout: const Duration(seconds: 30), // 30 segundos para pruebas, ajustar según necesidad
      onTimeout: () {
        debugPrint('[Inactivity] Tiempo de inactividad alcanzado. Bloqueando...');
        navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (route) => false);
      },
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Acceso Seguro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0A1628),
            brightness: Brightness.dark,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}