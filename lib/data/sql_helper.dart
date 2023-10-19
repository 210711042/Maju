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
    await database.execute(""" 
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        email TEXT,
        password TEXT
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

  static Future<void> addUser(String email, String password, String username, String phonenumber, String address) async {
    final db = await SQLHelper.db();
    final user = User(id: 0, email: email, password: password, username:username, phonenumber: phonenumber, address:address ); // Anda perlu menyertakan ID jika sesuai dengan definisi di class User
    await SQLHelper.insertUser(user);
  }


    static Future<void> insertUser(User user) async {
    final db = await SQLHelper.db();
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<bool> login(String email, String password) async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> users = await db.query('users');
    for (var user in users) {
      if (user['email'] == email && user['password'] == password) {
        return true;
      }
    }
    return false;
  }

  static Future<List<User>> getUsers() async {
  final db = await SQLHelper.db();
  final List<Map<String, dynamic>> userMaps = await db.query('users');
  return List.generate(userMaps.length, (index) {
    return User(
      id: userMaps[index]['id'],
      email: userMaps[index]['email'],
      password: userMaps[index]['password'],
      username: userMaps[index]['username'],
      phonenumber: userMaps[index]['phonenumber'],
      address: userMaps[index]['address'],
      );
    });
  }

}


class User {
  final int id;
  final String email;
  final String password;
  final String username;
  final String phonenumber;
  final String address;

  User({required this.id, required this.email, required this.password, required this.username, required this.phonenumber, required this.address});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'username' : username,
      'phonenumber' : phonenumber,
      'address' : address,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      username : map['username'],
      phonenumber : map['phonenumber'],
      address : map['address'],
    );
  }
}
