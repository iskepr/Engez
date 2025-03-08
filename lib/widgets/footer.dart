import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:engez/settings.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  Future<void> openApp(String packageName) async {
    final Uri uri = Uri.parse(
      "intent://$packageName#Intent;scheme=package;end;",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("لا يمكن فتح التطبيق: $packageName");
    }
  }

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
                    onPressed: () {
                      openApp("com.android.camera");
                    },
                    icon: const Icon(Icons.camera_alt_outlined),
                    tooltip: 'Camera',
                  ),
                  IconButton(
                    onPressed: () async {
                      await launchUrl(
                        Uri.parse("intent://#Intent;scheme=package;end;"),
                      );
                      openApp("com.android.contacts");
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
