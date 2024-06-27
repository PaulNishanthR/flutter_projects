// ///Splash Screen--->>>
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_projects/presentation/views/login.dart';

// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({super.key});

// //   @override
// //   State<SplashScreen> createState() => _SplashScreenState();
// // }

// // class _SplashScreenState extends State<SplashScreen>
// //     with SingleTickerProviderStateMixin {
// //   @override
// //   void initState() {
// //     super.initState();
// //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

// //     Future.delayed(const Duration(seconds: 5), () {
// //       Navigator.of(context).pushReplacement(MaterialPageRoute(
// //         builder: (_) => const LoginScreen(),
// //       ));
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     super.dispose();
// //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
// //         overlays: SystemUiOverlay.values);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         width: double.infinity,
// //         decoration: const BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: [Colors.blue, Colors.green],
// //             begin: Alignment.centerLeft,
// //             end: Alignment.centerRight,
// //           ),
// //         ),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             // Icon(
// //             //   Icons.catching_pokemon,
// //             //   size: 80,
// //             //   color: Colors.black,
// //             // ),
// //             Image.asset(
// //               "assets/playstore.png",
// //               width: 80,
// //               height: 80,
// //             ),
// //             const SizedBox(height: 20),
// //             const Text(
// //               "KS ProjectHub",
// //               style: TextStyle(
// //                 fontStyle: FontStyle.italic,
// //                 color: Colors.black,
// //                 fontSize: 32,
// //               ),
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// ///Welcome Page ---->>>
// import 'package:flutter/material.dart';
// import 'package:flutter_projects/presentation/views/login.dart';
// import 'package:flutter_projects/presentation/views/register.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: const BoxDecoration(
//             gradient: LinearGradient(colors: [
//           Colors.white,
//           Colors.blue,
//         ])),
//         child: Column(children: [
//           const Padding(
//             padding: EdgeInsets.only(top: 200.0),
//             child: Image(
//               image: AssetImage("assets/playstore.png"),
//               height: 80,
//               width: 80,
//             ),
//           ),
//           const Text(
//             "KS ProjectHub",
//             style: TextStyle(
//               fontStyle: FontStyle.italic,
//               color: Colors.black,
//               fontSize: 32,
//             ),
//           ),
//           const SizedBox(
//             height: 100,
//           ),
//           const Text(
//             'Welcome',
//             style: TextStyle(fontSize: 30, color: Colors.black),
//           ),
//           const SizedBox(
//             height: 30,
//           ),
//           GestureDetector(
//             onTap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => const LoginScreen()));
//             },
//             child: Container(
//               height: 53,
//               width: 320,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30),
//                 border: Border.all(color: Colors.black),
//               ),
//               child: const Center(
//                 child: Text(
//                   'SIGN IN',
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 30,
//           ),
//           GestureDetector(
//             onTap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => const SignUp()));
//             },
//             child: Container(
//               height: 53,
//               width: 320,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//                 border: Border.all(color: Colors.black),
//               ),
//               child: const Center(
//                 child: Text(
//                   'SIGN UP',
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       // fontFamily: 'inter',
//                       color: Colors.black),
//                 ),
//               ),
//             ),
//           ),
//           const Spacer(),
//           const SizedBox(
//             height: 12,
//           ),
//         ]),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_projects/presentation/views/login.dart';
import 'package:flutter_projects/presentation/views/register.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_projects/presentation/providers/lang_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                // gradient: LinearGradient(colors: [
                //   Colors.purple.shade300,
                //   Colors.white,
                // ]),
                color: Colors.white),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 110, right: 20),
                  child: Lottie.asset(
                    "assets/welcome.json",
                    width: 400,
                    height: 300,
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Text(
                  AppLocalizations.of(context)!.welcomewithoutcomma,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Container(
                    height: 53,
                    width: 320,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.login,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade300),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );
                  },
                  child: Container(
                    height: 53,
                    width: 320,
                    decoration: BoxDecoration(
                      color: Colors.purple.shade300,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.signup,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
          const Positioned(
            top: 50,
            right: 10,
            child: LanguageDropdown(),
          ),
        ],
      ),
    );
  }
}

class LanguageDropdown extends ConsumerWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final selectedLanguage = ref.watch(languageProvider);

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.translate),
      onSelected: (Locale selectedLocale) {
        ref.read(languageProvider.notifier).changeLocale(selectedLocale);
        _showToastMessage(context, selectedLocale);
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<Locale>(
          value: Locale('en'),
          child: Row(
            children: [
              Icon(Icons.translate, color: Colors.blue),
              SizedBox(width: 10),
              Text('English'),
            ],
          ),
        ),
        const PopupMenuItem<Locale>(
          value: Locale('ta'),
          child: Row(
            children: [
              Icon(Icons.translate, color: Colors.green),
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
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.purple.shade300,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
