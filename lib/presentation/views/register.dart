import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/presentation/providers/auth_provider.dart';
import 'package:flutter_projects/presentation/views/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passObscured = true;
  bool _confirmPassObscured = true;

  bool isVisible = false;

  String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  void signUp() async {
    final String username = usernameController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: const Text("Passwords didn't match"),
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

    final encryptedPassword = encryptPassword(password);
    // print("encryption while sign up--->$encryptedPassword");

    final authNotifier = ref.read(authProvider.notifier);

    await authNotifier.signup(username, encryptedPassword);

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/image1.png",
                    width: 175,
                    height: 175,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.lightBlue.withOpacity(.2)),
                    child: TextFormField(
                      controller: usernameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [LengthLimitingTextInputFormatter(20)],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email is required";
                        }
                        if (!isValidEmail(value)) {
                          return "Invalid email. Must be @kumaran.com";
                        }
                        if (!value.endsWith('@kumaran.com')) {
                          return 'Only emails ending with @kumaran.com are allowed';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        icon: const Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.email,
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
                      controller: passwordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [LengthLimitingTextInputFormatter(15)],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password is required";
                        }
                        if (!isValidPassword(value)) {
                          return "Password must contain at least 8 characters,\n including one uppercase letter,\n one lowercase letter,\n and one number";
                        }
                        return null;
                      },
                      obscureText: _passObscured,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.password,
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passObscured = !_passObscured;
                                });
                              },
                              icon: Icon(_passObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility))),
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
                      controller: confirmPasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [LengthLimitingTextInputFormatter(15)],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Confirm password is required";
                        }
                        if (passwordController.text != value) {
                          return "Passwords did not match";
                        }
                        return null;
                      },
                      obscureText: _confirmPassObscured,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          border: InputBorder.none,
                          hintText:
                              AppLocalizations.of(context)!.confirmpassword,
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _confirmPassObscured = !_confirmPassObscured;
                                });
                              },
                              icon: Icon(_confirmPassObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility))),
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
                          // print('Sign Up button pressed');
                          if (_formKey.currentState!.validate()) {
                            signUp();
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context)!.signup,
                          style: const TextStyle(color: Colors.white),
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.alreadyhaveaccount),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: Text(AppLocalizations.of(context)!.login),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._-]+@kumaran\.com$',
  );

  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  static bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return passwordRegex.hasMatch(password);
  }
}
