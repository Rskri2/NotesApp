import 'package:flutter/cupertino.dart';
import 'package:noteapp/views/utilities/dialog/generic_dialog.dart';

Future<void> cannotShareEmptyDialog(BuildContext context) async{
 return showGenericDialog(
   context: context,
   title: 'Sharing',
   content: 'Cannot share an empty note!',
   optionsBuilder: ()=>{
     'OK':null,
   });
}
