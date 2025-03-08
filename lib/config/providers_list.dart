import 'package:flutter/material.dart';
import 'package:lmart/config/providers/bottom_nav_bar_provider.dart';
import 'package:lmart/config/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:lmart/config/injection_container.dart' as di;

import 'providers/locale_provider.dart';

MultiProvider providersList({Widget? child}) {
  return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<LocaleProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<ProfileProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<BottomNavBarProvider>()),
        ],
      child: child!);
}