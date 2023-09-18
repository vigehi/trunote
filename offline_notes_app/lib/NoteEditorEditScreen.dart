import 'package:flutter/material.dart';

class NoteEditorEditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Save the edited note and perform other actions as needed
              Navigator.pop(context); // Navigate back to the homepage
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Show a confirmation dialog before deleting
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Confirm Delete'),
                    content: Text('Are you sure you want to delete this note?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Mark the note as deleted and navigate back
                          // final Note editedNote = ...; // Get the edited note
                          // editedNote.markAsDeleted();
                          Navigator.of(context).pop(); // Close the dialog
                          Navigator.pop(context); // Navigate back to the homepage
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
              // Set the initial text for editing
              controller: TextEditingController(text: 'Initial Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Note Description',
              ),
              // Set the initial text for editing
              controller: TextEditingController(text: 'Initial Description'),
            ),
          ),
        ],
      ),
    );
  }
}
