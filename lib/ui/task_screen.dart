import 'package:flutter/material.dart';
import './todo.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TaskScreen();
  }
}

class _TaskScreen extends State<TaskScreen> {
  int index = 0;
  static List<Todo> lst_task = List<Todo>();
  static List<Todo> lst_complete = List<Todo>();
  final TodoProvider todo = TodoProvider();

// add list
  void addLst_task(){
    this.todo.allTask().then((list){
      setState(() {
      lst_task = list; 
      });
    });
  }
  void addLst_complete(){
    this.todo.allComplete().then((list) {
      setState(() {
       lst_complete = list; 
      });
    });
  }
// 

  @override
  initState() { super.initState();
    this.todo.open().then((_) {
      this.addLst_complete();
      this.addLst_task();
    });
  }


  final List<Widget> screen = <Widget>[
    Center(
        child: ListView(
          children: lst_task.map(
                (e) => CheckboxListTile(
                      title: Text(e.body),
                      value: e.show,
                      onChanged: (bool value) {
                        setState(() {
                         e.show = value;
                         todo.update(e);
                         addLst_complete();
                         addLst_task();
                        });
                      },
                    ),
              )
              .toList(),
        ),
      ),
  ];

// screen add or bin
  @override
  Widget build(BuildContext context) {
    List<AppBar> appBars = <AppBar>[
      AppBar(
        title: Text('Todo'),
        actions: <IconButton>[
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () => Navigator.pushNamed(context, '//'),
          ),
        ],
      ),
      AppBar(
        title: Text('Todo'),
        actions: <IconButton>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                this.todo.delAll();
                this.addLst_complete();
              });
            },
          ),
        ],
      ),
    ];
// 



    return Scaffold(
      appBar: appBars[index],
      // body: screen[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, //
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            title: new Text('Task'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.done_all),
            title: new Text('Completed'),
          ),
        ],
        onTap: (int i) { setState(() {index = i;});}
      ),
    );
  }
}



            