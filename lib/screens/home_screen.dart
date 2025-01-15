import 'dart:convert';

import 'package:blocliabrary/screens/add_todo_screen.dart';
import 'package:blocliabrary/screens/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Todo list'),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 0, 150, 112),
                    child: Text('${index + 1}'),
                  ),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () async{
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditTodoScreen(
                                          name: item['title'],
                                          description: item['description'],
                                          id: id))).then((value) async{
                                            if (value == true) {
               await  fetchTodo();
              }
                                          });
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              deleteById(id);
                            },
                            icon: Icon(Icons.delete))
                      ],
                    ),
                  ),
                );
              }),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddTodoScreen()))
                .then((value) {
              if (value == true) {
                fetchTodo();
              }
            });
          },
          label: Text('Add Todo'),
          backgroundColor: Color.fromARGB(255, 0, 150, 112),
        ));
  }

  Future fetchTodo() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final response = await http.get(Uri.parse(url));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final results = json['items'] as List;
      setState(() {
        items = results;
      });
    } else {
      print('loding failed');
    }
  }

  Future<void> deleteById(String id) async {
    // remove the item
    final url = "https://api.nstack.in/v1/todos/$id";
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    }
    // remove the item from list
  }
}
