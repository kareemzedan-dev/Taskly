import 'package:flutter/material.dart';
import 'package:taskly/features/auth/presentation/views/login_view.dart';
import 'package:taskly/features/auth/presentation/views/register_view.dart';
import 'package:taskly/features/client/presentation/views/client_home_view.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/order_view.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/client_home_tab_view_body.dart';
import 'package:taskly/features/client/presentation/views/tabs/messages/presentation/views/chat_view.dart';
import 'package:taskly/features/freelancer/presentation/views/freelancer_home_view.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/job_details_view.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/send_offer_view.dart';
import 'package:taskly/features/splash/presentation/views/splash_view.dart';
import 'package:taskly/features/welcome/presentation/views/welcome_view.dart';
 
class RoutesManager {
  
  static const String splash = "/";
  static const String welcome = "welcome";
  static const String login = "login";
  static const String register="register";
  static const String clientHome = "clientHome";
  static const String freelancerHome = "freelancerHome";
  static const String serviceOrderView = "serviceOrderView";
  static const String chatView = "chatView";
  static const String jobDetailsView = "jobDetailsView";
  static const String sendOfferView = "sendOfferView";
  
 

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeView());
        case login:
          final role = settings.arguments as String;
        return MaterialPageRoute(builder: (_) =>   LoginView(role: role));
        case register:
         final role = settings.arguments as String;
        return MaterialPageRoute(builder: (_) =>   RegisterView(role: role));
        case clientHome:
        return MaterialPageRoute(builder: (_) =>   ClientHomeView());
        case freelancerHome:
        return MaterialPageRoute(builder: (_) =>   FreelancerHomeView());
        case serviceOrderView:
        return MaterialPageRoute(builder: (_) =>   OrderView());
        case chatView:
        return MaterialPageRoute(builder: (_) =>   ChatView());
        case jobDetailsView:
        return MaterialPageRoute(builder: (_) =>   JobDetailsView());
        case sendOfferView:
        return MaterialPageRoute(builder: (_) =>   SendOfferView());
  
      default:
        return MaterialPageRoute(builder: (_) => const Placeholder());
    }
  }
}
