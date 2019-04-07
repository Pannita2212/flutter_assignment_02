import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

Todo todoFromJson(String str) {
    final jsonData = json.decode(str);
    return Todo.fromMap(jsonData);
}
String todoToJson(Todo data) {
    final dyn = data.toMap();
    return json.encode(dyn);
}

class Todo {
    int id;
    String title;
    int done;

    Todo({
        this.id,
        this.title,
        this.done,
    });

    factory Todo.fromMap(Map<String, dynamic> json) => new Todo(
        id: json["id"],
        title: json["title"],
        done: json["done"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "done": done,
    };
}




class TodoProvider {
  TodoProvider._();
  static final TodoProvider db = TodoProvider._();

  Database _db;

  Future<Database> get database async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Todo ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "title TEXT,"
          "done integer"
          ")");
    });
  }

  newTodo(Todo newTodo) async {
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT Into Todo (id,title,done)"
        " VALUES (?,?,?)",
        [newTodo.id, newTodo.title, newTodo.done]);
    return raw;
  }

  blockOrUnblock(Todo todo) async {
    final db = await database;
    Todo done = Todo(
        id: todo.id,
        title: todo.title,
        done: todo.done ==1 ? 0:1);
    var res = await db.update("Todo", done.toMap(),
        where: "id = ?", whereArgs: [todo.id]);
    return res;
  }

  updateTodo(Todo newTodo) async {
    final db = await database;
    var res = await db.update("Todo", newTodo.toMap(),
        where: "id = ?", whereArgs: [newTodo.id]);
    return res;
  }

  getTodo(int id) async {
    final db = await database;
    var res = await db.query("Todo", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Todo.fromMap(res.first) : null;
  }

  Future<List<Todo>> getdoneTodos() async {
    final db = await database;
    print("works");
    var res = await db.query("Todo", where: "done = ? ", whereArgs: [1]);
    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    var res = await db.query("Todo");
    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }

  deleteTodo(int id) async {
    final db = await database;
    return db.delete("Todo", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Todo");
  }

// add method
  Future<List<Todo>> getTask() async {
    final db = await database;
    int done = 0;
    var res = await db.query("Todo", where: "done = ? ", whereArgs: [done]);
    List<Todo> list =
        res.isNotEmpty ? res.map((e) => Todo.fromMap(e)).toList() : [];
    return list;
  }
  Future<List<Todo>> getComplete() async {
    final db = await database;
    int done = 1;
    var res = await db.query("Todo", where: "done = ? ", whereArgs: [done]);
    List<Todo> list =
        res.isNotEmpty ? res.map((e) => Todo.fromMap(e)).toList() : [];
    return list;
  }
  delAll() async {
    final db = await database;
    return db.delete("Todo", where: "done = ?", whereArgs: [1]);
  }
}