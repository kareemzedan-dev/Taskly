import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/order_view_body.dart';

class TimeInputRaw extends StatefulWidget {
  const TimeInputRaw({super.key});

  @override
  State<TimeInputRaw> createState() => _TimeInputRawState();
}

class _TimeInputRawState extends State<TimeInputRaw> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter time"),
            onChanged: (val) => orderViewModel.timeController.text = val,
          ),
        ),
        SizedBox(width: 8),
        DropdownButton<String>(
          value: orderViewModel.selectedTimeUnit,
          items:
              orderViewModel.timeUnits
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
          onChanged:
              (val) => setState(() => orderViewModel.selectedTimeUnit = val!),
        ),
      ],
    );
  }
}
