import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NoteEditorAddScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  Future<void> saveNote(BuildContext context) async {
    final Uri uri = Uri.parse('https://offline-notes-backend.onrender.com/notes');

    final Map<String, dynamic> noteData = {
      'title': titleController.text,
      'content': contentController.text,
      'syncStatus': 'Unsynced',
      'version': 1,
      'isDeleted': false,
    };

    try {
      final response = await http.post(
        uri,
        body: jsonEncode(noteData), 
        headers: {
          'Content-Type': 'application/json', 
        },
      );

      if (response.statusCode == 201) {
        Navigator.pop(context, 'Save Successful');
      } else {
        print('Failed to save note - ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save note. Please try again.'),
          ),
        );
      }
    } catch (e) {
      print('Error saving note: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while saving the note.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            'assets/back.png',
            width: 15.0,
            height: 15.0,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              saveNote(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Note Title',
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: contentController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Note content',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
