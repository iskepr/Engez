import 'package:flutter/material.dart';
import 'package:proup/models/adhan.dart';
import 'package:proup/widgets/apps.dart';
import 'package:proup/widgets/battry.dart';
import 'package:proup/widgets/footer.dart';
import 'package:proup/widgets/prograss.dart';
import 'package:proup/widgets/time.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Prograss(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Battry(),
                            Time(),
                          ],
                        ),
                        Adhan(),
                      ],
                    ),
                  ),
                  Apps(),
                ],
              ),
            ),
            SizedBox(height: 10),
            Footer(),
          ],
        ));
  }
}
