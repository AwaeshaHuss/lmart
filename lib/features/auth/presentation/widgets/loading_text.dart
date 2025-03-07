import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lmart/core/fonts/app_fonts.dart';

class LoadingText extends StatefulWidget {
  const LoadingText({super.key});

  @override
  State<LoadingText> createState() => _LoadingTextState();
}

class _LoadingTextState extends State<LoadingText> {
  String _loadingText = 'Loading';
  int _dotCount = 0;
  late Timer _timer;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startLoadingAnimation();
  }

  void _startLoadingAnimation() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        if (_dotCount < 3) {
          _dotCount++;
          _loadingText = 'Loading${'.' * _dotCount}';
        } else {
          _opacity = 0.0;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(milliseconds: 500),
      child: Text(
        _loadingText,
        style: AppFonts.proximaNova22Meduim,
      ),
    );
  }
}
