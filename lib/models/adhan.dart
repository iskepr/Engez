import 'dart:async';

import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class Adhan extends StatefulWidget {
  const Adhan({super.key});

  @override
  State<Adhan> createState() => _AdhanState();
}

class _AdhanState extends State<Adhan> {
  late final Coordinates coordinates =
      Coordinates(30.043489, 31.235291); // خط العرض والطول
  late final params = CalculationMethod.egyptian.getParameters();
  late PrayerTimes prayerTimes;
  DateTime? nextPrayerTime;
  String? nextPrayerName;
  String countdown = '';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    params.madhab = Madhab.shafi;
    _calculatePrayerTimes();
    _initializeNotifications(); // إعداد الإشعارات
    _startCountdown(); // بدء العد التنازلي
  }

  void _initializeNotifications() async {
    var androidInitialize = AndroidInitializationSettings(
        'app_icon'); // تأكد من أنك وضعت أيقونة في مجلد `res/drawable/`
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _calculatePrayerTimes() {
    // حساب أوقات الصلاة
    prayerTimes = PrayerTimes.today(coordinates, params);

    // الحصول على الوقت الحالي
    final now = DateTime.now();

    // معرفة الصلاة القادمة
    Prayer? nextPrayer;

    if (now.isBefore(prayerTimes.fajr)) {
      nextPrayer = Prayer.fajr;
      nextPrayerTime = prayerTimes.fajr;
    } else if (now.isBefore(prayerTimes.dhuhr)) {
      nextPrayer = Prayer.dhuhr;
      nextPrayerTime = prayerTimes.dhuhr;
    } else if (now.isBefore(prayerTimes.asr)) {
      nextPrayer = Prayer.asr;
      nextPrayerTime = prayerTimes.asr;
    } else if (now.isBefore(prayerTimes.maghrib)) {
      nextPrayer = Prayer.maghrib;
      nextPrayerTime = prayerTimes.maghrib;
    } else if (now.isBefore(prayerTimes.isha)) {
      nextPrayer = Prayer.isha;
      nextPrayerTime = prayerTimes.isha;
    } else {
      nextPrayer = Prayer.fajr;
      nextPrayerTime = prayerTimes.fajr.add(const Duration(days: 1));
    }

    // تحديث حالة التطبيق
    setState(() {
      nextPrayerName = nextPrayer != null ? getPrayerName(nextPrayer) : null;
      _scheduleNotification(nextPrayerTime!);
    });
  }

// دالة لتحديث العد التنازلي
  void _startCountdown() {
    const oneSecond = Duration(seconds: 1);

    Timer.periodic(oneSecond, (timer) {
      if (nextPrayerTime != null) {
        var now = DateTime.now();
        var difference = nextPrayerTime!.difference(now);

        if (difference.isNegative) {
          setState(() {
            countdown = 'حان وقت الصلاة';
          });
          timer.cancel(); // إيقاف التايمر عند وصول الوقت
        } else {
          setState(() {
            if (difference.inHours > 0) {
              // إذا كانت الفترة أكبر من ساعة
              countdown = '${difference.inMinutes.remainder(60)}'':'' ${difference.inHours}'
                  ;
            } else {
              // إذا كانت الفترة أقل من ساعة
              countdown = '${difference.inMinutes}'
                  ':'
                  '${difference.inSeconds.remainder(60)}';
            }
          });
        }
      }
    });
  }


  void _scheduleNotification(DateTime prayerTime) async {
    var androidDetails = AndroidNotificationDetails(
      'prayer_channel_id',
      'Prayer Notifications',
      channelDescription: 'Channel for prayer times',
      importance: Importance.max,
      priority: Priority.high,
    );
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'وقت الصلاة',
      'حان وقت ${nextPrayerName ?? 'الصلاة'}',
      tz.TZDateTime.from(prayerTime, tz.local),
      generalNotificationDetails,
      androidScheduleMode: AndroidScheduleMode.exact, // إضافة المعامل
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // دالة ترجمة أسماء الصلوات
  String getPrayerName(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return "الفجر";
      case Prayer.dhuhr:
        return "الظهر";
      case Prayer.asr:
        return "العصر";
      case Prayer.maghrib:
        return "المغرب";
      case Prayer.isha:
        return "العشاء";
      default:
        return "غير معروف";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: nextPrayerTime != null && nextPrayerName != null
          ? Text(
              '$nextPrayerName خلال: $countdown',
              style: const TextStyle(fontSize: 20),
            )
          : const CircularProgressIndicator(), // مؤشر تحميل
    );
  }
}
