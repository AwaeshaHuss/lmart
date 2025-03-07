import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lmart/core/assets/app_assets.dart';
import 'package:lmart/features/auth/presentation/screens/signup_screen.dart';
import 'package:lmart/features/auth/presentation/widgets/loading_text.dart';
import 'package:lmart/features/product/presentation/widgets/bottom_nav_bar.dart';

class SpalashScreen extends StatefulWidget {
  const SpalashScreen({super.key});

  @override
  State<SpalashScreen> createState() => _SpalashScreenState();
}

class _SpalashScreenState extends State<SpalashScreen> {

  @override
  void initState() {
    super.initState();
    _handleLoginState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppAssets.logo),
            SizedBox(height: 42,),
            LoadingText(),
          ],
        ),
      ),
    );
  }
  
  void _handleLoginState() async {
    User? user = FirebaseAuth.instance.currentUser;
    await Future.delayed(Duration(seconds: 4), (){
      
      if (user == null) {
      // If the user is not logged in, go to the SignUpScreen.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignUpScreen()),
      );
    } else {
      // If the user is logged in, go to the BottomNavBar screen.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );
    }
      
    });
  }
}