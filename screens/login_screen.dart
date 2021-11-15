import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var isLogin = false;
  String strVerificationId;

  final TextEditingController controller = TextEditingController();

  final TextEditingController controllerCode = TextEditingController();

  verifyPhoneNumber(BuildContext context) async {
    String phoneNumber = "+91" + controller.text.toString();
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 5),
         codeSent: (String verificationId, int resendToken) async {
          
          strVerificationId=verificationId;
          
          
          
        },
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential authResult=await FirebaseAuth.instance.signInWithCredential(credential);
          print(credential);
          setState(() {
            isLogin = !isLogin;
          });
          
          await FirebaseFirestore.instance.collection('users').doc(authResult.user.uid).set({
            'phoneNumber': phoneNumber,
          });
        },
        verificationFailed: (FirebaseAuthException error) {
          if (error.code == 'invalid-phone-number') {
            print('The provided phone number is not valid');
          }
        },
       
        codeAutoRetrievalTimeout: (String verificationId) {
           strVerificationId=verificationId;
           
        });

  }
  void signInWithPhoneNumber () async{
          String smsCode = controllerCode.text;
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: strVerificationId, smsCode: smsCode);
         UserCredential authResult =await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
          await FirebaseFirestore.instance.collection('users').doc(authResult.user.uid).set({
            'phoneNumber': authResult.user.phoneNumber,
          });

        }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        title: Text(
          'Enter your phone number',
          style: TextStyle(color: Colors.green),
          textAlign: TextAlign.center,
        ),
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Help'),
                      value: 0,
                    ),
                  ])
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
              'We will send an SMS message to verify your phone number.'),
          TextField(
            cursorColor: Colors.green,
            keyboardType: TextInputType.phone,
            decoration:
                InputDecoration(labelText: 'phone number', prefixText: '+91'),
            controller: controller,
          ),
          Center(
              child: FlatButton(
            onPressed: () => verifyPhoneNumber(context),
            child: Text('SEND CODE'),
            color: Colors.green,
          )),
          TextField(
            cursorColor: Colors.green,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Code'),
            controller: controllerCode,
          ),
          Center(
              child: FlatButton(
            onPressed:()async{
              signInWithPhoneNumber();},
            child: Text('VERIFY'),
            color: Colors.green,
          )),
        ],
      ),
    );
  }
}
