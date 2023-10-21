// import 'package:maju/data/entity/users.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(""" 
    CREATE TABLE products(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      product_name TEXT,
      stock INTEGER,
      price DOUBLE,
      image TEXT
    );
  """);
    await database.execute("""
    CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      email TEXT,
      password TEXT,
      username TEXT,
      phone TEXT,
      address TEXT
    );
  """);
    await database.execute("""
      CREATE TABLE profil(
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT
      );
    """); 
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('maju.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> addProduct(
      String productName, double price, int stock, String image) async {
    final db = await SQLHelper.db();
    final data = {
      'product_name': productName,
      'stock': stock,
      'price': price,
      'image': image
    };

    return await db.insert('products', data);
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await SQLHelper.db();
    return db.query('products');
  }


  static Future<bool> login(String email, String password) async {
    final db = await SQLHelper.db();

    final List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    return users.isNotEmpty;
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await SQLHelper.db();
    return db.query('users');
  }

  static Future<int> addUser(String email, String password, String username,
      String phonenumber, String address) async {
    final db = await SQLHelper.db();
    final user = {
      'email': email,
      'password': password,
      'username': username,
      'phone': phonenumber,
      'address': address
    };
    return await db.insert('users', user);
  }

  static Future<int> updateProfile(int id, String name, String email) async {
  final db = await SQLHelper.db();
  final profile = {

    'name' : name,
    'email': email,
  };

  return await db.update('profile', profile,where: "id = $id");
}


}
