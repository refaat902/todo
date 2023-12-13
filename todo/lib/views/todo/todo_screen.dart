import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/views/todo/date_format.dart';

// ignore: must_be_immutable
class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  showFromDialog(BuildContext context) {
    TextEditingController title = TextEditingController();
    TextEditingController body = TextEditingController();
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: const Center(child: Text("Add New Task")),
            content: SizedBox(
              height: 320,
              child: Column(
                children: [
                  TextFormField(
                    controller: title,
                    decoration: InputDecoration(
                        hintText: "Tilte",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLines: 4,
                    maxLength: 1000,
                    controller: body,
                    decoration: InputDecoration(
                        hintText: "Body",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () async {
                                var id = await db.insert('todo', {
                                  'id': counter,
                                  'title': title.text,
                                  'body': body.text,
                                  'dateTime': DateTimeFormat.nowDate(),
                                  'done': 0
                                });
                                list = await db.query('todo');
                                setState(() {
                                  counter += 1;
                                });
                                // print(counter);
                                // db.delete('todo',
                                //     where: 'id=?', whereArgs: [2]);
                              },
                              child: const Text(
                                "Add",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  late Database db;
  List<Map<String, dynamic>>? list;
  var counter = 0;
  bool? ischecked = false;
  initDB() async {
    String path = await getDatabasesPath();
    String filepath = join(path, 'todo.db');
    db = await openDatabase(filepath, version: 1, onCreate: (_db, v) {
      _db.execute(
          'CREATE TABLE todo(id INTEGER PRIMARY KEY,title TEXT,body TEXT,dateTime TEXT,done TEXT)');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    initDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Todo List",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.grey[350],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          showFromDialog(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: ListView.builder(
                itemCount: counter,
                itemBuilder: (context, index) {
                  return Container(
                    height: 80,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    // child: Column(children: [
                    //   Text(list?[index]['title'],style: TextStyle(fontWeight: FontWeight.bold),),
                    //   Text(list?[index]['body'],style: TextStyle(fontWeight: FontWeight.bold),),
                    // ]),
                    child: ListTile(
                      title: Text(
                        list?[index]['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        list?[index]['body'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      trailing: Text(
                        list?[index]['dateTime'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
