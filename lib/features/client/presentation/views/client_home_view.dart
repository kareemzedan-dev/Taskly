import 'package:flutter/material.dart';
import 'package:taskly/core/widgets/custom_bottom_navigation_bar.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/home_tab_view.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/client_home_tab_view_body.dart';
import 'package:taskly/features/client/presentation/views/tabs/messages/presentation/views/messages_tab_view.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/profile_view.dart';

class ClientHomeView extends StatefulWidget {
  const ClientHomeView({super.key});

  @override
  State<ClientHomeView> createState() => _ClientHomeViewState();
}

class _ClientHomeViewState extends State<ClientHomeView> {
  int currentIndex = 0;

  List<Widget> items = [
    const HomeTabView(),
    Container(color: Colors.red),
   MessagesTabView(),
  ProfileViewTab()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: items[currentIndex]),
      bottomNavigationBar: CustomBottomNavigationBar(
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
