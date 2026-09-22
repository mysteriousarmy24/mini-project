import 'package:expenz/Screens/auth/login_page.dart';
import 'package:expenz/Screens/auth/register_page.dart';
import 'package:expenz/Screens/main_screen.dart';
import 'package:expenz/Screens/onboard_screens.dart';
import 'package:expenz/widgets/wrapper.dart';
import 'package:go_router/go_router.dart';

class RouterClass {
  final bool showMainScreen;
  late final GoRouter router;

  RouterClass({required this.showMainScreen}) {
    router = GoRouter(
      routes: [
        GoRoute(
          path: "/",
          builder: (context, state) => Wrapper(showMainScreen: showMainScreen),
        ),
        GoRoute(
          path: "/onboarding",
          builder: (context, state) => const OnboardScreens(),
        ),
        GoRoute(path: "/main", builder: (context, state) => const MainScreen()),
        GoRoute(path: "/register", builder: (context, state) => RegisterPage()),
        GoRoute(path: "/login", builder: (context, state) => LoginPage()),
      ],
    );
  }
}
