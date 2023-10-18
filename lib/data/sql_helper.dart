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
      )
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
}
