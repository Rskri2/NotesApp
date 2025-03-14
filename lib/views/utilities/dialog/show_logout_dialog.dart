import 'package:flutter/cupertino.dart';
import 'package:noteapp/views/utilities/dialog/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure to log out',
    optionsBuilder: ()=>{
      'Cancel': false,
      'Log out': true
    },
  ).then((value)=>value ?? false);
}
