import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Navigation methods
  void navigateTo(String routeName) {
    navigatorKey.currentState?.pushNamed(routeName);
  }

  void replaceWith(String routeName) {
    navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() {
    navigatorKey.currentState?.pop();
  }

  void navigateToWithArgs(String routeName, Object? arguments) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  void resetTo(String routeName) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
          (route) => false,
    );
  }
}
