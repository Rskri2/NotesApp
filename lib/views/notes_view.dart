import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your notes"),
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async{
              final shouldLogout = await showFutureDialog(context);
              print(shouldLogout);
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Log out"),
                ),
              ];
            },
          ),
        ],
      ),
      body: const Text("Main UI"),
    );
  }
}

Future<bool> showFutureDialog(BuildContext context){
  return showDialog<bool>(context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Log out?"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop(false);
            }, child: const Text("Cancel")),
            TextButton(onPressed: (){
              Navigator.of(context).pop(true);
            }, child: const Text("Log out"))
          ],
        );
      }).then((value)=>value ?? false);
  
}