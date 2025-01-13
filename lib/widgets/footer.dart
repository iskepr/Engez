import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:proup/alarm.dart';
import 'package:proup/settings.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Settings()),
                      );
                    },
                    icon: const Icon(Icons.alarm_outlined),
                    tooltip: 'Alarm',
                  ),
                  IconButton(
                    onPressed: () {
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Settings()),
                      );
                    },
                    icon: const Icon(Icons.settings_outlined),
                    tooltip: 'Settings',
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () async {
                      await LaunchApp.openApp(
                        androidPackageName: 'com.android.camera',
                      );
                    },
                    icon: const Icon(Icons.camera_alt_outlined),
                    tooltip: 'Camera',
                  ),
                  IconButton(
                    onPressed: () async {
                      await LaunchApp.openApp(
                        androidPackageName: 'com.android.contacts',
                      );
                    },
                    icon: const Icon(Icons.phone_outlined),
                    tooltip: 'call',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
