import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/user_model.dart';
import 'constants.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._init();
  DatabaseProvider._init();
  static Database? _database;
  Future<Database>? get database async {
    if (_database != null) _database;
    _database = await _initDB();
    return _database!;
  }

  Future<Database>? _initDB() async {
    String path = join(await getDatabasesPath(), 'UserDatabase.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database database, int version) async {
    await database.execute('''  
    CREATE TABLE $tableUser (
    $columnID $idType,
    $columnTitle $textType,
    $columnDesc $textType,
    $columnDate $textType
    )
    ''');
  }

  /// CRUD

  // Update
  Future<void> updateUser(UserModel userModel) async {
    final db = await instance.database;
    db!.update(
      tableUser,
      userModel.toMap(),
      where: '$columnID = ?',
      whereArgs: [userModel.id],
    );
  }

  // Create
  Future<void> createUser(UserModel userModel) async {
    final db = await instance.database;
    db!.insert(
      tableUser,
      userModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Delete
  Future<void> deleteUser(int? id) async {
    final db = await instance.database;
    db!.delete(
      tableUser,
      where: '$columnID = ?',
      whereArgs: [id],
    );
  }

  // Read One Element
  Future<UserModel> readOneElement(int? id) async {
    final db = await instance.database;
    final data = await db!.query(
      tableUser,
      where: '$columnID ? =',
      whereArgs: [id],
    );
    return data.isNotEmpty
        ? UserModel.fromMap(data.first)
        : throw Exception('There is no Data');
  }

  // Read All Elements
  Future<List<UserModel>> readAllElements() async {
    final db = await instance.database;
    final data = await db!.query(tableUser);
    return data.isNotEmpty
        ? data.map((e) => UserModel.fromMap(e)).toList()
        : [];
  }
}
