
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:whatsapp/screens/login_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:whatsapp/screens/splash_screen.dart';


Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (ctx, snapshot) => MaterialApp(
            title: 'Demo App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Color(0xff075E54),
              accentColor: Colors.white,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: StreamBuilder(
                stream:
                    FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SplashScreen();
                  }
                  else{
                    return LoginScreen();
                  }
                })));
  }
}
