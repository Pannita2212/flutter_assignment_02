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


// Button add or bin
  @override
  Widget build(BuildContext context) {
    final List btn = <AppBar>[
      AppBar(
        title: Text("Todo"),
        actions:<Widget>[ IconButton(
        icon: Icon(Icons.add_circle),
        onPressed: () {
          Navigator.pushNamed(context, "//");
        },
        )],
      ),
      AppBar(
        title: Text("Todo"),
        actions: <Widget>[ IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async{
            await TodoProvider.db.delAll();
            setState(() {});
          },
        )],
      )
    ];


    
    return Scaffold(
      appBar: btn[index],
      body: FutureBuilder<List<Todo>>(
        future: index==0? TodoProvider.db.getTask() : TodoProvider.db.getComplete(),
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data.length==0){
              return Center(child: Text("No data found"),);
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Todo item = snapshot.data[index];
                return ListTile(
                  title: Text(item.title),
                  trailing: Checkbox(
                    onChanged: (bool value) {
                      TodoProvider.db.blockOrUnblock(item);
                      setState(() {});
                    },
                    value: item.done ==1? true: false,
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),

      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.brown[100],),
        child: BottomNavigationBar(
          onTap: appbarTab,
          currentIndex: index,
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
    );
  }
  void appbarTab(int i){
    setState((){ index   = i;});
  }
}
