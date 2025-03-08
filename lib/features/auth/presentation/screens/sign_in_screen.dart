import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lmart/core/assets/app_assets.dart';
import 'package:lmart/core/colors/app_colors.dart';
import 'package:lmart/core/data/firebase_service.dart';
import 'package:lmart/core/fonts/app_fonts.dart';
import 'package:lmart/core/utils.dart';
import 'package:lmart/features/auth/presentation/screens/signup_screen.dart';
import 'package:lmart/features/product/presentation/widgets/bottom_nav_bar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _secured = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _secured = !_secured;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseService().signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) {
        // Navigate to the home screen or desired screen after successful sign-in
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

  Widget _buildSignInForm() {
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
            padding: const EdgeInsetsDirectional.all(8.0)
                .copyWith(bottom: 22.0, start: 0.0),
            child: Text(
              getLoc(context).signInTitle,
              style: AppFonts.proximaNova22Meduim.copyWith(
                fontSize: 27,
                decoration: TextDecoration.underline,
              ),
            ),
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
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: GestureDetector(
                onTap: _togglePasswordVisibility,
                child: Icon(
                  _secured ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            obscureText: _secured,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter your password';
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          _isLoading
              ? const CircularProgressIndicator(
                  strokeWidth: 1,
                  color: AppColors.secondaryColor,
                )
              : ElevatedButton(
                  onPressed: _submit,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      getLoc(context).signInTitle,
                      style: AppFonts.proximaNova16Medium,
                    ),
                  ),
                ),
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignUpScreen())),
                  child: Text(
                    getLoc(context).signUpTitle,
                    style: AppFonts.proximaNova12Regular.copyWith(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const VerticalDivider(
                  thickness: 1,
                  color: Colors.black,
                ),
                GestureDetector(
                  onTap: () async => await FirebaseService().signInWithGoogle(context),
                  child: Text(getLoc(context).googleSignIn,
                      style: AppFonts.proximaNova12Regular.copyWith(
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),),
                )
              ],
            ),
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
          child: FittedBox(child: SvgPicture.asset(AppAssets.logo)),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: _buildSignInForm(),
        ),
      ),
    );
  }
}
