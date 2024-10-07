import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<void> deleteDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'santai.db');
  await databaseFactory.deleteDatabase(path);
  _database = null;
}


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
      CREATE TABLE addresses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        isFavorite INTEGER NOT NULL,
        isSelected INTEGER NOT NULL
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
          isFavorite INTEGER NOT NULL,
          isSelected INTEGER NOT NULL
        )
      ''');
    }
  }
   Future<Map<String, dynamic>?> getCurrentAddress() async {
    final db = await database;
    final results = await db.query('addresses', where: 'isSelected = 1', limit: 1);
    return results.isNotEmpty ? results.first : null;
   }

  Future<int> countAddressesBySelection() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM addresses WHERE isSelected = 1'
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }


  Future<int> createAddress(Map<String, dynamic> address) async {
    final db = await database;
    return await db.insert('addresses', {
      'name': address['name'],
      'latitude': address['latitude'],
      'longitude': address['longitude'],
      'isFavorite': address['isFavorite'],
      'isSelected': address['isSelected'],
    });
  }

  Future<int> updateAddress(Map<String, dynamic> address) async {
    final db = await database;
    return await db.update(
      'addresses', 
      {
        'name': address['name'],
        'latitude': address['latitude'],
        'longitude': address['longitude'],
        'isFavorite': address['isFavorite']
      }, 
      where: 'id = ?', 
      whereArgs: [address['id']]
    );
  }

  Future<int> updateClearAddressSelected() async {
    final db = await database;
    return await db.update(
      'addresses', 
      {
        'isSelected': 0
      }, 
      where: 'isSelected = ?', 
      whereArgs: [1]
    );
  }

  Future<int> setIsSelected(int id) async {
    final db = await database;
    return await db.update(
      'addresses', 
      {
        'isSelected': 1
      }, 
      where: 'id = ?', 
      whereArgs: [id]
    );
  }




  Future<List<Map<String, dynamic>>> getAddresses({bool? isFavorite}) async {
    final db = await database;
    if (isFavorite != null) {
      return await db.query('addresses', where: 'isFavorite = ?', whereArgs: [isFavorite ? 1 : 0]);
    }
    return await db.query('addresses');
  }

  Future<int> deleteAddress(int id) async {
    final db = await database;
    return await db.delete('addresses', where: 'id = ?', whereArgs: [id]);
  }

  // Future<void> insertDummyAddresses() async {
  //   final addresses = [
  //     {
  //       'name': 'Kontrakan',
  //       'latitude': -6.3164,
  //       'longitude': 107.0089,
  //       'isFavorite': 1
  //     },
  //     {
  //       'name': 'Kantor',
  //       'latitude': -6.2888,
  //       'longitude': 106.9456,
  //       'isFavorite': 1
  //     },
  //     {
  //       'name': 'Burangkeng',
  //       'latitude': -6.3377,
  //       'longitude': 107.0253,
  //       'isFavorite': 0
  //     },
  //   ];

  //   for (var address in addresses) {
  //     await createAddress(address);
  //   }
  // }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}