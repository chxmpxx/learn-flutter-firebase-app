import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app/res/color.dart';
import 'package:firebase_app/route/routes.dart';
import 'package:firebase_app/screen/home_screen.dart';
import 'package:firebase_app/screen/login_screen.dart';
import 'package:firebase_app/service/firebase/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ทำเป็น Future เพราะจะมีการอ่านค่าจาก firebase เข้ามา

Future<void> main() async {
  // กำหนดให้รองรับการอ่าน api ผ่าน https
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // กำหนดให้แสดงผลเฉพาะแนวตั้ง
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: colorPrimaryDark,
      systemNavigationBarColor: colorPrimaryDark
    )
  );

  runApp(
    // StreamProvider: เหมาะสำหรับการอ่านข้อมูลแบบ real-time database เพราะทำงานต่อเนื่องตลอดเวลา เชื่อมทิ้งไว้ได้เลย
    // ส่วน MultiProvider: จะเชื่อมเป็นครั้ง ๆ
    StreamProvider(
      initialData: MyApp(),
      create: (BuildContext context) => FirebaseAuthService.firebaseListener,
      child: MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.kanitTextTheme(),
          primaryColorDark: colorPrimaryDark,
          accentColor: colorPrimaryDark,
          primaryColor: colorPrimary
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Routes.generateRoute,
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ถ้า Login แล้วจะพาไปหน้า Home
    return Provider.of<User?>(context) == null ? LoginScreen() : HomeScreen();
  }
}