
 
import 'package:flutter/material.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/action_button.dart';

class OfferActions extends StatelessWidget {
  const OfferActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          ActionButton(
            text: "Start Chat",
            icon: Icons.chat,
            color: Colors.blue,
            filled: false,
          ),
          ActionButton(
            text: "Accept Offer",
            icon: Icons.check,
            color: Colors.green,
            filled: true,
          ),
          ActionButton(
            text: "Decline Offer",
            icon: Icons.close,
            color: Colors.red,
            filled: false,
          ),
        ],
      ),
    );
  }
}