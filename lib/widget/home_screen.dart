import 'package:flutter/material.dart';
import 'package:flutter_saving_data/service/db_handler.dart';

import '../local_db_model/notes.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper ;
  late Future<List<NotesModel>> notesList;
  @override
  void initState(){
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData () async {
    notesList = dbHelper!.getNotesList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes SQL'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: notesList,
                builder: (context,AsyncSnapshot<List<NotesModel>> snapshot)
            {
              if (snapshot.hasData){
                return
                  ListView.builder(
                    reverse: false,
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index)
                      {
                        return
                          InkWell(
                            onTap: (){
                              dbHelper!.update(
                                  NotesModel(
                                id: snapshot.data![index].id!,
                                  email: 'testSQl@gmail.com',
                                  title: 'update',
                                  age: 23,
                                  description:'update by me' )
                              );
                              setState((){
                                notesList = dbHelper!.getNotesList();
                              });
                            },
                            child: Dismissible(
                                direction: DismissDirection.endToStart,
                                background: Container(
                              color: Colors.red,
                              child: Icon(Icons.delete_forever),
                            ),
                                onDismissed: (DismissDirection direction){
                                  setState((){
                                    dbHelper!.delete(snapshot.data![index].id!);
                                    notesList = dbHelper!.getNotesList();
                                    snapshot.data!.remove(snapshot.data![index]);
                                  });
                                },
                                key: ValueKey<int>(snapshot.data![index].id!),
                                child: Card(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(10),
                                    title: Text(snapshot.data![index].title.toString()),
                                    subtitle:Text(snapshot.data![index].age.toString()) ,
                                    trailing: Text(snapshot.data![index].description.toString()),
                                  ),
                                )),
                          );
                      }

                  );
              } else
                {
                  return CircularProgressIndicator();
                }

            }

            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ( ) {
          dbHelper!.insert(NotesModel(
            title: 'Name 2',
              age: 22,
              description: 'fetch data',
              email: 'test@gmail.com'
          )
          ).then((value) {
            print('data added');
            setState(() {
              notesList = dbHelper!.getNotesList();
            });
          }).onError((error, stackTrace) {
            print(error.toString());
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
