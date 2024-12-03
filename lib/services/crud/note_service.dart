import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'crud_exceptions.dart';

class Databaseservice {
  Database? _db;

  // Make singleton class
  static final _sharedinstance = Databaseservice._shared();
  Databaseservice._shared();
  factory Databaseservice() => _sharedinstance;

  //Local cache _notes
  List<Databasenotes> _notes = [];
  final _noteStreamController =
      StreamController<List<Databasenotes>>.broadcast();

  //Streams reatrive data from _noteStreamController
  Stream<List<Databasenotes>> get allnotes => _noteStreamController.stream;

// All Funtions
  Future<void> _cacheNote() async {
    final allnotes = await getallnote();
    _notes = allnotes.toList();
    _noteStreamController.add(_notes);
  }

  Future<Databaseuser> getorcreateuser({required String email}) async {
    try {
      final user = await getuser(email: email);
      return user;
    } on CouldNotFindUser {
      final createduser = createuser(email: email);
      return createduser;
    }
  }

  //Update all notes
  Future<Databasenotes> updatenote(
      {required Databasenotes note, required String text}) async {
    await _ensureDbIsOpen();
    final db = _getdborthrow();
    await getnote(id: note.id);

    final updatecount = await db.update(notetable, {
      textcolumn: text,
      isSynedWithCloudColumn: 0,
    });
    if (updatecount == 0) {
      throw CouldNotUpdateNote();
    } else {
      final updatednotes = await getnote(id: note.id);
      _notes.removeWhere((updatednotes) => note.id == updatednotes);
      _notes.add(updatednotes);
      _noteStreamController.add(_notes);
      return updatednotes;
    }
  }

//Get all notes
  Future<Iterable<Databasenotes>> getallnote() async {
    await _ensureDbIsOpen();
    final db = _getdborthrow();
    final notes = await db.query(notetable);
    return notes.map((notesrooow) => Databasenotes.fromRow(notesrooow));
  }

//Get note
  Future<Databasenotes> getnote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getdborthrow();
    final notes =
        await db.query(notetable, limit: 1, where: 'id=?', whereArgs: [id]);
    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      final note = Databasenotes.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _noteStreamController.add(_notes);
      return note;
    }
  }

  //Delete all notes
  Future<int> deleteallnote() async {
    await _ensureDbIsOpen();
    final db = _getdborthrow();
    final numofdeletion = await db.delete(notetable);
    _notes = [];
    _noteStreamController.add(_notes);
    return numofdeletion;
  }

//Delete User Note
  Future<void> deletenote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getdborthrow();
    final deletecount =
        await db.delete(notetable, where: 'id =?', whereArgs: [id]);
    if (deletecount == 0) {
      throw CouldNotFindNote();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _noteStreamController.add(_notes);
    }
  }

//Create Note
  Future<Databasenotes> createnote({required Databaseuser owner}) async {
    await _ensureDbIsOpen();
    final db = _getdborthrow();

    // Make sure owner exist in the database with current id
    final dbuser = await getuser(email: owner.email);
    if (dbuser != owner) {
      throw CouldNotFindUser();
    }
    //Now create user note
    final noteid = await db.insert(notetable, {
      useridcolumn: owner.id,
      textcolumn: '',
      isSynedWithCloudColumn: 1,
    });
    final note = Databasenotes(
        id: noteid, userId: owner.id, text: '', isSynedWithCloud: true);

    _notes.add(note);
    _noteStreamController.add(_notes);
    return note;
  }

  //Get user
  Future<Databaseuser> getuser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getdborthrow();
    final result = await db.query(usertable,
        limit: 1, where: 'email=?', whereArgs: [email.toLowerCase()]);
    if (result.isNotEmpty) {
      throw CouldNotFindUser();
    } else {
      return Databaseuser.fromRow(result.first);
    }
  }

  //Create user
  Future<Databaseuser> createuser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getdborthrow();
    final result = await db.query(usertable,
        limit: 1, where: 'email=?', whereArgs: [email.toLowerCase()]);
    if (result.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final userId = await db.insert(useridcolumn, {
      emailcolumn: email.toLowerCase(),
    });
    final user = Databaseuser(id: userId, email: email);
    return user;
  }

  //delete user
  Future<void> deleteuser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getdborthrow();
    final deletecount = await db.delete(
      usertable,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletecount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  //getdbbothrow
  Database _getdborthrow() {
    final db = _db;
    if (db == null) {
      throw DataBaseISNotOpen();
    } else {
      return db;
    }
  }

  // close db
  Future<void> closedb() async {
    final db = _db;
    if (db == null) {
      throw DataBaseISNotOpen;
    } else {
      await db.close();
      _db = null;
    }
  }

//ensure db is open
  Future<void> _ensureDbIsOpen() async {
    try {
      await opendb();
    } on DatabaseAlreadyOpenException {
      //empty
    }
  }

  //open database  or create database
  Future<void> opendb() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException;
    }
    try {
      final docPath = await getApplicationDocumentsDirectory();
      final dbpath = join(docPath.path, dbName);
      final db = await openDatabase(dbpath);
      _db = db;

      //create user table
      await db.execute(createusertable);
      //create notes table
      await db.execute(createnotetable);
      await _cacheNote();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectry;
    }
  }
}

class Databaseuser {
  final int id;
  final String email;
  Databaseuser({required this.id, required this.email});
  Databaseuser.fromRow(Map<String, Object?> map)
      : id = map[idcolumn] as int,
        email = map[emailcolumn] as String;

  @override
  String toString() => 'person id=$id and email=$email';

  bool operator ==(covariant Databaseuser other) => id == other.id;
  @override
  int get hashCode => id.hashCode;
}

class Databasenotes {
  final int id;
  final int userId;
  final String text;
  final bool isSynedWithCloud;

  Databasenotes(
      {required this.id,
      required this.userId,
      required this.text,
      required this.isSynedWithCloud});
  Databasenotes.fromRow(Map<String, Object?> map)
      : id = map[idcolumn] as int,
        userId = map[useridcolumn] as int,
        text = map[textcolumn] as String,
        isSynedWithCloud =
            (map[isSynedWithCloudColumn] as int) == 1 ? true : false;
  @override
  String toString() =>
      'person id=$id and userid=$userId and isSynedWithCloud=$isSynedWithCloud';

  bool operator ==(covariant Databasenotes other) => id == other.id;
  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const notetable = 'note';
const usertable = 'user';
const useridcolumn = 'userId';
const textcolumn = 'text';
const isSynedWithCloudColumn = 'isSynedWithCloud';
const idcolumn = 'id';
const emailcolumn = 'email';

const createusertable = '''CREATE TABLE IF NOT EXIST "user" (
	"id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';

const createnotetable = '''CREATE TABLE IF NOT EXIST "note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	"is_syned_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "user"("id")
);''';
