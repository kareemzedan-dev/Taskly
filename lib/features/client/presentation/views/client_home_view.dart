import 'package:flutter/material.dart';
import 'package:taskly/core/widgets/custom_bottom_navigation_bar.dart';
import 'package:taskly/features/client/presentation/views/widgets/client_home_view_body.dart';

class ClientHomeView extends StatefulWidget {
  const ClientHomeView({super.key});

  @override
  State<ClientHomeView> createState() => _ClientHomeViewState();
}

class _ClientHomeViewState extends State<ClientHomeView> {
  int currentIndex = 0;

  List<Widget> items = [
    const ClientHomeViewBody(),
    Container(color: Colors.red),
    Container(color: Colors.green),
    Container(color: Colors.yellow),
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
