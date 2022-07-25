import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:delivery_basket/data/local/model/ClientModel.dart';
import 'package:delivery_basket/data/local/model/recent_search_model.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/category_response.dart';

import 'model/CartModel.dart';

class DBProvider {
   DBProvider._();

  static final DBProvider db = DBProvider._();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 3, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Client ("
              "id INTEGER PRIMARY KEY,"
              "first_name TEXT,"
              "last_name TEXT,"
              "blocked BIT"
              ")");

          await db.execute("CREATE TABLE Categorys ("
              "id INTEGER PRIMARY KEY,"
              "name TEXT,"
              "image TEXT"
              ")");

          await db.execute("CREATE TABLE Cart ("
              "id INTEGER PRIMARY KEY,"
              "pro_id INTEGER ,"
              "name TEXT,"
              "quantity INTEGER"
              ")");

          await db.execute("CREATE TABLE recent_search ("
              "id INTEGER PRIMARY KEY,"
              "keyword TEXT ,"
              "time TEXT"
              ")");

        },
      onUpgrade: (Database db,int version,int latest)async{
        if(version == 2){
          await db.execute("CREATE TABLE recent_search ("
              "id INTEGER PRIMARY KEY,"
              "keyword TEXT ,"
              "time TEXT"
              ")");
        }
      }
    );
  }

  //category

   newCategory(CategoryResponseDataCategory category) async {
     final db = await database;
     //get the biggest id in the table
     var table = await db?.rawQuery("SELECT MAX(id)+1 as id FROM Categorys");
     int? id = table!.first["id"] as int?;
     //insert to the table using the new id
     var raw = await db?.rawInsert(
         "INSERT Into Categorys (id,name,image)"
             " VALUES (?,?,?)",
         [id, category.name,category.image]);
     return raw;
   }

   // Future<List<CategoryResponseDataCategory>> getAllCategorys() async {
   //   final db = await database;
   //   var res = await db?.query("Categorys");
   //   List<Client> list =
   //   res!.isNotEmpty ? res.map((c) => CategoryResponseDataCategory.fromMap(c)).toList() : [];
   //   return list;
   // }

   deleteAllCategorys() async {
     final db = await database;
     db?.rawDelete("Delete * from Categorys");
   }

   //cart

   newCart(Cart cart) async {
    print("cart adding ${cart.prodId} - Q ${cart.quantity}");
     final db = await database;
     //get the biggest id in the table
     try {
       var raw = await db?.rawInsert(
           "INSERT Into Cart (id,pro_id,name,quantity)"
               " VALUES (?,?,?,?)",
           [cart.prodId, cart.prodId, cart.name, cart.quantity]);
       return raw;
     }catch(e){

     }
   }

   Future<List<Cart>> getAllCart() async {
     final db = await database;
     var res = await db?.query("Cart");
     List<Cart> list =
     res!.isNotEmpty ? res.map((c) => Cart.fromMap(c)).toList() : [];
     return list;
   }

   Future<Cart?> getCartByProductId(int id) async {
     final db = await database;
     var res = await db?.query("Cart", where: "pro_id = ?", whereArgs: [id]);
     return res!.isNotEmpty ? Cart.fromMap(res.first) : null;
   }

   updateCart(Cart cart) async {
     final db = await database;
     var res = await db?.update("Cart", cart.toMap(),
         where: "pro_id = ?", whereArgs: [cart.prodId]);
     return res;
   }

   deleteAllCart() async {
     final db = await database;
     db?.rawDelete("Delete from Cart");
   }

   deleteCart(int id) async {
     final db = await database;
     return db?.delete("Cart", where: "id = ?", whereArgs: [id]);
   }
   deleteByProductIdCart(int productId) async {
     final db = await database;
     return db?.delete("Cart", where: "pro_id = ?", whereArgs: [productId]);
   }


   //recent search

   newRecentSearchAdd(String keyword,String time) async {

     final db = await database;
     var table = await db?.rawQuery("SELECT MAX(id)+1 as id FROM recent_search");
     int? id = table!.first["id"] as int?;
     try {
       var raw = await db?.rawInsert(
           "INSERT Into recent_search (id,keyword,time)"
               " VALUES (?,?,?)",
           [id, keyword, time]);
       return raw;
     }catch(e){

     }
   }

   deleteAllRecentSearch() async {
     final db = await database;
     db?.rawDelete("Delete from recent_search");
   }

   deleteSearchById(int id) async {
     final db = await database;
     return db?.delete("recent_search", where: "id = ?", whereArgs: [id]);
   }

   deleteSearchExceptLast() async {
     final db = await database;
     return db?.rawQuery("delete from recent_search where id not in (select id from recent_search order by id desc limit 5)");
   }

   Future<List<RecentSearch>> getAllRecentSearch() async {
     final db = await database;
     //var res = await db?.query("recent_search");
     var res = await db?.rawQuery("Select * from recent_search order by id DESC LIMIT 5");
     List<RecentSearch> list = res!.isNotEmpty ? res.map((c) => RecentSearch.fromMap(c)).toList() : [];
     return list;
   }


  //old
  newClient(Client newClient) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db?.rawQuery("SELECT MAX(id)+1 as id FROM Client");
    int? id = table!.first["id"] as int?;
    //insert to the table using the new id
    var raw = await db?.rawInsert(
        "INSERT Into Client (id,first_name,last_name,blocked)"
            " VALUES (?,?,?,?)",
        [id, newClient.firstName, newClient.lastName, newClient.blocked]);
    return raw;
  }

  blockOrUnblock(Client client) async {
    final db = await database;
    Client blocked = Client(
        id: client.id,
        firstName: client.firstName,
        lastName: client.lastName,
        blocked: !client.blocked);
    var res = await db?.update("Client", blocked.toMap(),
        where: "id = ?", whereArgs: [client.id]);
    return res;
  }

  updateClient(Client newClient) async {
    final db = await database;
    var res = await db?.update("Client", newClient.toMap(),
        where: "id = ?", whereArgs: [newClient.id]);
    return res;
  }

  getClient(int id) async {
    final db = await database;
    var res = await db?.query("Client", where: "id = ?", whereArgs: [id]);
    return res!.isNotEmpty ? Client.fromMap(res.first) : null;
  }

  Future<List<Client>> getBlockedClients() async {
    final db = await database;

    print("works");
    // var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
    var res = await db?.query("Client", where: "blocked = ? ", whereArgs: [1]);

    List<Client> list =
    res!.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Client>> getAllClients() async {
    final db = await database;
    var res = await db?.query("Client");
    List<Client> list =
    res!.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    return list;
  }

  deleteClient(int id) async {
    final db = await database;
    return db?.delete("Client", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db?.rawDelete("Delete * from Client");
  }
}
