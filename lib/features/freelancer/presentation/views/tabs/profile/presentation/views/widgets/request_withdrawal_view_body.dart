import 'package:flutter/material.dart';
import 'package:taskly/core/components/custom_tab_bar.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/profile/presentation/views/widgets/withdrawal_history_tab_content.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/profile/presentation/views/widgets/withdrawal_request_tab_content.dart';

class RequestWithdrawalViewBody extends StatelessWidget {
  const RequestWithdrawalViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            CustomTabBar(tabs: ['Withdrawal Request', 'Withdrawal History']),
            Expanded(
              child: TabBarView(
                children: [
                  WithdrawalRequestTabContent(),
                 WithdrawalHistoryTabContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 