import 'package:firebase_app/screen/phone_login_screen.dart';
import 'package:firebase_app/screen/home_screen.dart';
import 'package:firebase_app/screen/login_screen.dart';
import 'package:firebase_app/screen/register_screen.dart';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

const routeHome = '/home';
const routeLogin = '/login';
const routeRegister = '/register';
const routePhoneLogin = '/phoneLogin';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeLogin:
        return PageTransition(
          child: LoginScreen(), 
          // เลื่อนจากซ้ายไปขวา
          type: PageTransitionType.leftToRight
        );
      case routeRegister:
        return PageTransition(
          child: RegisterScreen(), 
          type: PageTransitionType.rightToLeft
        );
      case routeHome:
        return PageTransition(
          child: HomeScreen(), 
          type: PageTransitionType.rightToLeft
        );
      case routePhoneLogin:
        return PageTransition(
          child: PhoneLoginScreen(), 
          type: PageTransitionType.rightToLeft
        );

      // ครั้งแรกที่ยังไม่ได้กดไปไหน จะมาหน้า Login
      default:
        return PageTransition(
          child: LoginScreen(), 
          type: PageTransitionType.rightToLeft
        );
    }
  }
}