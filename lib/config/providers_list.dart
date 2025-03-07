import 'package:flutter/material.dart';
import 'package:lmart/config/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:lmart/config/injection_container.dart' as di;

import 'providers/locale_provider.dart';

MultiProvider providersList({Widget? child}) {
  return MultiProvider(
      providers: [
        Provider(create: (_) => di.sl<LocaleProvider>()),
        Provider(create: (_) => di.sl<ProfileProvider>()),
        ],
      child: child!);
}