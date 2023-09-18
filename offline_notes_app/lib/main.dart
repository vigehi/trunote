import 'package:flutter/material.dart';
import 'NoteEditorAddScreen.dart';
import 'NoteEditorEditScreen.dart';

void main() {
  runApp(const OfflineNotesApp());
}

class OfflineNotesApp extends StatelessWidget {
  const OfflineNotesApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF007A)),
        useMaterial3: true,
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 40.0,
              height: 40.0,
            ),
            SizedBox(width: 8.0),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Offline',
                    style: TextStyle(
                      color: const Color(0xFF007A),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Notes App',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Add Wi-Fi icon with conditional color
          Stack(
            children: [
              Icon(
                Icons.wifi,
                color: true ? Colors.red : Colors.white, // Replace 'true' with your condition
              ),
              if (true) // Replace 'true' with your condition
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '/',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 16.0), // Add spacing between icons
        ],
      ),
      body: ListView.builder(
        itemCount: dummyNotes.length,
        itemBuilder: (context, index) {
          final note = dummyNotes[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Text(
                note.title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Version ${note.version} - ${note.syncStatus}',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              trailing: note.syncStatus == 'Unsynced'
                  ? IconButton(
                      icon: Icon(Icons.cloud_off, color: Colors.red),
                      onPressed: () {
                        _showSyncStatusModal(context, note);
                      },
                    )
                  : Icon(Icons.cloud_done, color: Colors.green),
              onTap: () {
                // Navigate to NoteEditorEditScreen when clicking the note title
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteEditorEditScreen(),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteEditorAddScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

void _showSyncStatusModal(BuildContext context, Note note) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Sync Status & Conflict Resolution'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirmation Message for Note:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              note.title,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Handle "Keep Local" action
              // This is where you can override the server's version with your local note
              // Update the note's version and syncStatus accordingly
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Keep Local'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle "Use Server" action
              // This is where you can override your local note with the server's version
              // Update the note's version and syncStatus accordingly
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Use Server'),
          ),
        ],
      );
    },
  );
}
}

class Note {
  final String noteID;
  String title;
  String content;
  bool isDeleted;
  int version;
  String syncStatus;

  Note({
    required this.noteID,
    required this.title,
    required this.content,
    this.isDeleted = false,
    this.version = 1,
    this.syncStatus = 'Unsynced',
  });

  // Method to mark the note as deleted
  void markAsDeleted() {
    isDeleted = true;
    syncStatus = 'Unsynced';
  }
}

List<Note> dummyNotes = [
  Note(
    noteID: '1',
    title: 'Sample Note 1',
    content: 'This is the content of sample note 1.',
    syncStatus: 'Synced',
    version: 1,
    isDeleted: false,
  ),
  Note(
    noteID: '2',
    title: 'Sample Note 2',
    content: 'This is the content of sample note 2.',
    syncStatus: 'Unsynced',
    version: 2,
    isDeleted: false,
  ),
  // Add more dummy notes as needed
];
