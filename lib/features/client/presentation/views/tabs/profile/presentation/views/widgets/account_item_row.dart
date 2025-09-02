import 'package:flutter/material.dart';
import 'package:taskly/core/utils/app_text_styles.dart';
import 'package:taskly/core/utils/colors_manger.dart';
 

class AccountItemRow extends StatefulWidget {
  const AccountItemRow({
    super.key,
    required this.image,
    required this.text,
    this.isNotification = false,
  });

  final String image;
  final String text;
  final bool isNotification;

  @override
  State<AccountItemRow> createState() => _AccountItemRowState();
}

class _AccountItemRowState extends State<AccountItemRow> {
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Card(
          elevation: 10,
          shadowColor: Colors.transparent,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(widget.image, height: 16, width: 16),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Text(
          widget.text,
          style: AppTextStyles.bold16.copyWith(
            color: ColorsManager.black.withOpacity(.6),
          ),
        ),
        const Spacer(),
        widget.isNotification
            ?  Transform.scale(
        scale: 0.8, // 👈 تصغير/تكبير السويتش
        child: Switch(
          value: _switchValue,
          activeColor: ColorsManager.primary,
          onChanged: (value) {
            setState(() {
              _switchValue = value;
            });
          },
        ),
      )
    :  Icon(Icons.arrow_forward_ios_rounded,
                color: ColorsManager.primary),
      ],
    );
  }
}
