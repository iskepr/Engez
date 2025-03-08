import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static const platform = MethodChannel('com.skepr.engez/installed_apps');
  List installedApps = [];

  @override
  void initState() {
    super.initState();
    fetchInstalledApps();
  }

  Future<void> fetchInstalledApps() async {
    try {
      final List<dynamic> result = await platform.invokeMethod(
        'getInstalledApps',
      );
      print("Fetched apps: $result"); // التحقق من النتيجة

      setState(() {
        installedApps =
            result
                .map(
                  (app) => {
                    "name": app["name"].toString(),
                    "path": app["package"].toString(),
                  },
                )
                .cast<Map<String, String>>()
                .toList();
      });
    } on PlatformException catch (e) {
      print("Error fetching apps: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('العودة', style: TextStyle(fontSize: 15))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                'الإعدادات',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 300,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              // border radius
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'التطبيقات المثبتة',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Divider(),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: installedApps.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(installedApps[index]["name"] ?? ""),
                          subtitle: Text(installedApps[index]["path"] ?? ""),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              // border radius
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextButton(
                onPressed: () async {
                  await launchUrl(Uri.parse("https://iskepr.github.io"));
                },
                child: Text(
                  'برمجة عمك سكيبر',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
