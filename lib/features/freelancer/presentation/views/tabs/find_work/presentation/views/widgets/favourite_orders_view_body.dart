import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/empty_state_animation.dart';

class FavouriteOrdersViewBody extends StatelessWidget {
  const FavouriteOrdersViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(padding: const EdgeInsets.all(16),child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child:  EmptyStateAnimation(
            animationPath: 'assets/lotties/Loading.json',
            message: 'No Favourite orders yet',
          ),
        ),
    
    
      ],)
    );
  }
}