var express = require('express');
var bodyParser = require('body-parser');
var mongoose = require('mongoose');

const Note = require('./models/note')

var app = express();
app.use(bodyParser.json());

// const mongoUrl = 'mongodb://localhost:27017'; 
// const dbName = 'notesdb'; 
// const dataBaseUrl = `${mongoUrl}/${dbName}`

mongoose.connect("mongodb+srv://OLUola1992:OLUola1992@cluster0.2fe17rz.mongodb.net/?retryWrites=true&w=majority")
        .then(() => console.log("You are connected to mongoDB..."))


app.post('/notes', async function(req, res){
    var noteID = generateNoteID();
    var { title, content } = req.body;

    const newNote = new Note({
        noteID,
        title,
        content,
    });
    
    try {
        await newNote.save();
        res.status(201).send(newNote)
    } catch (err) {
            console.error('Error inserting note into MongoDB: ', err);
            res.status(500).send('Internal Server Error');
    }
});

app.get('/notes', async function(req, res){
    const notes = await Note.find({ syncStatus: req.query.syncStatus });
    try {
        res.status(200).send(notes);
    } catch (err) {
        console.error('Error fetching notes from MongoDB:', err);
        res.status(500).send('Internal Server Error');
    }

});


app.get('/notes/:noteID', async function(req, res){
    const note = await Note.find({ noteID: req.params.noteID });

    try { 
        if (!note) {
            res.status(404).send('Note not found');
        } else {
            res.status(200).send(note);
        }
    } catch (err) {
        console.error('Error fetching note from MongoDB:', err);
        res.status(500).send('Internal Server Error');
    }
    
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
app.get('/sync', async function(req, res){
    const note = await Note.find({ syncStatus: "Unsynced" });

    // Implement actual synchronization logic here

    res.status(200).send(note);
});


// Start the Express.js server
app.listen(3000, function(){
    console.log('Server is running on port 3000');
});
