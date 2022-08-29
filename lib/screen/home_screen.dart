import 'package:firebase_app/res/color.dart';
import 'package:firebase_app/service/firebase/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var getUser = FirebaseAuthService.firebaseUserDetail();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        backgroundColor: colorPrimaryDark,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app), 
            onPressed: () {
              FirebaseAuthService().firebaseLogout();
              Navigator.pushReplacementNamed(context, '/login');
            }
          )
        ],
      ),
      body: Center(
        // child: Text('${userEmail ?? getUser.phoneNumber}'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${getUser?.email ?? "..."}'),
            Text('Mobile: ${getUser?.phoneNumber ?? "..."}'),
          ],
        ),
      ),
    );
  }
}