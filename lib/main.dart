import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:govimithura/Theme/theme_constant.dart';
import 'package:govimithura/providers/providers.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'theme/theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: Provider.of<ThemeManager>(context).themeMode,
      home: const SplashScreen(),
    );
  }
}
