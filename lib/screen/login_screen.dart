import 'package:firebase_app/res/color.dart';
import 'package:firebase_app/res/style.dart';
import 'package:firebase_app/service/firebase/firebase_auth_service.dart';
import 'package:firebase_app/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {

  // ไว้เช็ค state ฟอร์มว่ามีการกรอกข้อมูลหรือยัง
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  Widget buildOtherLine() {
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: Row(
          children: <Widget>[
          Expanded(child: Divider(color: Colors.green[800])),
          Padding(
              padding: EdgeInsets.all(6),
              child: Text("หรือ",
                  style: TextStyle(fontSize: 20.0, color: Colors.black87, fontWeight: FontWeight.bold),                  
                )
              ),
          Expanded(child: Divider(color: Colors.green[800])),
        ]
      )
    );
  }

  Widget buildButtonPhone(BuildContext context) {
    return InkWell(
      child: Container(
        constraints: BoxConstraints.expand(height: 50),
        child: Text("เข้าระบบด้วยเบอร์โทรศัพท์",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: Colors.white)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.pink
        ),
        margin: EdgeInsets.only(top: 12),
        padding: EdgeInsets.all(12)
      ),
      onTap: (){
        Navigator.pushNamed(context, '/phoneLogin');
      }
    );
  }

  Widget buildButtonGoogle(BuildContext context) {
    return InkWell(
      child: Container(
        constraints: BoxConstraints.expand(height: 50),
        child: Text("เข้าระบบด้วย Google",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: Colors.white)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.red
        ),
        margin: EdgeInsets.only(top: 12),
        padding: EdgeInsets.all(12)),
        onTap: () async {
          FirebaseAuthService().signInWithGoogle(context);
        }
    );
  }

  Widget buildButtonFacebook(BuildContext context) {
    return InkWell(
      child: Container(
        constraints: BoxConstraints.expand(height: 50),
        child: Text("เข้าสู่ระบบด้วย Facebook",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: Colors.white)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue
        ),
        margin: EdgeInsets.only(top: 12),
        padding: EdgeInsets.all(12)
        ),
        onTap: () async {
          // FirebaseAuthService().signInWithFacebook(context);
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เข้าสู่ระบบ', style: GoogleFonts.kanit()),
        backgroundColor: colorPrimaryDark,
      ),
      // SingleChildScrollView: ให้เลื่อนได้
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
            child: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 80,
                      height: 80,
                    ),
                    SizedBox(height: 50),
                    TextFormField(
                      // copyWith: copy คุณสมบัติของ Flutter
                      decoration: styleInputDecoration.copyWith(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      maxLines: 1,
                      style: styleTextFieldText,
                      onChanged: (value) => _email = value.toString(),
                      validator: (value) => value!.trim().isEmpty ? 'Enter email address': null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: styleInputDecoration.copyWith(labelText: 'Password'),
                      keyboardType: TextInputType.text,
                      // ป้อนแล้วเป็น ***
                      obscureText: true,
                      maxLines: 1,
                      style: styleTextFieldText,
                      onChanged: (value) => _password = value.toString(),
                      validator: (value) => value!.trim().isEmpty ? 'Enter password': null,
                    ),
                    SizedBox(height: 20),
                    ButtonWidget(
                      buttonText: 'เข้าสู่ระบบ',
                      onClick: (){
                        print(_email);
                        if(_formKey.currentState!.validate()) {
                          FirebaseAuthService().firebaseSignIn(context, _email!, _password!);
                        }
                      },
                    ),
                    
                    SizedBox(height: 10,),
                    buildOtherLine(),
                    SizedBox(height: 10,),
                    buildButtonPhone(context),
                    buildButtonGoogle(context),
                    buildButtonFacebook(context),
                    SizedBox(height: 20,),
        
                    InkWell(
                      child: RichText(
                        text: TextSpan(
                          text: "หากยังไม่เป็นสมาชิก ?",
                          style: styleSmallText,
                          children: [
                            TextSpan(
                              text: ' สมัครสมาชิกที่นี่',
                              style: styleSmallText.copyWith(
                                color: Theme.of(context).primaryColorDark,
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}