import 'package:flutter/material.dart';
 

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return   Row(
      children:   [
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 17.0),
          child: Text("Or", style: Theme.of(context).textTheme.bodyMedium,),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
             color: Colors.grey
          ),
        ),
      ],
    );
  }
}