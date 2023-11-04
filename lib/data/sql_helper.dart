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
      address TEXT,
      profile_image TEXT
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
    print(data);
    return await db.insert('products', data);
  }

  static Future<int> editProduct(
      int id, String productName, double price, int stock, String image) async {
    final db = await SQLHelper.db();
    final data = {
      'product_name': productName,
      'price': price,
      'stock': stock,
      'image': image
    };
    print(data);
    return await db.update('products', data, where: "id = $id");
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await SQLHelper.db();
    return db.query('products');
  }

  static Future<int> deleteProduct(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('products', where: 'id = $id');
  }

  static Future<List> login(String email, String password) async {
    final db = await SQLHelper.db();

    final List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    return users;
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await SQLHelper.db();
    return db.query('users');
  }

  static Future<List<Map<String, dynamic>>> getUserById(int id) async {
    final db = await SQLHelper.db();
    return db.query('users', where: "id = $id");
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

  static Future<int> updateProfile(
      int id, String name, String email, String phone, String address) async {
    final db = await SQLHelper.db();
    final profile = {
      'username': name,
      'email': email,
      'phone': phone,
      'address': address
    };

    return await db.update('users', profile, where: "id = $id");
  }

  static Future<int> updateProfileImage(int id, String imagePath) async {
  final db = await SQLHelper.db();
  final data = {
    'profile_image': imagePath,
  };
  return await db.update('users', data, where: "id = ?", whereArgs: [id]);
}

}
