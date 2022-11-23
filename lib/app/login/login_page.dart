import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/app/tasks/second_page.dart';
import 'package:to_do_app/helpers/size_helper.dart';

class LoginPage extends StatelessWidget {
  LoginPage({
    Key? key,
  }) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                        'Log in',
                        style: GoogleFonts.poppins(
                          fontSize: SizeHelper.getSizeFromPx(context, 55),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: SizeHelper.getSizeFromPx(context, 55),
                      ),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(hintText: 'E-mail'),
                      ),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(hintText: 'Password'),
                        obscureText: true,
                      ),
                      SizedBox(
                        height: SizeHelper.getSizeFromPx(context, 55),
                      ),
                      Text(
                        'You are not logged in',
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
                                    email: emailController.text,
                                    password: passwordController.text);
                          } catch (error) {
                            print(error);
                          }
                        },
                        child: Text(
                          'Log in',
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
