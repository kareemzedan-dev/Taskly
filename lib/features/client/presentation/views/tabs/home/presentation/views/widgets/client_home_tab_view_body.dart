import 'package:flutter/widgets.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/client_home_header.dart';

class ClientHomeTabViewBody extends StatelessWidget {
  const ClientHomeTabViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return   SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          ClientHomeHeader()
          
          
        
        ],),
      ),
    );
  }
}