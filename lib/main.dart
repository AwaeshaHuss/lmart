import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:lmart/config/cache/cache_helper.dart';
import 'package:lmart/config/providers/locale_provider.dart';
import 'package:lmart/config/providers_list.dart';
import 'package:lmart/core/data/firebase_service.dart';
import 'package:lmart/core/strings.dart';
import 'package:lmart/core/themes/app_theme.dart';
import 'package:lmart/core/utils.dart';
import 'package:lmart/core/widgets/custom_error_widget.dart';
import 'package:lmart/features/auth/presentation/screens/splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lmart/firebase_options.dart';
import 'package:provider/provider.dart';
import 'config/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  await CacheHelper.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseService().initializeFirebaseMessaging();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Stripe.publishableKey = stripKey;
  setDefaultAppOrientation();
  await checkAndRequestPhotosPermissions();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(details: details);
  };
  runApp(const MainApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('A background message showed up: ${message.messageId}');
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return providersList(
      child: Consumer<LocaleProvider>(
        builder: (context, locale, child) {
          return MaterialApp(
            title: appTitle,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: locale.currentLocale,
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightMode,
            home: SpalashScreen(),
          );
        },
      ),
    );
  }
}
