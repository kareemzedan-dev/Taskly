import 'package:flutter/material.dart';

class MyJobsTabViewBody extends StatelessWidget {
  const MyJobsTabViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return   SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TabBarView(
                  children: [
        Center(child: Text("No pending jobs")),
        Center(child: Text("No jobs in progress")),
        Center(child: Text("No completed jobs")),
        Center(child: Text("No cancelled jobs")),
                  ],
                ),
      ),
    );
  }
}