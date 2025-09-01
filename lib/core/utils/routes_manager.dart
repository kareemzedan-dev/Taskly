import 'package:flutter/material.dart';
import 'package:taskly/features/auth/presentation/views/login_view.dart';
import 'package:taskly/features/auth/presentation/views/register_view.dart';
import 'package:taskly/features/welcome/presentation/views/welcome_view.dart';
 
class RoutesManager {
  
  static const String welcome = "welcome";
  static const String login = "login";
  static const String register="register";
  
 

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeView());
        case login:
          final role = settings.arguments as String;
        return MaterialPageRoute(builder: (_) =>   LoginView(role: role));
        case register:
         final role = settings.arguments as String;
        return MaterialPageRoute(builder: (_) =>   RegisterView(role: role));
  
      default:
        return MaterialPageRoute(builder: (_) => const Placeholder());
    }
  }
}
