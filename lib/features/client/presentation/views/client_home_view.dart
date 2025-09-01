import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/client/presentation/views/widgets/client_home_view_body.dart';

class ClientHomeView extends StatefulWidget {
    ClientHomeView({super.key});

  @override
  State<ClientHomeView> createState() => _ClientHomeViewState();
}

class _ClientHomeViewState extends State<ClientHomeView> {
  int currentIndex = 0;

  List<Widget> items = [
      ClientHomeViewBody(),
      Container(color: Colors.red,),
      Container(color: Colors.green,),
      Container(color: Colors.yellow,),
  
  ];

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child:  items[currentIndex]),
       

      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
 

  BottomNavigationBar CustomBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
      onTap: (index) {
     setState(() {
          currentIndex = index;
        });
      },
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.transparent,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.transparent,
      ),
      selectedItemColor: ColorsManager.primary,
      unselectedItemColor: Colors.black.withOpacity(0.5),
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            Assets.assetsImagesHome4561540,
            color: Colors.black.withOpacity(0.5),
            height: 24.h,
            width: 24.w,
          ),
          activeIcon: Image.asset(
            Assets.assetsImagesHome4561540,
            color: ColorsManager.primary,
             height: 24.h,
            width: 24.w,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            Assets.assetsImagesJobBoard18989826,
            color: Colors.black.withOpacity(0.5),
             height: 24.h,
            width: 24.w,
          ),
          activeIcon: Image.asset(
            Assets.assetsImagesJobBoard18989826,
            color: ColorsManager.primary,
             height: 24.h,
            width: 24.w,
          ),
          label: 'My Jobs',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            Assets.assetsImagesChat6431892,
            color: Colors.black.withOpacity(0.5),
             height: 24.h,
            width: 24.w,
          ),
          activeIcon: Image.asset(
            Assets.assetsImagesChat6431892,
            color: ColorsManager.primary,
             height: 24.h,
            width: 24.w,
          ),
          label: 'Messages',
        ),
            BottomNavigationBarItem(
          icon: Image.asset(
            Assets.assetsImagesUser12366536,
            color: Colors.black.withOpacity(0.5),
             height: 24.h,
            width: 24.w,
          ),
          activeIcon: Image.asset(
            Assets.assetsImagesUser12366536,
            color: ColorsManager.primary,
             height: 24.h,
            width: 24.w,
          ),
          label: 'Profile',
        ),
      ],
    );
  }}