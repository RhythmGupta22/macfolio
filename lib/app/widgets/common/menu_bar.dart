import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MacMenuBar extends StatefulWidget {
  final Icon leadIcon;
  final String leadingTitle;
  final Color backgroundColor;

  const MacMenuBar({
    super.key,
    this.leadIcon = const Icon(Icons.apple, color: Colors.white, size: 18,),
    this.leadingTitle = 'Finder',
    this.backgroundColor = const Color.fromRGBO(40, 40, 40, 0.6),
  });

  @override
  State<MacMenuBar> createState() => _MacMenuBarState();
}

class _MacMenuBarState extends State<MacMenuBar> {
  late String _timeString;
  late String _dateString;
  Timer? _timer; // Declare the timer

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    final time = DateFormat('h:mm a').format(now);
    final date = DateFormat('EEEE MMMM d').format(now);

    if (!mounted) return; // Prevents calling setState after dispose

    setState(() {
      _timeString = time;
      _dateString = date;
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          widget.leadIcon,
          SizedBox(width: 10),
          Text(
            widget.leadingTitle,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: Colors.white,
              fontFamily: 'SFPro',
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Image.asset('assets/icons/wifi.png'),
              const SizedBox(width: 8),
              Image.asset('assets/icons/battery.png'),
              const SizedBox(width: 8),
              Image.asset('assets/icons/controlcentre.png'),
              const SizedBox(width: 8),
              Text(
                _dateString,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  color: Colors.white,
                  fontFamily: 'SFPro',
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _timeString,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  color: Colors.white,
                  fontFamily: 'SFPro',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}