import 'package:flutter/material.dart';

class NoteEditorAddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            'assets/back.png', // Replace with the correct path to your image
            width: 15.0, // Adjust the width as needed
            height: 15.0, // Adjust the height as needed
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Save the note and perform other actions as needed
              Navigator.pop(context);
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
                border: InputBorder.none, // Remove the border
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              maxLines: 5, // Allow multiple lines for the description
              decoration: InputDecoration(
                labelText: 'Note content',
                border: InputBorder.none, // Remove the border
              ),
            ),
          ),
        ],
      ),
    );
  }
}
