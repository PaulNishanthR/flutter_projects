import 'package:flutter/material.dart';
import 'package:flutter_projects/domain/model/project/project.dart';
import 'package:flutter_projects/presentation/providers/language/lang_provider.dart';
import 'package:flutter_projects/presentation/views/sidebar/members_list.dart';
import 'package:flutter_projects/presentation/widgets/sidebar/about.dart';
import 'package:flutter_projects/presentation/views/auth_pages/login.dart';
import 'package:flutter_projects/presentation/views/project/completed_project.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Navbar extends ConsumerWidget {
  final List<Project> projects;
  final void Function(Project) addProject;
  final String username;
  final int userId;

  const Navbar({
    Key? key,
    required this.projects,
    required this.addProject,
    required this.username,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNamePrefix = username.split('@').first;
    return Drawer(
      child: Container(
        // color: Colors.lightBlue[100],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                  // color: Colors.lightBlue,
                  ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.welcome,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        const LanguageDropdown(),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userNamePrefix,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      username,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.document_scanner,
                color: Colors.black,
              ),
              title: Text(
                AppLocalizations.of(context)!.reports,
                style: TextStyle(color: Colors.purple.shade300),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProjectsTable(
                      userId: userId,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.group,
                color: Colors.black,
              ),
              title: Text(
                AppLocalizations.of(context)!.teamMemberList,
                style: TextStyle(color: Colors.purple.shade300),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MembersListPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.info,
                color: Colors.black,
              ),
              title: Text(
                AppLocalizations.of(context)!.about,
                style: TextStyle(color: Colors.purple.shade300),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  ),
                );
              },
            ),
            const Divider(
              color: Colors.grey,
            ),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
              title: Text(
                AppLocalizations.of(context)!.logout,
                style: TextStyle(color: Colors.purple.shade300),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageDropdown extends ConsumerWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.translate),
      onSelected: (Locale selectedLocale) {
        ref.read(languageProvider.notifier).changeLocale(selectedLocale);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showToastMessage(context, selectedLocale);
        });
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<Locale>(
          value: Locale('en'),
          child: Row(
            children: [
              Icon(Icons.translate, color: Colors.black),
              SizedBox(width: 10),
              Text('English'),
            ],
          ),
        ),
        const PopupMenuItem<Locale>(
          value: Locale('ta'),
          child: Row(
            children: [
              Icon(Icons.translate, color: Colors.black),
              SizedBox(width: 10),
              Text('தமிழ்'),
            ],
          ),
        ),
      ],
    );
  }

  void _showToastMessage(BuildContext context, Locale locale) {
    String message;
    if (locale.languageCode == 'en') {
      message = 'Language changed to English';
    } else if (locale.languageCode == 'ta') {
      message = 'மொழி தமிழுக்கு மாற்றப்பட்டது';
    } else {
      message = 'Language changed';
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.purple.shade300,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
