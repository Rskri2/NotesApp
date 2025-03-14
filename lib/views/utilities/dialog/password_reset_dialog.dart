import 'package:flutter/material.dart';
import 'package:noteapp/views/utilities/dialog/generic_dialog.dart';

Future<void> showPasswordResetDialog(BuildContext context){
  return showGenericDialog(
    context: context,
    title: 'Password Reset',
    content: 'We have sent you a password reset link. Please check your email for more information',
    optionsBuilder: ()=>{
      'OK':null,
    },);
}