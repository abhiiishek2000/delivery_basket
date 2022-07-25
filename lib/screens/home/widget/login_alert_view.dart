import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:delivery_basket/screens/login/login_screen.dart';

loginAlertShow(BuildContext context) {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: Text("Continue"),
    onPressed:  () {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen(isShowBack: true,)), (route) => false);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("AlertDialog"),
    content: Text("Please login first to perform operation?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}