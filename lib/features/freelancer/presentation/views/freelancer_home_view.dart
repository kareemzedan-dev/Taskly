import 'package:flutter/material.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/widgets/custom_bottom_navigation_bar.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/home_tab_view.dart';
import 'package:taskly/features/client/presentation/views/tabs/messages/presentation/views/messages_tab_view.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/my_jobs_tab_view.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/profile_view.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/find_work_tab_view.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/messages/presentation/views/messages_tab_view.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/my_jobs/presentation/views/my_jobs_tab_view.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/profile/presentation/views/profile_view.dart';

class FreelancerHomeView extends StatefulWidget {
  const FreelancerHomeView({super.key});

  @override
  State<FreelancerHomeView> createState() => _FreelancerHomeView();
}

class _FreelancerHomeView extends State<FreelancerHomeView> {
  int currentIndex = 0;

  List<Widget> items = [
   FreelancerHomeTabView(),
  FreelancerMyJobsTabView(),
    Container(color: Colors.black,),
    Container(color: Colors.yellow,),
 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: items[currentIndex]),
      bottomNavigationBar: CustomBottomNavigationBar(
        firstTabName: "Find Work",
        firstTabicon: Assets.assetsImagesWork,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
