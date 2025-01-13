import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class Prograss extends StatefulWidget {
  const Prograss({super.key});

  @override
  State<Prograss> createState() => _PrograssState();
}

class _PrograssState extends State<Prograss> {
  late int totalDaysInYear;
  late int currentDayOfYear;
  late double progressPercentage;
  late String currentTime; // إضافة متغير لتخزين الوقت
  late String currentDate; // إضافة متغير لتخزين التاريخ الهجري

  @override
  void initState() {
    super.initState();
    calculateHijriProgress();
    currentTime = DateFormat.jm().format(DateTime.now()); // ضبط الوقت الابتدائي
    currentDate = HijriCalendar.now().toString(); // ضبط التاريخ الابتدائي
    // تحديث الساعة كل دقيقة
    Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        currentTime = DateFormat.jm().format(DateTime.now());
        currentDate = HijriCalendar.now().toString();
      });
    });
    // إخفاء شريط الإشعارات
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> calculateHijriProgress() async {
    final hijriDate = HijriCalendar.now();
    final currentMonth = hijriDate.hMonth;
    final currentDay = hijriDate.hDay;
    // إجمالي الأيام لكل شهر هجري
    const daysInHijriMonths = [30, 29, 30, 29, 30, 29, 30, 29, 30, 29, 30, 29];
    // حساب إجمالي الأيام في السنة الهجرية
    totalDaysInYear = daysInHijriMonths.reduce((a, b) => a + b);
    // حساب اليوم الحالي في السنة الهجرية
    currentDayOfYear = daysInHijriMonths
            .sublist(0, currentMonth - 1)
            .fold(0, (a, b) => a + b) +
        currentDay;
    // نسبة التقدم
    progressPercentage = currentDayOfYear / totalDaysInYear;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.centerRight,
          children: [
            ClipRRect(
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(3.14159),
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  value: progressPercentage, // نسبة التقدم
                  color: Colors.black,
                  backgroundColor: Colors.grey[300],
                  minHeight: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                'مضى ${(progressPercentage * 100).toStringAsFixed(0)}% من ${HijriCalendar.now().hYear}هـ',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
