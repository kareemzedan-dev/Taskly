import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskly/core/components/custom_bottom_navigation_bar.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/view_model/client_home_view_model/client_home_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/home_tab_view.dart';
import 'package:taskly/features/messages/presentation/pages/user_messages_tab_view.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/my_jobs_tab_view.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/profile_view.dart';

class ClientHomeView extends StatefulWidget {
  final int initialIndex;
  const ClientHomeView({super.key, this.initialIndex = 0});

  @override
  State<ClientHomeView> createState() => _ClientHomeViewState();
}
class _ClientHomeViewState extends State<ClientHomeView> {
  late int currentIndex;
  late final List<Widget> items;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;

    items = [
      ChangeNotifierProvider(
        create: (_) => ClientHomeViewModel(),
        child: const HomeTabView(),
      ),
      MyJobsTabView(),
      const UserMessagesTabView(),
      const ClientProfileViewTab(),
    ];
  }

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
