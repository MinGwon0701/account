import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'Account.dart';

final String tableName = 'account';

class DBHelper {
  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'example.db');

    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY,
            price INTEGER,
            category TEXT,
            detailContents TEXT,
            date TEXT,
            priceSign INTEGER
          )
        ''');
        },
        onUpgrade: (db, oldVersion, newVersion){}
    );
  }

  //Create
  createData(Account account) async {
    final db = await database;
    var res = await db.rawInsert('INSERT INTO $tableName(price, category, detailContents, date, priceSign) VALUES(?, ?, ?, ?, ?)',
        [account.price, account.category, account.detailContents, account.date, account.priceSign]);
    return res;
  }

  updateData(Account account, int id) async {
    final db = await database;
    return await db.rawUpdate('UPDATE account SET price = ?, category = ?, detailContents = ?, date = ?, priceSign = ? WHERE id = ?',[account.price, account.category, account.detailContents, account.date, account.priceSign, id]);
  }

  //Read
  Future<Account> getAccount(int id) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $tableName WHERE id = ?', [id]);

    return res.isNotEmpty ? Account(id: res.first['id'], price: res.first['price'], category: res.first['category'], detailContents: res.first['detailContents'], date: res.first['date'], priceSign: res.first['priceSign']) : Null;
  }

  //Read All
  Future<List<Account>> getAllAccount() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $tableName order by date desc');
    List<Account> list = res.isNotEmpty ? res.map((c) =>
        Account(id:c['id'], price:c['price'], category:c['category'], detailContents:c['detailContents'], date:c['date'], priceSign:c['priceSign'])).toList() : [];
    return list;
  }

  Future<List<Account>> getSomeAccount(String text) async {
    final db = await database;
    var res = await (text == '' ? db.rawQuery('SELECT * FROM $tableName order by date desc') : db.rawQuery("SELECT * FROM $tableName WHERE category LIKE '%$text%' order by date desc"));
    List<Account> list = res.isNotEmpty ? res.map((c) =>
        Account(id:c['id'], price:c['price'], category:c['category'], detailContents:c['detailContents'], date:c['date'], priceSign:c['priceSign'])).toList() : [];
    return list;
  }

  //Delete
  deleteAccount(int id) async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $tableName WHERE id = ?', [id]);
    return res;
  }

  //Delete All
  deleteAllAccount() async {
    final db = await database;
    db.rawDelete('DELETE FROM $tableName');
  }
}