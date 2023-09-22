require("dotenv").config();
var express = require("express");
var bodyParser = require("body-parser");
var mongoose = require("mongoose");

const Note = require("./models/note");

var app = express();
app.use(bodyParser.json());

const dataBaseUrl = process.env.DATABASE_URL;

mongoose
  .connect(dataBaseUrl)
  .then(() => console.log("You are connected to mongoDB..."));

app.post("/notes", async function (req, res) {
  var { title, content } = req.body;

  const newNote = new Note({
    title,
    content,
  });

  try {
    await newNote.save();
    res.status(201).send(newNote);
  } catch (err) {
    console.error("Error inserting note into MongoDB: ", err);
    res.status(500).send("Internal Server Error");
  }
});

//Get all notes from the database
app.get("/notes", async function (req, res) {
  const notes = await Note.find();
  try {
    res.status(200).send(notes);
  } catch (err) {
    console.error("Error fetching notes from MongoDB:", err);
    res.status(500).send("Internal Server Error");
  }
});

app.get("/notes", async function (req, res) {
  const notes = await Note.find({ syncStatus: req.query.syncStatus });
  try {
    res.status(200).send(notes);
  } catch (err) {
    console.error("Error fetching notes from MongoDB:", err);
    res.status(500).send("Internal Server Error");
  }
});

app.get("/notes/:noteID", async function (req, res) {
  const note = await Note.find({ noteID: req.params.noteID });

  try {
    if (!note) {
      res.status(404).send("Note not found");
    } else {
      res.status(200).send(note);
    }
  } catch (err) {
    console.error("Error fetching note from MongoDB:", err);
    res.status(500).send("Internal Server Error");
  }
});

app.put("/notes/:noteID", async function (req, res) {
  const note = await Note.findOne({ noteID: req.params.noteID });

  try {
    if (!note) return res.status(404).send("Note not found");
    note.title = req.body.title;
    note.content = req.body.content;

    note.dateModified = new Date().toISOString();
    note.version++;

    if (note.syncStatus === "Synced") {
      note.syncStatus = "Unsynced";
    }
    await note.save();
    res.status(200).json(note);
  } catch (err) {
    console.error("Error updating note in MongoDB:", err);
    res.status(500).json({ message: "Internal Server Error" });
  }
});

app.put("/notes/:noteID", async function (req, res) {
  var noteID = req.params.noteID;
  const note = Note.find({ noteID });

  try {
    if (!note) return res.status(404).send("Note not found");

    note.isDeleted = true;
    note.syncStatus = "Unsynced";

    await note.save();

    return res.status(200).send("Note marked as updated");
  } catch (err) {
    console.error("Error fetching note from MongoDB:", err);
    return res.status(500).send("Internal Server Error");
  }
});

// Define a route for syncing (sending notes to the server)
app.get("/sync", async function (req, res) {
  const note = await Note.find({ syncStatus: "Unsynced" });

  // Implement actual synchronization logic here

  res.status(200).send(note);
});

// Start the Express.js server
app.listen(3000, function () {
  console.log("Server is running on port 3000");
});
