import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/config/routes/routes_manager.dart';

import '../../../../../core/utils/constants_manager.dart';
import '../../../../../core/utils/strings_manager.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  var token = SharedPrefHelper.getString(StringsManager.tokenKey);
  var role = SharedPrefHelper.getString(StringsManager.roleKey);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // Move Future.delayed here
    Future.delayed(
        const Duration(seconds: ConstantsManager.splashDelay), () {
      if (!mounted) return;
      if (token != null) {
        if (role == StringsManager.freelancerRole) {
          Navigator.pushReplacementNamed(context, RoutesManager.freelancerHome);
        } else {
          Navigator.pushReplacementNamed(context, RoutesManager.clientHome);
        }
      } else {
        Navigator.pushReplacementNamed(context, RoutesManager.welcome);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds:  ConstantsManager.splashDelay), () {
      if (!mounted) return;
      if (token != null) {
        if (role == StringsManager.freelancerRole) {
          Navigator.pushReplacementNamed(context, RoutesManager.freelancerHome);
        } else {
          Navigator.pushReplacementNamed(context, RoutesManager.clientHome);
        }
      } else {
        Navigator.pushReplacementNamed(context, RoutesManager.welcome);
      }
    });
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Text(
                "Taskly",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 50.sp,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
