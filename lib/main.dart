import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:visiting_cards/Screens/generate_qrcode.dart';
import 'package:flutter/foundation.dart';


import 'Screens/home_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/my_cardscollection.dart';
import 'Screens/scan_qrcode.dart';
import 'Screens/update_card.dart';
import 'Services/firebase_auth_methods.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Visiting Cards',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(),
        routes: {
          'Home': (context) => const AuthWrapper(),
          'GenerateQR': (context) => const GenerateQR(),
          'ScanQR': (context) => const ScanQR(),
          'UpdateCard': (context) => const UpdateCard(),
          'MyCollection': (context) => const MyCollection(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const HomeScreen();
    }
    return const LoginScreen();
  }
}
