import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditTodoScreen extends StatefulWidget {
  String name;
  String id;
  String description;
  EditTodoScreen(
      {super.key,
      required this.name,
      required this.description,
      required this.id});

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  TextEditingController edittitleController = TextEditingController();
  TextEditingController editdescriptionController = TextEditingController();
  GlobalKey editformkey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    editdescriptionController.text = widget.description;
    edittitleController.text = widget.name;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          TextField(
            controller: edittitleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: editdescriptionController,
            decoration: InputDecoration(
              hintText: 'Description',
            ),
            maxLines: 8,
            minLines: 4,
            keyboardType: TextInputType.multiline,
          ),
          ElevatedButton(
              onPressed: () {
                updateButton();
                Navigator.pop(context, true);
              },
              child: const Text('Update'))
        ],
      ),
    );
  }

  Future<void> updateButton() async {
    // Get the data from form
    final title = edittitleController.text;
    final description = editdescriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    // Submit the data to the server
    final url = 'https://api.nstack.in/v1/todos/${widget.id}';
    final uri = Uri.parse(url);

    final response = await http.put(uri,
        body: jsonEncode(body), headers: {"Content-Type": "application/json"});
    // Show the success or fail message based on status
    if (response.statusCode == 201) {
      print('Updation success');
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }
}
