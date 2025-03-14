import 'package:flutter/material.dart';
import 'package:noteapp/services/auth/auth_service.dart';
import 'package:noteapp/services/cloud/cloud_note.dart';
import 'package:noteapp/services/cloud/firebase_cloud_storage.dart';
import 'package:noteapp/views/utilities/generics/get_arguments.dart';
import 'package:share_plus/share_plus.dart';
import '../utilities/dialog/cannot_share_empty_dialog.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {

  CloudNote? _note;
  
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;
  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfNotEmpty();
    _textController.dispose();
  }

  void _textEditingController () async{
    final note = _note;
    final text = _textController.text;
    if(note != null && text.isNotEmpty){
      await _notesService.updateNote(documentId: note.documentId, text: text);
    }
  }

  void setUpTextController ()async{
    _textController.removeListener(_textEditingController);
    _textController.addListener(_textEditingController);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async{
    final widgetNote = context.getArguments<CloudNote>();
    if(widgetNote != null){
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }
    final existingNote = _note;
    if(existingNote != null){
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote =  await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() async{
    final note = _note;
    if(_textController.text.isEmpty){
      await _notesService.deleteNote(documentId: note!.documentId);
    }
  }
  void _saveNoteIfNotEmpty()async{
    final note = _note;
    final text = _textController.text;
    if(note != null && text.isNotEmpty){
      await _notesService.updateNote(documentId: note.documentId, text: text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
        actions: [
          IconButton(onPressed: () async{
            final text = _textController.text;
            if(_note == null || text.isEmpty){
              await cannotShareEmptyDialog(context);
            }
            else{
              Share.share(text);
            }
          }, icon: Icon(Icons.share))
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.done:
                setUpTextController();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Start typing your note...',
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          },)

    );
  }
}
