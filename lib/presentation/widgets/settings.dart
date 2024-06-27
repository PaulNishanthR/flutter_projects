import 'package:flutter/material.dart';
import 'package:flutter_projects/presentation/providers/lang_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late Locale _selectedLanguage;
  late List<Locale> _availableLanguages;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = ref.read(languageProvider);
    _availableLanguages = [
      const Locale('en'),
      const Locale('ta'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.selectlang,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DropdownButton<Locale>(
                value: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  ref.read(languageProvider.notifier).changeLocale(value!);
                  _showLanguageToast(value);
                },
                items: _availableLanguages
                    .map<DropdownMenuItem<Locale>>((Locale value) {
                  return DropdownMenuItem<Locale>(
                    value: value,
                    child: Text(
                      _getLanguageName(value),
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLanguageName(Locale locale) {
    if (locale.languageCode == 'en') {
      return 'English';
    } else if (locale.languageCode == 'ta') {
      return 'தமிழ்';
    }
    return '';
  }

  void _showLanguageToast(Locale selectedLocale) {
    String languageName = '';
    switch (selectedLocale.languageCode) {
      case 'en':
        languageName = 'English';
        break;
      case 'ta':
        languageName = 'தமிழ்';
        break;
      default:
        languageName = 'Unknown';
    }
    Fluttertoast.showToast(
      msg: 'You selected $languageName',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.purple,
      textColor: Colors.white,
    );
  }
}
