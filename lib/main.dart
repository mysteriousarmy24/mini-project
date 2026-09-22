import 'package:dotenv/dotenv.dart';
import 'package:expenz/routes/routing.dart';
import 'package:expenz/services/user_services.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dotEnv = DotEnv(includePlatformEnvironment: true)..load();
  if (dotEnv['APP_ID'] != null) {
    debugPrint('APP_ID loaded successfully');
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    await FirebaseAppCheck.instance.activate(
      providerAndroid: kDebugMode
          ? const AndroidDebugProvider()
          : const AndroidPlayIntegrityProvider(),
    );
  } on FirebaseException catch (e) {
    debugPrint(
      'Firebase App Check activation failed: ${e.message}. '
      'Enable App Check in Firebase Console and register the debug token.',
    );
  } catch (e) {
    debugPrint('Firebase App Check activation failed: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: UserServices.checkUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final hasUserName = snapshot.data ?? false;
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Expenz',
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Inter',
            scaffoldBackgroundColor: const Color.fromARGB(255, 210, 219, 255),
            colorScheme: ColorScheme.fromSeed(
              seedColor: kMainColor,
              brightness: Brightness.light,
              primary: kMainColor,
              secondary: kMainColorDark,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: kBackground,
              foregroundColor: kBlack,
              elevation: 0,
              centerTitle: true,
            ),
            cardTheme: CardThemeData(
              color: kSurface,
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),
          routerConfig: RouterClass(showMainScreen: hasUserName).router,
        );
      },
    );
  }
}
