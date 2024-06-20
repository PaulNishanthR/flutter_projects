// import 'dart:convert';
// import 'package:animated_snack_bar/animated_snack_bar.dart';
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_projects/presentation/providers/auth_provider.dart';
// import 'package:flutter_projects/presentation/providers/lang_provider.dart';
// import 'package:flutter_projects/presentation/providers/userId_provider.dart';
// import 'package:flutter_projects/presentation/views/home_for_manager.dart';
// import 'package:flutter_projects/presentation/views/home_for_member.dart';
// import 'package:flutter_projects/presentation/views/register.dart';
// import 'package:flutter_projects/presentation/views/home.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({
//     Key? key,
//   }) : super(key: key);

//   @override
//   ConsumerState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool isVisible = false;
//   bool isLoginTrue = false;

//   // final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   String encryptPassword(String password) {
//     final bytes = utf8.encode(password);
//     final hash = sha256.convert(bytes);
//     return hash.toString();
//   }

//   Future<void> login() async {
//     final String username = _usernameController.text;
//     final String password = _passwordController.text;
//     if (username.isEmpty || password.isEmpty) {
//       print('credentials not entered----');
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: const Text('Error'),
//           content: const Text('Please enter email and password'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//       return;
//     }

//     String encryptedPassword = encryptPassword(password);

//     Map<String, String> managerCredentials = {
//       'dravid@gmail.com': 'Dravid@12',
//       'sachin@gmail.com': 'Sachin@12',
//       'ganguly@gmail.com': 'Ganguly@12',
//     };

//     Map<String, String> memberCredentials = {
//       'nishanth@kumaran.com': 'Password@1',
//       'kumaran@kumaran.com': 'Password@2',
//       'murugan@kumaran.com': 'Password@3',
//     };

//     bool isAuthenticated = false;

//     if (managerCredentials.containsKey(username) &&
//         password == managerCredentials[username]) {
//       isAuthenticated = true;
//     } else if (memberCredentials.containsKey(username) &&
//         password == memberCredentials[username]) {
//       isAuthenticated = true;
//     } else {
//       isAuthenticated = await ref
//           .read(authProvider.notifier)
//           .login(username, encryptedPassword);
//       print('Is Authenticated---- $isAuthenticated');
//     }

//     if (isAuthenticated) {
//       final int? userId =
//           await ref.read(userIdProvider.notifier).getUserId(username);
//       if (managerCredentials.containsKey(username)) {
//         if (context.mounted) {
//           AnimatedSnackBar.material('Login Successful',
//               type: AnimatedSnackBarType.success);
//           Navigator.pushReplacement(context,
//               MaterialPageRoute(builder: (_) => const HomeForManager()));
//         }
//       } else if (memberCredentials.containsKey(username)) {
//         if (context.mounted) {
//           AnimatedSnackBar.material('Login Successful',
//               type: AnimatedSnackBarType.success);
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (_) => HomeForMember(
//                         memberName: username,
//                       )));
//         }
//       } else {
//         if (context.mounted) {
//           print('logged in for home screen---- $username $encryptedPassword');
//           AnimatedSnackBar.material('Login Successful',
//               type: AnimatedSnackBarType.success);
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => MyHomePage(
//                 title: "Kumaran's Projects",
//                 username: username,
//                 userId: userId,
//               ),
//             ),
//           );
//         }
//       }
//     } else {
//       if (context.mounted) {
//         AnimatedSnackBar.material('Invalid Credentials',
//                 type: AnimatedSnackBarType.warning)
//             .show(context);
//       }
//     }
//   }

//   final formKey = GlobalKey<FormState>();

//   List<PopupMenuEntry<Locale>> get languages {
//     return [
//       const PopupMenuItem(
//         value: Locale('en'),
//         child: Row(
//           children: <Widget>[
//             Icon(Icons.translate, color: Colors.blue),
//             SizedBox(width: 10),
//             Text('English'),
//           ],
//         ),
//       ),
//       const PopupMenuItem(
//         value: Locale('ta'),
//         child: Row(
//           children: <Widget>[
//             Icon(Icons.translate, color: Colors.green),
//             SizedBox(width: 10),
//             Text('தமிழ்'),
//           ],
//         ),
//       ),
//     ];
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     body: Center(
//   //       child: SingleChildScrollView(
//   //         child: Padding(
//   //           padding: const EdgeInsets.all(10.0),
//   //           child: Form(
//   //             key: formKey,
//   //             child: Column(
//   //               children: [
//   //                 Image.asset(
//   //                   "assets/image1.png",
//   //                   width: 210,
//   //                 ),
//   //                 const SizedBox(height: 15),
//   //                 Container(
//   //                   margin: const EdgeInsets.all(8),
//   //                   padding:
//   //                       const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//   //                   decoration: BoxDecoration(
//   //                     borderRadius: BorderRadius.circular(8),
//   //                     color: Colors.lightBlue.withOpacity(.2),
//   //                     // color: Color(0xffB81736),
//   //                   ),
//   //                   child: TextFormField(
//   //                     controller: _usernameController,
//   //                     autovalidateMode: AutovalidateMode.onUserInteraction,
//   //                     validator: (value) {
//   //                       if (value!.isEmpty) {
//   //                         return "Username is required";
//   //                       }
//   //                       if (!isValidEmail(value)) {
//   //                         return "Invalid email";
//   //                       }
//   //                       return null;
//   //                     },
//   //                     decoration: InputDecoration(
//   //                       icon: const Icon(Icons.person),
//   //                       border: InputBorder.none,
//   //                       hintText: AppLocalizations.of(context)!.email,
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 Container(
//   //                   margin: const EdgeInsets.all(8),
//   //                   padding:
//   //                       const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//   //                   decoration: BoxDecoration(
//   //                       borderRadius: BorderRadius.circular(8),
//   //                       color: Colors.lightBlue.withOpacity(.2)),
//   //                   child: TextFormField(
//   //                     controller: _passwordController,
//   //                     autovalidateMode: AutovalidateMode.onUserInteraction,
//   //                     validator: (value) {
//   //                       if (value!.isEmpty) {
//   //                         return "Password is required";
//   //                       }
//   //                       return null;
//   //                     },
//   //                     obscureText: !isVisible,
//   //                     decoration: InputDecoration(
//   //                         icon: const Icon(Icons.lock),
//   //                         border: InputBorder.none,
//   //                         hintText: AppLocalizations.of(context)!.password,
//   //                         suffixIcon: IconButton(
//   //                             onPressed: () {
//   //                               setState(() {
//   //                                 isVisible = !isVisible;
//   //                               });
//   //                             },
//   //                             icon: Icon(isVisible
//   //                                 ? Icons.visibility
//   //                                 : Icons.visibility_off))),
//   //                   ),
//   //                 ),
//   //                 const SizedBox(height: 10),
//   //                 Container(
//   //                   height: 55,
//   //                   width: MediaQuery.of(context).size.width * .9,
//   //                   decoration: BoxDecoration(
//   //                       borderRadius: BorderRadius.circular(8),
//   //                       color: Colors.lightBlue),
//   //                   child: TextButton(
//   //                       onPressed: () {
//   //                         if (formKey.currentState!.validate()) {
//   //                           login();
//   //                         }
//   //                       },
//   //                       child: Text(
//   //                         AppLocalizations.of(context)!.login,
//   //                         style: const TextStyle(color: Colors.white),
//   //                       )),
//   //                 ),
//   //                 Row(
//   //                   mainAxisAlignment: MainAxisAlignment.center,
//   //                   children: [
//   //                     Text(AppLocalizations.of(context)!.donthaveaccount),
//                   //     TextButton(
//                   //         onPressed: () {
//                   //           Navigator.push(
//                   //               context,
//                   //               MaterialPageRoute(
//                   //                   builder: (_) => const SignUp()));
//                   //         },
//                   //         child: Text(AppLocalizations.of(context)!.signup))
//                   //   ],
//                   // ),
//   //                 isLoginTrue
//   //                     ? const Text(
//   //                         "Username or password is incorrect",
//   //                         style: TextStyle(color: Colors.red),
//   //                       )
//   //                     : const SizedBox(),
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //     appBar: AppBar(
//   //       automaticallyImplyLeading: false,
//   //       actions: [
//   //         PopupMenuButton<Locale>(
//   //           icon: const Icon(Icons.translate),
//   //           onSelected: (Locale locale) {
//   //             ref.read(languageProvider.notifier).changeLocale(locale);
//   //           },
//   //           itemBuilder: (BuildContext context) => languages,
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   /// I think this build will work
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Stack(
//       children: [
//         Container(
//           height: double.infinity,
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(colors: [
//               Colors.white,
//               Colors.blue,
//             ]),
//           ),
//           child: const Padding(
//             padding: EdgeInsets.only(top: 60.0, left: 22),
//             child: Text(
//               'Sign in!',
//               style: TextStyle(
//                   fontSize: 40,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 200.0),
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.blue, width: 0.5),
//               borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(40), topRight: Radius.circular(40)),
//               color: Colors.white,
//             ),
//             height: double.infinity,
//             width: double.infinity,
//             child: Padding(
//               padding: const EdgeInsets.only(left: 18.0, right: 18),
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     TextFormField(
//                       controller: _usernameController,
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return "Email is required";
//                         }
//                         return null;
//                       },
//                       decoration: const InputDecoration(
//                           suffixIcon: Icon(
//                             Icons.check,
//                             color: Colors.grey,
//                           ),
//                           label: Text(
//                             'Email',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blue,
//                             ),
//                           )),
//                     ),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       controller: _passwordController,
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return "Password is required";
//                         }
//                         return null;
//                       },
//                       decoration: const InputDecoration(
//                         suffixIcon: Icon(
//                           Icons.visibility_off,
//                           color: Colors.grey,
//                         ),
//                         label: Text(
//                           'Password',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     const SizedBox(
//                       height: 70,
//                     ),
//                     Container(
//                       height: 55,
//                       width: 300,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(30),
//                         border: Border.all(color: Colors.black),
//                       ),
//                       child: Center(
//                         child: TextButton(
//                             onPressed: () {
//                               if (formKey.currentState!.validate()) {
//                                 String username = _usernameController.text;
//                                 String password = _passwordController.text;
//                                 print('${login()}');
//                                 login();
//                               }
//                             },
//                             child: const Text(
//                               'SIGN IN',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 20,
//                                   color: Colors.black),
//                             )),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     const Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Row(
//                           children: [
//                             Padding(padding: EdgeInsets.only(right: 65)),
//                             Text(
//                               "Don't have account?",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 17,
//                                   color: Colors.grey),
//                             ),
//                             SizedBox(width: 8),
//                             TextButton(
//                               "Sign up",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 17,
//                                   color: Colors.black),                  onPressed: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) => const SignUp()));
//                           },, child: null,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 150,
//                     ),
//                     const Align(
//                       alignment: Alignment.bottomRight,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         )
//       ],
//     ));
//   }

//   static final RegExp emailRegex = RegExp(
//     r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
//   );

//   static bool isValidEmail(String email) {
//     return emailRegex.hasMatch(email);
//   }
// }
// // import 'dart:convert';
// // import 'package:animated_snack_bar/animated_snack_bar.dart';
// // import 'package:crypto/crypto.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_projects/presentation/providers/auth_provider.dart';
// // import 'package:flutter_projects/presentation/providers/lang_provider.dart';
// // import 'package:flutter_projects/presentation/providers/userId_provider.dart';
// // import 'package:flutter_projects/presentation/views/home_for_manager.dart';
// // import 'package:flutter_projects/presentation/views/home_for_member.dart';
// // import 'package:flutter_projects/presentation/views/register.dart';
// // import 'package:flutter_projects/presentation/views/home.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// // class LoginScreen extends ConsumerStatefulWidget {
// //   const LoginScreen({
// //     Key? key,
// //   }) : super(key: key);

// //   @override
// //   ConsumerState createState() => _LoginScreenState();
// // }

// // class _LoginScreenState extends ConsumerState<LoginScreen> {
// //   final TextEditingController _usernameController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();

// //   bool isVisible = false;
// //   bool isLoginTrue = false;

// //   String encryptPassword(String password) {
// //     final bytes = utf8.encode(password);
// //     final hash = sha256.convert(bytes);
// //     return hash.toString();
// //   }

// //   Future<void> login() async {
// //     final String username = _usernameController.text;
// //     final String password = _passwordController.text;
// //     if (username.isEmpty || password.isEmpty) {
// //       showDialog(
// //         context: context,
// //         builder: (_) => AlertDialog(
// //           title: const Text('Error'),
// //           content: const Text('Please enter email and password'),
// //           actions: <Widget>[
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //               child: const Text('OK'),
// //             ),
// //           ],
// //         ),
// //       );
// //       return;
// //     }

// //     String encryptedPassword = encryptPassword(password);

// //     Map<String, String> managerCredentials = {
// //       'dravid@gmail.com': 'Dravid@12',
// //       'sachin@gmail.com': 'Sachin@12',
// //       'ganguly@gmail.com': 'Ganguly@12',
// //     };

// //     Map<String, String> memberCredentials = {
// //       'nishanth@kumaran.com': 'Password@1',
// //       'kumaran@kumaran.com': 'Password@2',
// //       'murugan@kumaran.com': 'Password@3',
// //     };

// //     bool isAuthenticated = false;

// //     if (managerCredentials.containsKey(username) &&
// //         password == managerCredentials[username]) {
// //       isAuthenticated = true;
// //     } else if (memberCredentials.containsKey(username) &&
// //         password == memberCredentials[username]) {
// //       isAuthenticated = true;
// //     } else {
// //       isAuthenticated = await ref
// //           .read(authProvider.notifier)
// //           .login(username, encryptedPassword);
// //     }

// //     if (isAuthenticated) {
// //       final int? userId =
// //           await ref.read(userIdProvider.notifier).getUserId(username);
// //       if (managerCredentials.containsKey(username)) {
// //         if (context.mounted) {
// //           Navigator.pushReplacement(context,
// //               MaterialPageRoute(builder: (_) => const HomeForManager()));
// //         }
// //       } else if (memberCredentials.containsKey(username)) {
// //         if (context.mounted) {
// //           Navigator.push(
// //               context,
// //               MaterialPageRoute(
// //                   builder: (_) => HomeForMember(
// //                         memberName: username,
// //                       )));
// //         }
// //       } else {
// //         if (context.mounted) {
// //           Navigator.pushReplacement(
// //             context,
// //             MaterialPageRoute(
// //               builder: (_) => MyHomePage(
// //                 title: "Kumaran's Projects",
// //                 username: username,
// //                 userId: userId,
// //               ),
// //             ),
// //           );
// //         }
// //       }
// //     } else {
// //       if (context.mounted) {
// //         AnimatedSnackBar.material('Invalid Credentials',
// //                 type: AnimatedSnackBarType.warning)
// //             .show(context);
// //       }
// //     }
// //   }

// //   final formKey = GlobalKey<FormState>();

// //   List<PopupMenuEntry<Locale>> get languages {
// //     return [
// //       const PopupMenuItem(
// //         value: Locale('en'),
// //         child: Row(
// //           children: <Widget>[
// //             Icon(Icons.translate, color: Colors.blue),
// //             SizedBox(width: 10),
// //             Text('English'),
// //           ],
// //         ),
// //       ),
// //       const PopupMenuItem(
// //         value: Locale('ta'),
// //         child: Row(
// //           children: <Widget>[
// //             Icon(Icons.translate, color: Colors.green),
// //             SizedBox(width: 10),
// //             Text('தமிழ்'),
// //           ],
// //         ),
// //       ),
// //     ];
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           Container(
// //             height: double.infinity,
// //             width: double.infinity,
// //             decoration: const BoxDecoration(
// //               gradient: LinearGradient(colors: [
// //                 Colors.white,
// //                 Colors.blue,
// //               ]),
// //             ),
// //             child: Padding(
// //               padding: const EdgeInsets.only(top: 60.0, left: 22, right: 22),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   const Text(
// //                     'Sign in!',
// //                     style: TextStyle(
// //                         fontSize: 40,
// //                         color: Colors.black,
// //                         fontWeight: FontWeight.bold),
// //                   ),
// //                   PopupMenuButton<Locale>(
// //                     icon: const Icon(Icons.translate),
// //                     onSelected: (Locale locale) {
// //                       ref.read(languageProvider.notifier).changeLocale(locale);
// //                     },
// //                     itemBuilder: (BuildContext context) => languages,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.only(top: 200.0),
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 border: Border.all(color: Colors.blue, width: 0.5),
// //                 borderRadius: const BorderRadius.only(
// //                     topLeft: Radius.circular(40),
// //                     topRight: Radius.circular(40)),
// //                 color: Colors.white,
// //               ),
// //               height: double.infinity,
// //               width: double.infinity,
// //               child: Padding(
// //                 padding: const EdgeInsets.only(left: 18.0, right: 18),
// //                 child: SingleChildScrollView(
// //                   child: Form(
// //                     key: formKey,
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         Container(
// //                           margin: const EdgeInsets.all(8),
// //                           padding: const EdgeInsets.symmetric(
// //                               horizontal: 10, vertical: 6),
// //                           decoration: BoxDecoration(
// //                               borderRadius: BorderRadius.circular(8),
// //                               color: Colors.lightBlue.withOpacity(.2)),
// //                           child: TextFormField(
// //                             controller: _usernameController,
// //                             autovalidateMode:
// //                                 AutovalidateMode.onUserInteraction,
// //                             validator: (value) {
// //                               if (value!.isEmpty) {
// //                                 return "Username is required";
// //                               }
// //                               if (!isValidEmail(value)) {
// //                                 return "Invalid email";
// //                               }
// //                               return null;
// //                             },
// //                             decoration: InputDecoration(
// //                               icon: const Icon(Icons.person),
// //                               border: InputBorder.none,
// //                               hintText: AppLocalizations.of(context)!.email,
// //                             ),
// //                           ),
// //                         ),
// //                         Container(
// //                           margin: const EdgeInsets.all(8),
// //                           padding: const EdgeInsets.symmetric(
// //                               horizontal: 10, vertical: 6),
// //                           decoration: BoxDecoration(
// //                               borderRadius: BorderRadius.circular(8),
// //                               color: Colors.lightBlue.withOpacity(.2)),
// //                           child: TextFormField(
// //                             controller: _passwordController,
// //                             autovalidateMode:
// //                                 AutovalidateMode.onUserInteraction,
// //                             validator: (value) {
// //                               if (value!.isEmpty) {
// //                                 return "Password is required";
// //                               }
// //                               return null;
// //                             },
// //                             obscureText: !isVisible,
// //                             decoration: InputDecoration(
// //                                 icon: const Icon(Icons.lock),
// //                                 border: InputBorder.none,
// //                                 hintText:
// //                                     AppLocalizations.of(context)!.password,
// //                                 suffixIcon: IconButton(
// //                                     onPressed: () {
// //                                       setState(() {
// //                                         isVisible = !isVisible;
// //                                       });
// //                                     },
// //                                     icon: Icon(isVisible
// //                                         ? Icons.visibility
// //                                         : Icons.visibility_off))),
// //                           ),
// //                         ),
// //                         const SizedBox(height: 20),
// //                         Container(
// //                           height: 55,
// //                           width: 300,
// //                           decoration: BoxDecoration(
// //                             borderRadius: BorderRadius.circular(30),
// //                             border: Border.all(color: Colors.black),
// //                           ),
// //                           child: Center(
// //                             child: TextButton(
// //                                 onPressed: () {
// //                                   if (formKey.currentState!.validate()) {
// //                                     login();
// //                                   }
// //                                 },
// //                                 child: const Text(
// //                                   'SIGN IN',
// //                                   style: TextStyle(
// //                                       fontWeight: FontWeight.bold,
// //                                       fontSize: 20,
// //                                       color: Colors.black),
// //                                 )),
// //                           ),
// //                         ),
// //                         const SizedBox(
// //                           height: 30,
// //                         ),
// //                         Row(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Text(AppLocalizations.of(context)!.donthaveaccount),
// //                             TextButton(
// //                                 onPressed: () {
// //                                   Navigator.push(
// //                                       context,
// //                                       MaterialPageRoute(
// //                                           builder: (_) => const SignUp()));
// //                                 },
// //                                 child:
// //                                     Text(AppLocalizations.of(context)!.signup))
// //                           ],
// //                         ),
// //                         isLoginTrue
// //                             ? const Text(
// //                                 "Username or password is incorrect",
// //                                 style: TextStyle(color: Colors.red),
// //                               )
// //                             : const SizedBox(),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   static final RegExp emailRegex = RegExp(
// //     r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
// //   );

// //   static bool isValidEmail(String email) {
// //     return emailRegex.hasMatch(email);
// //   }
// // }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto/crypto.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter_projects/presentation/providers/auth_provider.dart';
// import 'package:flutter_projects/presentation/providers/lang_provider.dart';
import 'package:flutter_projects/presentation/providers/userId_provider.dart';
import 'package:flutter_projects/presentation/views/home.dart';
import 'package:flutter_projects/presentation/views/home_for_manager.dart';
import 'package:flutter_projects/presentation/views/home_for_member.dart';
import 'package:flutter_projects/presentation/views/register.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isVisible = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<void> login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter email and password'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    String encryptedPassword = encryptPassword(password);

    Map<String, String> managerCredentials = {
      'dravid@gmail.com': 'Dravid@12',
      'sachin@gmail.com': 'Sachin@12',
      'ganguly@gmail.com': 'Ganguly@12',
    };

    Map<String, String> memberCredentials = {
      'nishanth@kumaran.com': 'Password@1',
      'kumaran@kumaran.com': 'Password@2',
      'murugan@kumaran.com': 'Password@3',
    };

    bool isAuthenticated = false;

    if (managerCredentials.containsKey(username) &&
        password == managerCredentials[username]) {
      isAuthenticated = true;
    } else if (memberCredentials.containsKey(username) &&
        password == memberCredentials[username]) {
      isAuthenticated = true;
    } else {
      isAuthenticated = await ref
          .read(authProvider.notifier)
          .login(username, encryptedPassword);
    }

    if (isAuthenticated) {
      final int? userId =
          await ref.read(userIdProvider.notifier).getUserId(username);
      if (managerCredentials.containsKey(username)) {
        if (context.mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const HomeForManager()));
        }
      } else if (memberCredentials.containsKey(username)) {
        if (context.mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => HomeForMember(
                        memberName: username,
                      )));
        }
      } else {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MyHomePage(
                title: "Kumaran's Projects",
                username: username,
                userId: userId,
              ),
            ),
          );
        }
      }
    } else {
      if (context.mounted) {
        AnimatedSnackBar.material('Invalid Credentials',
                type: AnimatedSnackBarType.warning)
            .show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.white,
                Colors.blue,
              ]),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                AppLocalizations.of(context)!.siginin,
                style: const TextStyle(
                    fontSize: 37,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 200.0,
                ),
                child: IntrinsicHeight(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 0.5),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Email is required";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  // suffixIcon: const Icon(
                                  //   Icons.check,
                                  //   color: Colors.grey,
                                  // ),
                                  // suffixIcon:
                                  //     isValidEmail(_usernameController.text)
                                  //         ? const Icon(
                                  //             Icons.check,
                                  //             color: Colors.green,
                                  //           )
                                  //         : null,
                                  label: Text(
                                AppLocalizations.of(context)!.email,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              )),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Password is required";
                                }
                                return null;
                              },
                              obscureText: !isVisible,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                ),
                                label: Text(
                                  AppLocalizations.of(context)!.password,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                              height: 70,
                            ),
                            Container(
                              height: 55,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Center(
                                child: TextButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      login();
                                    }
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.login,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.donthaveaccount,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.grey),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => const SignUp()));
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.signup,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._-]+@kumaran\.com$',
  );

  static bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }
}
