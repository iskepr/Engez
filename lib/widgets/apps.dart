import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';

class Apps extends StatelessWidget {
  const Apps({super.key});

  @override
  Widget build(BuildContext context) {
    var apps = [
      {
        "name": "ترتيل",
        "path": "com.mmmoussa.iqra",
      },
      {
        "name": "يوتيوب",
        "path": "com.google.android.youtube",
      },
      {
        "name": "واتساب",
        "path": "com.whatsapp",
      },
      {
        "name": "TickTick",
        "path": "com.ticktick.task",
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: apps
          .map(
            (app) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextButton(
                onPressed: () async {
                  await LaunchApp.openApp(
                    androidPackageName: app['path'],
                    openStore: false,
                  );
                },
                child: Text(
                  app['name'].toString(),
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
