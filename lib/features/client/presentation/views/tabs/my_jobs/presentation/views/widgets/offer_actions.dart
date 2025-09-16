
 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/action_button.dart';

class OfferActions extends StatelessWidget {
  const OfferActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.w), // بدل الثابت 8
      child: Row(
        children: const [
          Expanded(
            child: ActionButton(
              text: "Start Chat",
              icon: Icons.chat,
              color: Colors.blue,
              filled: false,
            ),
          ),
          SizedBox(width: 8 ), // spacing responsive
          Expanded(
            child: ActionButton(
              text: "Accept Offer",
              icon: Icons.check,
              color: Colors.green,
              filled: true,
            ),
          ),
          SizedBox(width: 8 ),
          Expanded(
            child: ActionButton(
              text: "Decline Offer",
              icon: Icons.close,
              color: Colors.red,
              filled: false,
            ),
          ),
        ],
      ),
    );
  }
}