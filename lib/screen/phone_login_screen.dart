import 'package:firebase_app/res/color.dart';
import 'package:firebase_app/res/style.dart';
import 'package:firebase_app/service/firebase/firebase_auth_service.dart';
import 'package:firebase_app/widget/bottom_sheet_widget.dart';
import 'package:firebase_app/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneLoginScreen extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  String? _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เข้าสู่ระบบด้วยเบอร์โทรศัพท์', style: GoogleFonts.kanit(),),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 1,
                          child: IntlPhoneField(
                            decoration: InputDecoration(
                              labelText: 'ป้อนเบอร์โทรศัพท์',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            initialCountryCode: 'TH',
                            onChanged: (phone) {
                              _phoneNumber = phone.completeNumber;
                              print(phone.countryCode + '||' + phone.number + '=' + phone.completeNumber);
                            },
                            onCountryChanged: (country) {
                              print('Country changed to: ' + country.name);
                            },
                          ),
      
                          // international_phone_input v.เก่า
                          // child: InternationalPhoneInput(
                          //   // decoration: buildSignUpInputDecoration("Enter Phone Number"),
                          // onPhoneNumberChange:onPhoneNumberChange,
                          //   decoration: InputDecoration.collapsed(hintText: 'ป้อนเบอร์โทรศัพท์'),
                          //   labelStyle: styleTextFieldPhone,
                          //   initialPhoneNumber: _phoneNumber,
                          //   initialSelection: 'TH',
                          //   showCountryCodes: true),
                          // ),
                        ),
                        SizedBox(width: 20.0,),
                      ],
                    ),
                    SizedBox(height: 20.0,),
                    ButtonWidget(
                      buttonText: 'ส่งข้อมูล', 
                      onClick: () {
                        if(_formKey.currentState!.validate()){
                          if(_phoneNumber == "" || _phoneNumber == null){
                            BottomSheetWidget().bottomSheet(context, "มีข้อผิดพลาด", "รูปแบบเบอร์โทรศัพท์ไม่ถูกต้อง");
                          }else{
                            print(_phoneNumber);
                            var result = FirebaseAuthService().createUserWithPhone(context, _phoneNumber!);
                            if(result == "error"){
                              BottomSheetWidget().bottomSheet(context, "มีข้อผิดพลาด", "เบอร์โทรศัพท์ไม่ถูกต้อง");
                            }
                          }
                        }
                      }
                    ),
                  ],
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}