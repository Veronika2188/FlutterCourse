import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _userToDo = '';
  List todoList = [];

  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    super.initState();

    initFirebase();

    todoList.addAll(['Buy milk', 'Walk the dog', 'Wash the dishes']);
  }

  void _menuOpen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Menu'),),
          body: Row(
            children: [
              ElevatedButton(onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }, child: const Text('Main')),
              const Padding(padding: EdgeInsets.only(left: 15)),
            ],
          )
        );
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('ToDo list'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: _menuOpen,
              icon: const Icon(Icons.menu))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
          if(!snapshot.hasData) return const Text('No todos');
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(snapshot.data.docs[index].id),
                  child: Card(
                    child: ListTile(
                      title: Text(snapshot.data.docs[index].get('item')),
                      trailing: IconButton(
                        icon: const Icon(
                            Icons.delete,
                            color: Colors.blueGrey
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance.collection('items').doc(snapshot.data.docs[index].id).delete();
                        },
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    FirebaseFirestore.instance.collection('items').doc(snapshot.data.docs[index].id).delete();
                  },
                );
              }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: ()  {
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Add new ToDo'),
              content: TextField (
                onChanged: (String value) {
                  _userToDo = value;
                },
              ),
              actions: [
                ElevatedButton(onPressed: () {
                  FirebaseFirestore.instance.collection('items').add({'item': _userToDo});
                  Navigator.of(context).pop();
                }, child: const Text('Add'))
              ],
            );
          });
        },
        child: const Icon(
          Icons.add_box,
          color: Colors.white,
        ),
      ),
    );
  }
}
