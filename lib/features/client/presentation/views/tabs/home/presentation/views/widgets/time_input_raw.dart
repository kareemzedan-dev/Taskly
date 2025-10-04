import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/view_model/place_order_view_model/place_order_view_model.dart';

class TimeInputRaw extends StatefulWidget {
  const TimeInputRaw({super.key,});

  @override
  State<TimeInputRaw> createState() => _TimeInputRawState();
}

class _TimeInputRawState extends State<TimeInputRaw> {
    
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // ✅ يسمح بالأرقام فقط
                ],
                decoration: InputDecoration(
                  hintText: "Enter time",
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                onChanged: (val) => context.read<PlaceOrderViewModel>().timeController.text = val,
              ),
            ),
            SizedBox(width: 8),
            DropdownButton<String>(
              value: context.read<PlaceOrderViewModel>().selectedTimeUnit,
              items:
                  context.read<PlaceOrderViewModel>().timeUnits
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged:
                  (val) =>
                      setState(() => context.read<PlaceOrderViewModel>().selectedTimeUnit = val!),
            ),
          ],
        ),
      ),
    );
  }
}
