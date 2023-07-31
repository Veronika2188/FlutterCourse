import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('ToDo list'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Text('Main Screen', style: TextStyle(color: Colors.white),),
          ElevatedButton(onPressed: () {
            Navigator.pushReplacementNamed(context, '/todo');
          }, child: Text('Next page'))
        ],
      ),
    );
  }
}
