import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static const platform = MethodChannel('com.example.proup/installed_apps');
  List<String> apps = [];

  @override
  void initState() {
    super.initState();
    fetchInstalledApps();
  }

  Future<void> fetchInstalledApps() async {
    try {
      final List<dynamic> result =
          await platform.invokeMethod('getInstalledApps');
      setState(() {
        apps = result.cast<String>();
      });
    } on PlatformException catch (e) {
      print("Error fetching apps: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'العودة',
            style: TextStyle(fontSize: 15),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  'الإعدادات',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
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
                        itemCount: apps.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              apps[index],
                              textAlign: TextAlign.right,
                            ),
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
                  onPressed: () {},
                  child: Text('@Skepr برمجة عمك',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      )),
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
                  onPressed: () {},
                  child: Text('@Skepr برمجة عمك',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ],
          ),
        ));
  }
}
