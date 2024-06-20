import 'package:flutter/material.dart';
import 'package:flutter_projects/presentation/providers/lang_provider.dart';
import 'package:flutter_projects/presentation/widgets/splash_screen.dart';
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
  // Workmanager().initialize(callbackDispatcher);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
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
