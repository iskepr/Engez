import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class Time extends StatefulWidget {
  const Time({super.key});

  @override
  State<Time> createState() => _TimeState();
}

class _TimeState extends State<Time> {
  late int totalDaysInYear;

  late int currentDayOfYear;

  late double progressPercentage;

  late String currentTime;
  // إضافة متغير لتخزين الوقت
  late String currentDate;
  // إضافة متغير لتخزين التاريخ الهجري
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
    HijriCalendar today = HijriCalendar.now();
    HijriCalendar.setLocal('ar');
    final date = today.toFormat("MMMM dd");
    return Column(
      children: [
        Text(
          currentTime,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$date, ${today.getDayName()}',
          style: const TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ],
    );
  }
}