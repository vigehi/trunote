var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var MongoClient = require('mongodb').MongoClient;

app.use(bodyParser.json());

const mongoUrl = 'mongodb://localhost:27017'; 
const dbName = 'notesdb'; 

var db;

MongoClient.connect(mongoUrl, { useNewUrlParser: true, useUnifiedTopology: true }, function(err, client) {
   if (err) {
       console.error('Error connecting to MongoDB:', err);
       process.exit(1);
   }
   
   db = client.db(dbName);
   console.log('Connected to MongoDB');
});


app.post('/notes', function(req, res){
    var noteID = generateNoteID();
    var syncStatus = "Unsynced";
    var version = 1;
    var timestamp = new Date().toISOString();
    var { title, content } = req.body;

    var newNote = {
        noteID,
        title,
        content,
        syncStatus,
        version,
        dateCreated: timestamp,
        dateModified: timestamp,
        isDeleted: false
    };

    db.collection('notes').insertOne(newNote, function(err, result) {
        if (err) {
            console.error('Error inserting note into MongoDB:', err);
            res.status(500).json({ message: 'Internal Server Error' });
            return;
        }
        
        res.status(201).json(newNote);
    });
});

app.get('/notes', function(req, res){
    var syncStatusFilter = req.query.syncStatus;
    var filter = {};
    if (syncStatusFilter) {
        filter.syncStatus = syncStatusFilter;
    }

    db.collection('notes').find(filter).toArray(function(err, notes) {
        if (err) {
            console.error('Error fetching notes from MongoDB:', err);
            res.status(500).json({ message: 'Internal Server Error' });
            return;
        }

        res.status(200).json(notes);
    });
});

app.get('/notes/:noteID', function(req, res){
    var noteID = req.params.noteID;

    db.collection('notes').findOne({ noteID }, function(err, note) {
        if (err) {
            console.error('Error fetching note from MongoDB:', err);
            res.status(500).json({ message: 'Internal Server Error' });
            return;
        }

        if (!note) {
            res.status(404).json({ message: 'Note not found' });
        } else {
            res.status(200).json(note);
        }
    });
});

app.put('/notes/:noteID', function(req, res){
    var noteID = req.params.noteID;

    db.collection('notes').findOne({ noteID }, function(err, note) {
        if (err) {
            console.error('Error fetching note from MongoDB:', err);
            res.status(500).json({ message: 'Internal Server Error' });
            return;
        }

        if (!note) {
            res.status(404).json({ message: 'Note not found' });
        } else {
            if (req.body.title) {
                note.title = req.body.title;
            }
            if (req.body.content) {
                note.content = req.body.content;
            }

            note.dateModified = new Date().toISOString();
            note.version++;

            if (note.syncStatus === "Synced") {
                note.syncStatus = "Unsynced";
            }

            db.collection('notes').updateOne({ noteID }, { $set: note }, function(err) {
                if (err) {
                    console.error('Error updating note in MongoDB:', err);
                    res.status(500).json({ message: 'Internal Server Error' });
                    return;
                }

                res.status(200).json(note);
            });
        }
    });
});

app.delete('/notes/:noteID', function(req, res){
    var noteID = req.params.noteID;

    db.collection('notes').findOne({ noteID }, function(err, note) {
        if (err) {
            console.error('Error fetching note from MongoDB:', err);
            res.status(500).json({ message: 'Internal Server Error' });
            return;
        }

        if (!note) {
            res.status(404).json({ message: 'Note not found' });
        } else {
            note.isDeleted = true;
            note.syncStatus = "Unsynced";

            db.collection('notes').updateOne({ noteID }, { $set: note }, function(err) {
                if (err) {
                    console.error('Error updating note in MongoDB:', err);
                    res.status(500).json({ message: 'Internal Server Error' });
                    return;
                }

                res.status(200).json({ message: 'Note marked as deleted' });
            });
        }
    });
});

// Define a route for syncing (sending notes to the server)
app.post('/sync', function(req, res){
    var unsyncedNotes = notesDB.filter(note => note.syncStatus === "Unsynced");

    // Implement actual synchronization logic here

    res.status(200).json(unsyncedNotes);
});

// Middleware for logging
app.use(function(req, res){
   console.log('End');
});

// Start the Express.js server
app.listen(3000, function(){
    console.log('Server is running on port 3000');
});

function generateNoteID() {
    return Math.random().toString(36).substring(7);
}
