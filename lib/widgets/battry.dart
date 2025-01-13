import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

class Battry extends StatefulWidget {
  const Battry({Key? key}) : super(key: key);

  @override
  _BattryState createState() => _BattryState();
}

class _BattryState extends State<Battry> {
  Battery battery = Battery();
  int batteryLevel = 0;

  @override
  void initState() {
    super.initState();
    battery.batteryLevel.then((level) {
      setState(() {
        batteryLevel = level;
      });
    });

    battery.onBatteryStateChanged.listen((BatteryState state) {
      battery.batteryLevel.then((level) {
        setState(() {
          batteryLevel = level;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Icon(Icons.electric_bolt_outlined),
          Text(
            '$batteryLevel%',
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
