// import 'dart:async';
//
// import 'package:learningdart/extensions/list/filter.dart';
// import 'package:learningdart/serivces/auth/auth_exception.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';
// import 'crud_exceptions.dart';
//
// class NotesService {
//
//   Database? _db;
//
//   List<DatabaseNotes> _notes = [];
//
//   DatabaseUser? _user;
//
//   NotesService._sharedInstance(){
//     _notesStreamController = StreamController<List<DatabaseNotes>>.broadcast(
//       onListen: (){
//         _notesStreamController.sink.add(_notes);
//       },
//     );
//   }
//
//   late final StreamController<List<DatabaseNotes>> _notesStreamController ;
//
//   Stream<List<DatabaseNotes>> get allNotes => _notesStreamController.stream.filter((note){
//     final currentUser = _user;
//     if(currentUser != null){
//       return note.userId == currentUser.id;
//     }
//     else{
//       throw UserShouldBeSetBeforeReadingNotesException();
//     }
//   });
//
//   static final NotesService _shared = NotesService._sharedInstance();
//
//   factory NotesService() => _shared;
//
//   Future<void> _cacheNotes() async {
//
//     final allNotes = await getAllNotes();
//     _notes = allNotes.toList();
//     _notesStreamController.add(_notes);
//   }
//
//   Database getDBOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseNotOpenException();
//     } else {
//       return db;
//     }
//   }
//
//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseNotOpenException();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }
//
//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenException();
//     }
//     try {
//       final docsPath = await getDatabasesPath();
//       final dbPath = join(docsPath, dbName);
//
//       final db =  await openDatabase(dbPath);
//       _db = db;
//       await db.execute(createUserTable);
//       await db.execute(createNotesTable);
//       await _cacheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentException();
//     }
//   }
//
//   Future<void>  ensureDBIsOpen()async{
//     try{
//       await open();
//     }
//     on DatabaseAlreadyOpenException{
//       //do nothing
//     }
//     catch(e){
//       print(e.toString());
//     }
//   }
//   Future<DatabaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async{
//     await ensureDBIsOpen();
//     try{
//       final user = await getUser(email: email);
//       if(setAsCurrentUser){
//         _user = user;
//       }
//       return user;
//     } on UserNotFoundException{
//       final user = await createUser(email: email);
//       if(setAsCurrentUser){
//         _user = user;
//       }
//       return user;
//     } catch(e){
//       rethrow;
//     }
//   }
//
//   Future<DatabaseNotes> createNote({required DatabaseUser owner}) async {
//     await ensureDBIsOpen();
//     final db = getDBOrThrow();
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw UserNotFoundException();
//     }
//     const text = '';
//     final noteId = await db.insert(noteTable, {
//       userIdColumn: owner.id,
//       textColumn: text,
//       isSyncedWithCloudColumn: 1,
//     });
//     final note = DatabaseNotes(
//       id: noteId,
//       userId: owner.id,
//       text: text,
//       isSyncedWithCloud: true,
//     );
//     _notes.add(note);
//     _notesStreamController.add(_notes);
//     return note;
//   }
//
//   Future<Iterable<DatabaseNotes>> getAllNotes() async {
//     await ensureDBIsOpen();
//     final db = getDBOrThrow();
//     final notes = await db.query(noteTable);
//     return notes.map((note) => DatabaseNotes.fromRow(note));
//   }
//
//   Future<DatabaseNotes> getNote({required int id}) async {
//     await ensureDBIsOpen();
//     final db = getDBOrThrow();
//     final results = await db.query(
//       noteTable,
//       limit: 1,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (results.isEmpty) {
//       throw CouldNotDeleteNoteException();
//     }
//     final notes = DatabaseNotes.fromRow(results.first);
//     _notes.removeWhere((note)=>note.id == id);
//     _notes.add(notes);
//     _notesStreamController.add(_notes);
//     return notes;
//   }
//
//   Future<DatabaseNotes> updateNote({
//     required DatabaseNotes note,
//     required String text,
//   }) async {
//     await ensureDBIsOpen();
//     final db = getDBOrThrow();
//     await getNote(id: note.id);
//     final updatedNote = await db.update(noteTable, {
//       textColumn: text,
//       isSyncedWithCloudColumn: 0,
//
//     },
//       where: 'id = ?',
//       whereArgs: [note.id]
//     );
//     if (updatedNote == 0) {
//       throw CouldNotFindNoteException();
//     }
//     final notes = await getNote(id: note.id);
//     _notes.removeWhere((notes)=>notes.id == note.id);
//     _notes.add(notes);
//     _notesStreamController.add(_notes);
//     return notes;
//   }
//
//   Future<void> deleteNote({required int id}) async {
//     await ensureDBIsOpen();
//     final db = getDBOrThrow();
//     final deletedCount = await db.delete(
//       noteTable,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (deletedCount == 0) {
//       throw CouldNotDeleteNoteException();
//     }
//     else{
//       _notes.removeWhere((note)=>note.id == id);
//       _notesStreamController.add(_notes);
//     }
//   }
//
//   Future<int> deleteAllNotes() async {
//     await ensureDBIsOpen();
//     final db = getDBOrThrow();
//     final deletedNotes =  await db.delete(noteTable);
//     _notes = [];
//     _notesStreamController.add(_notes);
//     return deletedNotes;
//   }
//
//   Future<DatabaseUser> createUser({required String email}) async {
//     await ensureDBIsOpen();
//     final db = getDBOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isNotEmpty) {
//       throw UserAlreadyExistsException();
//     }
//     int id = await db.insert(userTable, {emailColumn: email.toLowerCase()});
//     return DatabaseUser(id: id, email: email);
//   }
//
//   Future<DatabaseUser> getUser({required String email}) async {
//     await ensureDBIsOpen();
//     final db = getDBOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isEmpty) {
//       throw UserNotFoundException();
//     } else {
//       return DatabaseUser.fromRow(results.first);
//     }
//   }
//
//   Future<void> deleteUser({required String email}) async {
//     await ensureDBIsOpen();
//     final db = getDBOrThrow();
//     final deletedRows = await db.delete(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (deletedRows != 1) throw CouldNotDeleteUserException();
//   }
// }
//
// class DatabaseUser {
//   final int id;
//   final String email;
//   const DatabaseUser({required this.id, required this.email});
//   DatabaseUser.fromRow(Map<String, Object?> map)
//     : id = map[idColumn] as int,
//       email = map[emailColumn] as String;
//   @override
//   String toString() {
//     return "Person, ID =  $id, Email = $email";
//   }
//
//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;
//
//   @override
//   int get hashCode => id.hashCode;
// }
//
// class DatabaseNotes {
//   final int id;
//   final int userId;
//   final bool isSyncedWithCloud;
//   final String text;
//   DatabaseNotes({
//     required this.id,
//     required this.userId,
//     required this.text,
//     required this.isSyncedWithCloud,
//   });
//
//   DatabaseNotes.fromRow(Map<String, Object?> map)
//     : id = map[idColumn] as int,
//       userId = map[userIdColumn] as int,
//       text = map[textColumn] as String,
//       isSyncedWithCloud =
//           (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;
//
//   @override
//   String toString() {
//     return "Notes, Id = $id, text = $text, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud";
//   }
//
//   @override
//   bool operator ==(covariant DatabaseNotes other) => id == other.id;
//
//   @override
//   int get hashCode => id.hashCode;
// }
//
// const dbName = 'notes.db';
// const idColumn = 'id';
// const emailColumn = 'email';
// const userIdColumn = 'user_id';
// const textColumn = 'text';
// const isSyncedWithCloudColumn = 'is_synced_with_cloud';
// const noteTable = 'note';
// const userTable = 'user';
// const createNotesTable = '''CREATE TABLE IF NOT EXISTS "note" (
//           "user_id"	INTEGER,
//           "id"	INTEGER,
//           "is_synced_with_cloud"	INTEGER DEFAULT 0,
//           "text"	TEXT,
//           PRIMARY KEY("id" AUTOINCREMENT),
//           FOREIGN KEY("user_id") REFERENCES "user"("id")
//       );''';
// const createUserTable = '''CREATE TABLE IF NOT EXISTS "user"(
//         "id"	INTEGER NOT NULL,
//         "email"	TEXT NOT NULL UNIQUE,
//         PRIMARY KEY("id" AUTOINCREMENT)
//       );''';
