import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo App'),
        actions: [
          PopupMenuButton(
                                itemBuilder: (_) => [
                                  PopupMenuItem(
                                    child: Text('Logout'),
                                    value: 1,
                                  )
                                ],
                                icon: Icon(Icons.more_vert),
                                onSelected: (item){
                                  if(item==1){
                                    FirebaseAuth.instance.signOut();
                                  }}
      )],),
      body: Center(
        child: Text('Welcome'),
      ),
    );
  }
}
