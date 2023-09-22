import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NoteEditorEditScreen extends StatefulWidget {
  final String noteId;
  final String initialTitle;
  final String initialDescription;

  NoteEditorEditScreen({
    required this.noteId,
    required this.initialTitle,
    required this.initialDescription,
  });

  @override
  _NoteEditorEditScreenState createState() => _NoteEditorEditScreenState();
}

class _NoteEditorEditScreenState extends State<NoteEditorEditScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.initialTitle;
    descriptionController.text = widget.initialDescription;
  }

 Future<void> updateNote(BuildContext context) async {
  final Uri uri = Uri.parse('https://offline-notes-backend.onrender.com/notes/${widget.noteId}');

  final Map<String, dynamic> updatedNoteData = {
    'title': titleController.text,
    'content': descriptionController.text,
  };

  try {
    final response = await http.put(
      uri,
      body: json.encode(updatedNoteData), // Convert data to JSON string
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Note updated successfully
      Navigator.pop(context, 'Update Successful');
    } else {
      // Handle error when updating the note
      print('Failed to update note - ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update note. Please try again.'),
        ),
      );
    }
  } catch (e) {
    print('Error updating note: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred while updating the note.'),
      ),
    );
  }
}

  Future<void> deleteNote(BuildContext context) async {
    final Uri uri = Uri.parse('https://offline-notes-backend.onrender.com/notes/${widget.noteId}');

    try {
      final response = await http.put(uri);

      if (response.statusCode == 204) {
        // Note deleted successfully
        Navigator.pop(context, 'Delete Successful');
      } else {
        // Handle error when deleting the note
        print('Failed to delete note - ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete note. Please try again.'),
          ),
        );
      }
    } catch (e) {
      print('Error deleting note: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while deleting the note.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              updateNote(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Confirm Delete'),
                    content: Text('Are you sure you want to delete this note?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          deleteNote(context);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Note Title',
              ),
              controller: titleController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Note Description',
              ),
              controller: descriptionController,
            ),
          ),
        ],
      ),
    );
  }
}
