import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late String _timeString;
  late String _dateString;

  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    final time = DateFormat('h:mm').format(now);
    final date = DateFormat('EEEE, MMMM d').format(now);

    setState(() {
      _timeString = time;
      _dateString = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Get.toNamed(Routes.DESKTOP),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/bg_wallpaper.jpg',
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    _dateString,
                    style: const TextStyle(
                      fontFamily: 'SFPro',
                      color: Colors.white70,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 2), // Reduced spacing
                  Text(
                    _timeString,
                    style: const TextStyle(
                      fontFamily: 'SFPro',
                      color: Colors.white,
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                      height: 0.95, // tighter line height
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Rhythm Gupta',
                    style: TextStyle(
                      fontFamily: 'SFPro',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Press anywhere to continue',
                    style: TextStyle(
                      fontFamily: 'SFPro',
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: Row(
                children:  [
                  Image(image: AssetImage('assets/icons/wifi.png')),
                  SizedBox(width: 5,),
                  Image(image: AssetImage('assets/icons/battery.png')),
                  SizedBox(width: 5,),
                  Image(image: AssetImage('assets/icons/controlcentre.png')),],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
