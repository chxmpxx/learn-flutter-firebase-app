import 'package:flutter/material.dart';
import 'package:firebase_app/res/style.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({ this.buttonText, this.onClick});

  final String? buttonText;
  // VoidCallback = void Function()
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 45,
      child: FlatButton(
        onPressed: onClick,
        child: Text(
          buttonText!,
          style: styleButtonText,
          textAlign: TextAlign.center
        ),
        color: Theme.of(context).primaryColorDark,
        // splashColor: hover
        splashColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
      ),
    );
  }
}