import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/app/tasks/second_page.dart';
import 'package:to_do_app/helpers/size_helper.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    Key? key,
  }) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          if (user == null) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(
                    SizeHelper.getSizeFromPx(context, 55),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign in',
                        style: GoogleFonts.poppins(
                          fontSize: SizeHelper.getSizeFromPx(context, 55),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: SizeHelper.getSizeFromPx(context, 55),
                      ),
                      TextField(
                        controller: widget.emailController,
                        decoration: const InputDecoration(hintText: 'E-mail'),
                      ),
                      TextField(
                        controller: widget.passwordController,
                        decoration: const InputDecoration(hintText: 'Password'),
                        obscureText: true,
                      ),
                      SizedBox(
                        height: SizeHelper.getSizeFromPx(context, 55),
                      ),
                      Text(
                        errorMessage,
                        style: GoogleFonts.poppins(
                          fontSize: SizeHelper.getSizeFromPx(context, 35),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        height: SizeHelper.getSizeFromPx(context, 55),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: widget.emailController.text,
                                    password: widget.passwordController.text);
                          } catch (error) {
                            setState(() {
                              errorMessage = error.toString();
                            });
                          }
                        },
                        child: Text(
                          'Sign in',
                          style: GoogleFonts.poppins(
                            fontSize: SizeHelper.getSizeFromPx(context, 45),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return SecondPage();
        });
  }
}
