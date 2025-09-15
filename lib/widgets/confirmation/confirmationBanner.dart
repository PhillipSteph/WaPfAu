import 'package:flutter/material.dart';

class ConfirmationBanner extends StatefulWidget {
  const ConfirmationBanner({super.key});
  @override
  State<ConfirmationBanner> createState() => _ConfirmationBannerState();
}

class _ConfirmationBannerState extends State<ConfirmationBanner> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      ConstrainedBox(
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                border: Border.all(
                  color: Colors.green.withOpacity(0.7),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12)
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Icon(
                    Icons.check_circle,
                    color: Color(0xFF008800),
                    size: 80,
                  ),
                ),
                Text(
                    "Modulauswahl erfolgreich gespeichert",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xFF002200))
                ),
                Text(
                    "Ihre Wahlpflichtmodule wurden registriert.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xFF008800))
                )
              ],
            )
        )
      );
  }
}
