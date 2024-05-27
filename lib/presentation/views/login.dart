// import 'dart:convert';

// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_projects/presentation/providers/auth_provider.dart';
// import 'package:flutter_projects/presentation/providers/userId_provider.dart';
// import 'package:flutter_projects/presentation/views/member_home.dart';
// import 'package:flutter_projects/presentation/views/register.dart';
// import 'package:flutter_projects/presentation/views/home.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({
//     super.key,
//   });

//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool isVisible = false;
//   bool isLoginTrue = false;

//   String encryptPassword(String password) {
//     final bytes = utf8.encode(password);
//     final hash = sha256.convert(bytes);
//     return hash.toString();
//   }

//   Future<void> login() async {
//     final String username = _usernameController.text;
//     final String password = _passwordController.text;

//     if (username.isEmpty || password.isEmpty) {
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
//     // print("original password: $password");
//     // print("encrypted password: $encryptedPassword");

//     // Define separate credentials for managers and members
//     Map<String, String> managerCredentials = {
//       'Dravid@gmail.com': 'Dravid@12',
//       'Sachin@gmail.com': 'Sachin@12',
//       'Ganguly@gmail.com': 'Ganguly@12',
//     };

//     Map<String, String> memberCredentials = {
//       'Nishanth@gmail.com': 'Member112',
//       'Kohli@gmail.com': 'Member212',
//       'Dhoni@gmail.com': 'Member312',
//       'Starc@gmail.com': 'Member312',
//       'Root@gmail.com': 'Member312',
//       'Smith@gmail.com': 'Member312',
//       'Hazlewood@gmail.com': 'Member312',
//       'Bairstow@gmail.com': 'Member312',
//       'Amla@gmail.com': 'Member312',
//     };

//     bool isAuthenticated = false;

//     if (username.contains('member') && password == 'Member12') {
//       isAuthenticated = true;
//     } else {
//       isAuthenticated = await ref
//           .read(authProvider.notifier)
//           .login(username, encryptedPassword);
//     }

//     if (isAuthenticated) {
//       final int? userId =
//           await ref.read(userIdProvider.notifier).getUserId(username);
//       if (username.contains('member')) {
//         if (context.mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => const MemberHomeScreen(),
//             ),
//           );
//         }
//       } else {
//         if (context.mounted) {
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
//         showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//             title: const Text('Error'),
//             content: const Text('Invalid credentials'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     }
//   }

//   final formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Form(
//               key: formKey,
//               child: Column(
//                 children: [
//                   Image.asset(
//                     "assets/image1.png",
//                     width: 210,
//                   ),
//                   const SizedBox(height: 15),
//                   Container(
//                     margin: const EdgeInsets.all(8),
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.lightBlue.withOpacity(.2)),
//                     child: TextFormField(
//                       controller: _usernameController,
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return "Username is required";
//                         }
//                         if (!isValidEmail(value)) {
//                           return "Invalid email";
//                         }
//                         return null;
//                       },
//                       decoration: const InputDecoration(
//                         icon: Icon(Icons.person),
//                         border: InputBorder.none,
//                         hintText: "User Email",
//                       ),
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.all(8),
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.lightBlue.withOpacity(.2)),
//                     child: TextFormField(
//                       controller: _passwordController,
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return "Password is required";
//                         }
//                         return null;
//                       },
//                       obscureText: !isVisible,
//                       decoration: InputDecoration(
//                           icon: const Icon(Icons.lock),
//                           border: InputBorder.none,
//                           hintText: "Password",
//                           suffixIcon: IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   isVisible = !isVisible;
//                                 });
//                               },
//                               icon: Icon(isVisible
//                                   ? Icons.visibility
//                                   : Icons.visibility_off))),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Container(
//                     height: 55,
//                     width: MediaQuery.of(context).size.width * .9,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.lightBlue),
//                     child: TextButton(
//                         onPressed: () {
//                           if (formKey.currentState!.validate()) {
//                             login();
//                           }
//                         },
//                         child: const Text(
//                           "LOGIN",
//                           style: TextStyle(color: Colors.white),
//                         )),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Don't have an account?"),
//                       TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) => const SignUp()));
//                           },
//                           child: const Text("SIGN UP"))
//                     ],
//                   ),
//                   isLoginTrue
//                       ? const Text(
//                           "Username or password is incorrect",
//                           style: TextStyle(color: Colors.red),
//                         )
//                       : const SizedBox(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   static final RegExp emailRegex = RegExp(
//     r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
//   );

//   static bool isValidEmail(String email) {
//     return emailRegex.hasMatch(email);
//   }
// }

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/presentation/providers/auth_provider.dart';
import 'package:flutter_projects/presentation/providers/userId_provider.dart';
import 'package:flutter_projects/presentation/views/home_for_manager.dart';
import 'package:flutter_projects/presentation/views/home_for_member.dart';
import 'package:flutter_projects/presentation/views/member_home.dart';
import 'package:flutter_projects/presentation/views/register.dart';
import 'package:flutter_projects/presentation/views/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isVisible = false;
  bool isLoginTrue = false;

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
      'Nishanth@gmail.com': 'Member112',
      'Kohli@gmail.com': 'Member212',
      'Dhoni@gmail.com': 'Member312',
      'Starc@gmail.com': 'Member312',
      'Root@gmail.com': 'Member312',
      'Smith@gmail.com': 'Member312',
      'Hazlewood@gmail.com': 'Member312',
      'Bairstow@gmail.com': 'Member312',
      'Amla@gmail.com': 'Member312',
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
        // Navigate to manager's home screen
        if (context.mounted) {
          // Handle manager navigation
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeForManager()));
        }
      } else if (memberCredentials.containsKey(username)) {
        // Navigate to member's home screen
        if (context.mounted) {
          // Handle member navigation
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeForMember()));
        }
      } else {
        // Navigate to default home screen
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
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Invalid credentials'),
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
      }
    }
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Image.asset(
                    "assets/image1.png",
                    width: 210,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.lightBlue.withOpacity(.2)),
                    child: TextFormField(
                      controller: _usernameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Username is required";
                        }
                        if (!isValidEmail(value)) {
                          return "Invalid email";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "User Email",
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.lightBlue.withOpacity(.2)),
                    child: TextFormField(
                      controller: _passwordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          border: InputBorder.none,
                          hintText: "Password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon(isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.lightBlue),
                    child: TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            login();
                          }
                        },
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SignUp()));
                          },
                          child: const Text("SIGN UP"))
                    ],
                  ),
                  isLoginTrue
                      ? const Text(
                          "Username or password is incorrect",
                          style: TextStyle(color: Colors.red),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
  );

  static bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }
}
