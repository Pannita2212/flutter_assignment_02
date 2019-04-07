import 'package:flutter/material.dart';
import './todo2.dart';

class NewTask extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewTaskState();
  }
}

class NewTaskState extends State<NewTask> {
  TodoProvider todo = TodoProvider();
  final _formKey = GlobalKey<FormState>();
  String txt;
  final txtControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Subject"),
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                  decoration: InputDecoration(labelText: "Subject"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please Fill Subject";
                    }Navigator.pop(context);
                  }),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      child: Text("Save"), color: Colors.brown[100],
                      onPressed: () async {
                        if (!_formKey.currentState.validate()) {
                          return "Please Fill Subject";
                        } else {
                          await todo.open("todo.db");
                        Todo data = Todo();
                        data.title = txt;
                        data.done = false;
                        await todo.insert(data);
                        txtControl.text = "";

                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
