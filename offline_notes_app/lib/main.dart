import 'dart:convert';
import 'package:flutter/material.dart';
import 'NoteEditorAddScreen.dart';
import 'NoteEditorEditScreen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


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

class Note {
  final String id;
  final String noteID;
  final String title;
  final String content;
  final String dateCreated;
  final String dateModified;
  String syncStatus;
  final int version;
  bool isDeleted;

  Note({
    required this.id,
    required this.noteID,
    required this.title,
    required this.content,
    required this.dateCreated,
    required this.dateModified,
    required this.syncStatus,
    required this.version,
    required this.isDeleted,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['_id'] ?? '',
      noteID: json['noteID'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      dateCreated: json['dateCreated'] ?? '',
      dateModified: json['dateModified'] ?? '',
      syncStatus: json['syncStatus'] ?? '',
      version: json['version'] ?? 1,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  void markAsDeleted() {
    isDeleted = true;
    syncStatus = 'Unsynced';
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Note> notes = [];
  DateTime? lastSyncDateTime;

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    try {
      final response = await http
          .get(Uri.parse('https://offline-notes-backend.onrender.com/notes'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          notes = responseData.map((data) => Note.fromJson(data)).toList();
        });
      } else {
        print('Failed to load notes - ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching notes: $e');
    }
  }

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
          if (lastSyncDateTime != null)
            Text(
              'Last Sync: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(lastSyncDateTime!)}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          Stack(
            children: [
              Icon(
                Icons.wifi,
                color: true ? Colors.red : Colors.white,
              ),
              if (true)
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
          SizedBox(width: 16.0),
        ],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 4.0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteEditorEditScreen(
                      noteId: note.noteID,
                      initialTitle: note.title,
                      initialDescription: note.content,
                    ),
                  ),
                );
              },
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
                  note.content,
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
              ),
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

  void _updateSyncStatus(Note note, String newSyncStatus) async {
    setState(() {
      note.syncStatus = newSyncStatus;
      lastSyncDateTime = DateTime.now();
    });

    final response = await http.put(
      Uri.parse(
          'https://offline-notes-backend.onrender.com/notes/${note.noteID}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"syncStatus": newSyncStatus}),
    );

    if (response.statusCode == 200) {
      print('Sync status updated successfully');
    } else {
      print('Failed to update sync status - ${response.statusCode}');
      setState(() {
        note.syncStatus = 'Unsynced';
      });
    }
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
                'It\'s important to choose carefully to ensure you don\'t lose any critical information.',
                style: TextStyle(
                  fontSize: 14,
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
                _updateSyncStatus(note, 'Local');
                Navigator.of(context).pop();
              },
              child: Text('Keep Local'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateSyncStatus(note, 'Server');
                Navigator.of(context).pop();
              },
              child: Text('Use Server'),
            ),
          ],
        );
      },
    );
  }
}
