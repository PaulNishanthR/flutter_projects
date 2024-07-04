import 'package:flutter/material.dart';
import 'package:flutter_projects/presentation/providers/language/lang_provider.dart';
import 'package:flutter_projects/presentation/widgets/auth_page/splash_screen.dart';
import 'package:flutter_projects/utils/app_notifications/app_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final String databasePath = await getDatabasesPath();
  // final String path = join(databasePath, "datasource.db");
  // print("DB Delete");
  // deleteDatabase(path);
  NotificationManager.initializeNotifications();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              details.exception.toString(),
              style: const TextStyle(fontSize: 25, color: Colors.black),
            )
          ],
        ),
      ),
    );
  };
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      // showPerformanceOverlay: true,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ref.watch(languageProvider),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellowAccent),
        fontFamily: 'inter',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
