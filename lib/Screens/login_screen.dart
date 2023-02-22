import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visiting_cards/Services/firebase_auth_methods.dart';
import 'package:visiting_cards/constants/constants.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbgColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              child: Image.asset(
                  'assets/mycards.png',fit: BoxFit.cover,),
            ),
            const SizedBox(height: 15,),
            ElevatedButton(
              onPressed: () {
                context.read<FirebaseAuthMethods>().signInWithGoogle(context);
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kpred),),
              child: const Text('Google SignIn/SignUp',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
