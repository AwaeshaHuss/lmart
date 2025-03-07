import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lmart/core/assets/app_assets.dart';
import 'package:lmart/core/colors/app_colors.dart';
import 'package:lmart/core/data/firebase_service.dart';
import 'package:lmart/core/fonts/app_fonts.dart';
import 'package:lmart/core/utils.dart';
import 'package:lmart/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:lmart/features/product/presentation/widgets/bottom_nav_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController  = TextEditingController();
  bool _isLoading = false;
  bool _secured = false;
  String? _errorMessage;
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  securityChanger(){
    setState(() {
      _secured = !_secured;
    });
  }
  
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmController.text) {
      setState(() => _errorMessage = getLoc(context).passwordMismatchError);
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Using a function from your Firebase service file.
      await FirebaseService().signUpWithEmail(
        _emailController.text.trim(),_passwordController.text,
      );
      if(mounted){ 
        // On success, navigate back or to your home screen.
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BottomNavBar()));
       }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Container(
            alignment: AlignmentDirectional.topStart,
            padding: EdgeInsetsDirectional.all(8.0).copyWith(bottom: 22.0, start: 0.0),
            child: Text(getLoc(context).signUpTitle, style: AppFonts.proximaNova22Meduim.copyWith(fontSize: 27, decoration: TextDecoration.underline,)),
          ),
          TextFormField(
            style: AppFonts.proximaNova12Regular,
            controller: _emailController,
            decoration: InputDecoration(
              labelText: getLoc(context).emailLabel,
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter your email';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            style: AppFonts.proximaNova12Regular,
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: getLoc(context).passwordLabel,
              prefixIcon: Icon(Icons.lock),
              suffixIcon: _secured
              ? GestureDetector(
                onTap: securityChanger,
                child: Icon(Icons.lock))
              : GestureDetector(
                onTap: securityChanger,
                child: Icon(Icons.lock_open))
            ),
            obscureText: _secured,
            validator: (value) {
              if (value == null || value.isEmpty) return getLoc(context).passwordLengthError;
              if (value.length < 6) return 'Password must be at least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            style: AppFonts.proximaNova12Regular,
            controller: _confirmController,
            decoration: InputDecoration(
              labelText: getLoc(context).confirmPasswordLabel,
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: _secured,
            validator: (value) {
              if (value == null || value.isEmpty) return getLoc(context).confirmPasswordLabel;
              return null;
            },
          ),
          const SizedBox(height: 24),
          _isLoading
              ? const CircularProgressIndicator(strokeWidth: 1, color: AppColors.secondaryColor,)
              : ElevatedButton(
                  onPressed: _submit,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(getLoc(context).signUpTitle, style: AppFonts.proximaNova16Medium,),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignInScreen())),
                      child: Text(getLoc(context).signInTitle, style: AppFonts.proximaNova12Regular.copyWith(fontSize: 14, decoration: TextDecoration.underline),))
                  ],
                ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: SizedBox(
          width: 100,
          height: 100,
          child: FittedBox(child: SvgPicture.asset(AppAssets.logo))),
        centerTitle: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: _buildSignUpForm(),
        ),
      ),
    );
  }
}
