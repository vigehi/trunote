// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
//   static Database? _database;

//   DatabaseHelper._privateConstructor();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     final path = join(await getDatabasesPath(), 'notes_database.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _createDatabase,
//     );
//   }

//   Future<void> _createDatabase(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE notes(
//         noteID TEXT PRIMARY KEY,
//         title TEXT,
//         content TEXT,
//         dateCreated TEXT,
//         dateModified TEXT,
//         syncStatus TEXT,
//         version INTEGER,
//         isDeleted INTEGER
//       )
//     ''');
//   }
// }
