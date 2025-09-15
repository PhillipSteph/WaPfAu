import 'package:flutter/material.dart';
import 'package:wapfau/widgets/confirmation/confirmationBanner.dart';

import '../services/coreService.dart';

class ConfirmationPage extends StatefulWidget {
  final CoreService coreService;
  const ConfirmationPage({super.key, required this.coreService});
  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ConfirmationBanner()
          ],
        )
      ),
    );
  }
}
