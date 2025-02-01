import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

enum ProgressMode { daily, monthly, yearly }

class Prograss extends StatefulWidget {
  const Prograss({super.key});

  @override
  State<Prograss> createState() => _PrograssState();
}

class _PrograssState extends State<Prograss> {
  late int totalDaysInYear;
  late int currentDayOfYear;
  late double progressPercentage;
  late String currentTime;
  late String currentDate;
  ProgressMode currentMode = ProgressMode.yearly;

  @override
  void initState() {
    super.initState();
    calculateHijriProgress();
    currentTime = DateFormat.jm().format(DateTime.now());
    currentDate = HijriCalendar.now().toString();
    
    Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        currentTime = DateFormat.jm().format(DateTime.now());
        currentDate = HijriCalendar.now().toString();
        calculateHijriProgress();
      });
    });
    
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _switchMode() {
    setState(() {
      currentMode = ProgressMode.values[
        (currentMode.index + 1) % ProgressMode.values.length
      ];
      calculateHijriProgress();
    });
  }

  Future<void> calculateHijriProgress() async {
    final hijriDate = HijriCalendar.now();
    final now = DateTime.now();

    switch (currentMode) {
      case ProgressMode.daily:
        totalDaysInYear = 24;
        currentDayOfYear = now.hour;
        break;

      case ProgressMode.monthly:
        final currentMonthDays = _getHijriMonthDays(hijriDate.hMonth);
        totalDaysInYear = currentMonthDays;
        currentDayOfYear = hijriDate.hDay;
        break;

      case ProgressMode.yearly:
        const daysInHijriMonths = [30, 29, 30, 29, 30, 29, 30, 29, 30, 29, 30, 29];
        totalDaysInYear = daysInHijriMonths.reduce((a, b) => a + b);
        currentDayOfYear = daysInHijriMonths
            .sublist(0, hijriDate.hMonth - 1)
            .fold(0, (a, b) => a + b) + hijriDate.hDay;
        break;
    }

    progressPercentage = currentDayOfYear / totalDaysInYear;
  }

  int _getHijriMonthDays(int month) {
    const daysInHijriMonths = [30, 29, 30, 29, 30, 29, 30, 29, 30, 29, 30, 29];
    return daysInHijriMonths[month - 1];
  }

  String _getProgressText() {
    final percentage = (progressPercentage * 100).toStringAsFixed(0);
    final year = HijriCalendar.now().hYear;
    
    switch (currentMode) {
      case ProgressMode.daily:
        return 'مضى $percentage% من اليوم';
      case ProgressMode.monthly:
        return 'مضى $percentage% من الشهر';
      case ProgressMode.yearly:
        return 'مضى $percentage% من $yearهـ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _switchMode,
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              ClipRRect(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(3.14159),
                  child: LinearProgressIndicator(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    value: progressPercentage,
                    color: Colors.black,
                    backgroundColor: Colors.grey[300],
                    minHeight: 30,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  _getProgressText(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}