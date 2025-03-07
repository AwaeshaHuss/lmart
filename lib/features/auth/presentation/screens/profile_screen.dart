import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lmart/config/providers/locale_provider.dart';
import 'package:lmart/config/providers/profile_provider.dart';
import 'package:lmart/core/colors/app_colors.dart';
import 'package:lmart/core/data/firebase_service.dart';
import 'package:lmart/core/data/models/user_profile.dart';
import 'package:lmart/core/fonts/app_fonts.dart';
import 'package:lmart/core/utils.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = "User not logged in";
          _isLoading = false;
        });
        return;
      }

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        UserProfile userProfile =
            UserProfile.fromJson(userDoc.data() as Map<String, dynamic>);
        _nameController.text = userProfile.name;
        _emailController.text = userProfile.email;
        // If profile image is available, load it (you can later store the image URL in Firestore)
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateUserProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = "User not logged in";
          _isLoading = false;
        });
        return;
      }

      UserProfile updatedProfile = UserProfile(
        uid: user.uid,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        profileImageUrl: '', // You can later add image upload functionality
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(updatedProfile.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(getLoc(context).profileUpdatedSuccess)),
      );
      // Navigator.pop(context);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, prfile, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(getLoc(context).userProfileTitle),
            centerTitle: false,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8.0),
                child: IconButton.outlined(
                    onPressed: () async {
                      await FirebaseService().signOut(context);
                    },
                    icon: Icon(Icons.logout)),
              )
            ],
          ),
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  strokeWidth: 1,
                  color: AppColors.primaryColor,
                ))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Profile Image Section
                          GestureDetector(
                            onTap: () async {
                              File? newImage = await pickAndCropImage(context);
                              if (newImage != null) {
                                setState(() {
                                  _profileImage = newImage;
                                });
                              }
                            },
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.text_1Color,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : null,
                              child: _profileImage == null
                                  ? const Icon(
                                      Icons.camera_alt,
                                      color: AppColors.white_1,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 45),
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: AppColors.red),
                              ),
                            ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            style: AppFonts.proximaNova12Regular,
                            controller: _nameController,
                            decoration: InputDecoration(
                                labelText: getLoc(context).nameLabel),
                            validator: (value) => value!.isEmpty
                                ? getLoc(context).nameValidationError
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            style: AppFonts.proximaNova12Regular,
                            controller: _emailController,
                            decoration: InputDecoration(
                                labelText: getLoc(context).emailLabel),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) return 'Enter your email';
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(flex: 2),
                              ElevatedButton(
                                onPressed: _updateUserProfile,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getLoc(context).updateProfileButton,
                                    style: AppFonts.proximaNova16Medium,
                                  ),
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                   if (getLoc(context).localeName == 'ar') {
                                     LocaleProvider.read(context).changeLocale(Locale('en'));
                                   } else {
                                     LocaleProvider.read(context).changeLocale(Locale('ar'));
                                   }
                                  },
                                  icon: Icon(Icons.language))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
