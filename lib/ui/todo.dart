import 'package:sqflite/sqflite.dart';
import 'dart:async';

final String tableTodo = "todo";
final String columnId = "id";
final String columnBody = "body";
final String columnShow = "show";

class Todo {
  int id;
  String body;
  bool show;

  Todo({String body}){
    this.body = body; this.show = false;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    this.id = map[columnId];
    this.body = map[columnBody];
    this.show = map[columnShow] == 1;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnBody: body,
      columnShow: show == true ? 1 : 0
    };

    if (id != null) {
      map[columnId] = id;
    }return map;
  }

}

class TodoProvider {
  Database db;
  Database get database => this.db;

  Future open({String path = "todo.db"}) async {
    String dbPath = await getDatabasesPath();
    path = dbPath+path;
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $tableTodo (
        $columnId integer primary key autoincrement,
        $columnBody text not null,
        $columnShow integer not null)
      ''');
    });
  }

  Future<Todo> insert(Todo todo) async {
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<Todo> getTodo(int id) async {
    List<Map<String, dynamic>> map = await db.query(tableTodo,
        columns: [columnId, columnBody, columnShow],
        where: '$columnId = ?',
        whereArgs: [id]);
    if(map.length > 0){
      return new Todo.fromMap(map.first);
    }else{
      return null;
    }
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTodo,
    where: '$columnId = ?',
    whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    await db.update(tableTodo, todo.toMap(),
    where: '$columnId = ?',
    whereArgs: [todo.id]);
  }

// +++
  Future<List<Todo>> allTask() async{
    List<Map<String, dynamic>> data = await this.db.query(
      tableTodo, where: '$columnShow = 1');

    return data.map((e) => Todo.fromMap(e)).toList();
  }
  Future<List<Todo>> allComplete() async{
    List<Map<String, dynamic>> data = await this.db.query(
      tableTodo, where: '$columnShow = 1');

    return data.map((e) => Todo.fromMap(e)).toList();
  }
  void delAll() async{
    await this.db.delete(tableTodo, where: '$columnShow = 1');
  }


  Future close() async => db.close();
}
