import 'dart:convert';

import 'package:firebase_app/widget/bottom_sheet_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:http/http.dart' as http;

class FirebaseAuthService {

  // เรียก Obj ของ Firebase
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static Stream<User?> firebaseListener = _firebaseAuth.authStateChanges();

  static GoogleSignIn _googleSignIn = GoogleSignIn();
  static FacebookLogin _facebookLogin = FacebookLogin();

  // ==============================================================================
  // สร้างฟังก์ชันสำหรับการสมัครสมาชิกด้วยเบอร์โทรศัพท์และยืนยันด้วย SMS OTP
  // ==============================================================================
  Future createUserWithPhone(BuildContext context, String phone) async {
    _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      // ตั้งเวลาอายุ OTP (ใส่ 0 คือ OTP ไม่มีวันหมดอายุ)
      timeout: Duration(seconds: 60),
      // ยืนยันเบอร์ถูก
      verificationCompleted: (AuthCredential authCredential){
        _firebaseAuth.signInWithCredential(authCredential).then((UserCredential result){
          Navigator.of(context).pop(); // to pop the dialog box
          Navigator.of(context).pushReplacementNamed('/home');
        }).catchError((e) {
          print("Error complete");
          return "error";
        });
      },
      // ยืนยันเบอร์ผิด
      verificationFailed: (FirebaseAuthException exception) {
        // return "error";
      },
      // จังหวะกรอกเลข OTP
      // verificationId: firebase จะส่งเป็น Id สำหรับเปรียบเทียบกับเลข OTP ที่ User กรอก
      // forceResendingToken: ทุกครั้งที่มีการส่ง SMS แล้ว Token จะมีการเปลี่ยนไปทุกครั้ง เพื่อให้ไม่ซ้ำกัน
      codeSent: (String verificationId, int? forceResendingToken) {
        final _codeController = TextEditingController();
        showDialog(
          context: context,
          // false: ทำให้ Pop-up นี้ปิดไม่ได้
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text("ป้อนรหัส OTP ที่ได้รับ"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // พื้นที่ป้อน OTP
                TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("ยืนยัน"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  // PhoneAuthProvider.credential: การเอาค่าที่ User กรอกมาเปรียบเทียบ
                  var _credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: _codeController.text.trim());
                  // ถ้าตรงกันก็ผ่าน -> เปลี่ยนไปหน้า Home
                  _firebaseAuth.signInWithCredential(_credential).then((UserCredential result){
                    Navigator.of(context).pop(); // to pop the dialog box
                    Navigator.of(context).pushReplacementNamed('/home');
                  }).catchError((e) {
                    BottomSheetWidget().bottomSheet(context, "มีข้อผิดพลาด", "ป้อนรหัส OTP ไม่ถูกต้อง");
                  });
                },
              )
            ],
          ),
        );
      },
      // ถ้าเวลาหมดจะให้ verificationId = ค่าที่ User กรอกเลย
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
      }
    );
  }

  // ==============================================================================
  // สร้างฟังก์ชันสำหรับเข้าระบบด้วย Google Gmail
  // ==============================================================================
  Future signInWithGoogle(BuildContext context) async {

    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    // นำ account มา authentication
    final GoogleSignInAuthentication _googleAuth = await account!.authentication;
    // ตรวจสอบ token
    final AuthCredential _credential = GoogleAuthProvider.credential(
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );
    // ถ้า token ตรง -> ไปหน้า Home
    _firebaseAuth.signInWithCredential(_credential).then((UserCredential result){
      Navigator.of(context).pushReplacementNamed('/home');
    }).catchError((e) {
      BottomSheetWidget().bottomSheet(context, "มีข้อผิดพลาด", "ข้อมูลการ Sign In ไม่ถูกต้อง");
    });
    
    // return (
    //   await _firebaseAuth.signInWithCredential(credential)
    // ).user.uid;
  }

  // ==============================================================================
  // สร้างฟังก์ชันสำหรับเข้าระบบด้วย Facebook
  // ==============================================================================
  Future signInWithFacebook(BuildContext context) async {
    final FacebookLoginResult result = await _facebookLogin.logIn(
      permissions: [
        FacebookPermission.email
      ]
    );

    switch (result.status) {
      case FacebookLoginStatus.success:
        
        final String token = result.accessToken!.token;
        // อ่านข้อมูลของ User
        final response = await http.get(Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}'));
        final profile = jsonDecode(response.body);
        print(profile);

        // ยังไม่ได้เก็บข้อมูล
        // Navigator.pushReplacementNamed(context, '/home');
        break;
      case FacebookLoginStatus.cancel:
        BottomSheetWidget().bottomSheet(context,"มีข้อผิดพลาด","ผู้ใช้ยกเลิกการเข้าใช้งาน");
        break;
      case FacebookLoginStatus.error:
        BottomSheetWidget().bottomSheet(context,"มีข้อผิดพลาด","มีข้อผิดพลาด ${result.error.toString()} ในระหว่างการเข้าใช้งาน");
        break;
    }
  }

  // ==============================================================================
  // สร้างฟังก์ชันสำหรับการ login ด้วย Email
  // ==============================================================================
  Future firebaseSignIn(BuildContext context, String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacementNamed(context, '/home');

    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        BottomSheetWidget().bottomSheet(context, "มีข้อผิดพลาด", "ป้อนอีเมล์ไม่ถูกต้อง");
      } else if (e.code == 'user-not-found') {
        BottomSheetWidget().bottomSheet(context, "มีข้อผิดพลาด", "ไม่พบอีเมล์นี้ในระบบ");
      } else if (e.code == 'wrong-password') {
        BottomSheetWidget().bottomSheet(context, "มีข้อผิดพลาด", "รหัสผ่านไม่ถูกต้อง");
      } else {
        print(e.code);
      }

    } catch (e) {
      print(e);
    }
  }

  // ==============================================================================
  // สร้างฟังก์ชันสำหรับการ regsiter ด้วย Email
  // ==============================================================================
  Future firebaseRegister(BuildContext context,String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacementNamed(context, '/home');      
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        BottomSheetWidget().bottomSheet(context, "มีข้อผิดพลาด", "รหัสผ่านสั้นหรือง่ายเกินไป ไม่ปลอดภัย");
      } else if (e.code == 'email-already-in-use') {
        BottomSheetWidget().bottomSheet(context, "มีข้อผิดพลาด", "มีบัญชีนี้อยู่แล้วในระบบ ลองใช้อีเมล์อื่น");
      } else if(e.code == 'invalid-email'){
        BottomSheetWidget().bottomSheet(context, "มีข้อผิดพลาด", "รูปแบบอีเมล์ไม่ถูกต้อง");
      }
      return false;

    } catch (e) {
      print(e);
      return false;
    }
  }

  // ==============================================================================
  // สร้างฟังก์ชันสำหรับการดึงข้อมูล User ออกมาใช้
  // ==============================================================================
  static firebaseUserDetail() {
    final User user = _firebaseAuth.currentUser!;
    return user;
  }


  // ==============================================================================
  // สร้างฟังก์ชันสำหรับการ logout
  // ==============================================================================
  Future firebaseLogout() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

} 