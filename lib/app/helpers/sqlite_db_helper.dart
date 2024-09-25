import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('santai.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        phone TEXT NOT NULL,
        fullName TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE motorcycles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        make TEXT NOT NULL,
        model TEXT NOT NULL,
        year INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE addresses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        isFavorite INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS addresses');
      await db.execute('''
        CREATE TABLE addresses (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          isFavorite INTEGER NOT NULL
        )
      ''');
    }
  }

  Future<int> createUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUser(int id) async {
    final db = await database;
    final results = await db.query('users', where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.update('users', user, where: 'id = ?', whereArgs: [user['id']]);
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> createMotorcycle(Map<String, dynamic> motorcycle) async {
    final db = await database;
    return await db.insert('motorcycles', motorcycle);
  }

  Future<List<Map<String, dynamic>>> getMotorcyclesForUser(int userId) async {
    final db = await database;
    return await db.query('motorcycles', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<int> createAddress(Map<String, dynamic> address) async {
    final db = await database;
    return await db.insert('addresses', {
      'name': address['name'],
      'latitude': address['latitude'],
      'longitude': address['longitude'],
      'isFavorite': address['isFavorite'],
    });
  }

  Future<List<Map<String, dynamic>>> getAddresses({bool? isFavorite}) async {
    final db = await database;
    if (isFavorite != null) {
      return await db.query('addresses', where: 'isFavorite = ?', whereArgs: [isFavorite ? 1 : 0]);
    }
    return await db.query('addresses');
  }

  Future<int> updateAddress(Map<String, dynamic> address) async {
    final db = await database;
    return await db.update('addresses', address, where: 'id = ?', whereArgs: [address['id']]);
  }

  Future<int> deleteAddress(int id) async {
    final db = await database;
    return await db.delete('addresses', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertDummyAddresses() async {
    final addresses = [
      {
        'name': 'Kontrakan',
        'latitude': -6.3164,
        'longitude': 107.0089,
        'isFavorite': 1
      },
      {
        'name': 'Kantor',
        'latitude': -6.2888,
        'longitude': 106.9456,
        'isFavorite': 1
      },
      {
        'name': 'Burangkeng',
        'latitude': -6.3377,
        'longitude': 107.0253,
        'isFavorite': 0
      },
    ];

    for (var address in addresses) {
      await createAddress(address);
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}