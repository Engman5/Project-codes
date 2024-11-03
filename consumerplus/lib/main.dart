import 'package:consumerplus/screens/auth/login_screen.dart';
import 'package:consumerplus/screens/details_collection_screen.dart';
import 'package:consumerplus/screens/permission_screen.dart';
import 'package:consumerplus/services/service_provider.dart';
import 'package:consumerplus/utils/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ConsumerPlusApp());
}

class ConsumerPlusApp extends StatelessWidget {
  const ConsumerPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ServiceProvider(
      child: MaterialApp(
        title: 'Electricity Consumption Estimator',
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        routes: {
          '/loginScreen': (context) => const LoginScreen(),
          '/permissionsScreen': (context) => const PermissionRequestScreen(),
          '/detailsCollectionScreen': (context) => const DetailsCollectionScreen(),
        },
      ),
    );
  }
}