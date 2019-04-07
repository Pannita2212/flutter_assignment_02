import 'package:flutter/material.dart';
import './todo2.dart';


class TaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TaskScreen();
  }
}

class _TaskScreen extends State<TaskScreen> {
  int index = 0;
  final TodoProvider todo = TodoProvider();
  // List<Todo> lstTask = List<Todo>();
  // List<Todo> lstComplete = List<Todo>();
  List<Todo> lstTask = [];
  List<Todo> lstComplete = [];
  List<Todo> lst = [];
  int task =0; int complete =0;



// screen add or bin
  @override
  Widget build(BuildContext context) {
    List<AppBar> appBars = <AppBar>[
      AppBar(
        title: Text("Todo"),
        actions: <IconButton>[
          IconButton(
            icon: Icon(Icons.add_circle),
            // onPressed: () => Navigator.pushNamed(context, '//'),
            onPressed: () => {},
          ),
        ],
      ),
      AppBar(
        title: Text("Todo"),
        actions: <IconButton>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async{
              lst = lstComplete;
                var delete = await todo.getAllStr();
                for(var i in delete){
                  var tmp = i.values.toList();
                  if(tmp[2]==1){
                    await todo.delete(tmp[0]);
                    for(var j=0; j <lstComplete.length; j++){
                      if(lstComplete[j].id == tmp[0]){ await lst.removeAt(j);}
                  }
                }
            }setState(() {
             lstComplete = []; 
            });
            },
          ),
        ],
      ),
    ];


//icon
  return DefaultTabController(
    initialIndex: index,
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        actions: <Widget>[appBars[index]],
        backgroundColor: Colors.white,
      ),
      body: index == 0 
      ? Container(
        child: FutureBuilder<List<Todo>> (
          future: todo.getAll(),
          builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot){
            lstTask=[]; task=0;
            if(snapshot.hasData){
              for(var i in snapshot.data){
                if(i.done == false){
                  lstTask.add(i); task++;
                }
              }
              return task != 0 
              ? ListView.builder(
                itemCount: lstTask.length,
                itemBuilder: (BuildContext context, index){
                  Todo i = lstTask[index];
                  return ListTile(
                    title: Text(i.title),
                    trailing: Checkbox(onChanged: (bool value) async{
                      setState(() {
                       i.done = value; 
                      });todo.update(i);
                    }, value: i.done,),
                  );
                },
              )
              :Center(child: Text("No data found"),);
            } 
            // else{
            //   return Center(
            //     child: CircularProgressIndicator()
            //   );
            // }
          },
        ),
      )

      : Container(
        child: FutureBuilder<List<Todo>>(
          future: todo.getAll(),
          builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot){
            lstComplete=[]; complete=0;
            if(snapshot.hasData){
              for(var i in snapshot.data){
                if(i.done == true){
                  lstComplete.add(i); complete++;
                }
              }
              return complete != 0 ? ListView.builder(
                itemCount: lstComplete.length,
                itemBuilder: (BuildContext context, index){
                  Todo i = lstComplete[index];
                  return ListTile(
                    title: Text(i.title),
                    trailing: Checkbox(onChanged: (bool value) async{
                      setState(() {
                       i.done = value; 
                      }); todo.update(i);
                    },value: i.done,),
                  );
                },
              )
              : Center(child: Text("No data found"),);
            }
            // else{
            //   return Center(
            //     child: CircularProgressIndicator()
            //   );
            // }
          },
        ),
      ),
      
      
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.brown[100],),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (int i) {
            setState(() {
              index = i;
              todo.open('todo.db');
            });
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),title: Text('Task'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check),title: Text('Completed'),
            ),
          ],
        ),
      ),
    ),
  );
  }
}
