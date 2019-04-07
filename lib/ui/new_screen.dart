import 'package:flutter/material.dart';
import './todo.dart';

class NewTask extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewTaskState();
  }
}


class NewTaskState extends State<NewTask> {
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
                controller: txtControl,
                  decoration: InputDecoration(labelText: "Subject"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please Fill Subject";
                    }else{
                      txt = value;
                    }
                  }),
              Row(children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      child: Text("Save"), color: Colors.brown[100],
                      onPressed: () async {
                        if (!_formKey.currentState.validate()) {
                          return "Please Fill Subject";
                        } else {
                          Todo rnd = Todo(title: txt, done: 0);
                          await TodoProvider.db.newTodo(rnd);
                          setState(() {
                            
                          });
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