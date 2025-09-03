import 'package:flutter/material.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/empty_state_animation.dart';

class MyJobsTabViewBody extends StatelessWidget {
  const MyJobsTabViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: TabBarView(
              children: [
                Center(
                  child: EmptyStateAnimation(
                    animationPath: 'assets/lotties/Loading.json',
                    message: 'No pending Offers',
                  ),
                ),
                Center(
                  child: EmptyStateAnimation(
                    animationPath: 'assets/lotties/Progress.json',
                    message: 'No accepted Offers',
                  ),
                ),
                Center(
                  child: EmptyStateAnimation(
                    animationPath: 'assets/lotties/Success.json',
                    message: 'No completed projects yet',
                  ),
                ),
                Center(
                  child: EmptyStateAnimation(
                    animationPath: 'assets/lotties/cancelled.json',
                    message: 'No rejected offers',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
