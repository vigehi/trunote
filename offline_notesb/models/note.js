const mongoose = require('mongoose');

var timestamp = new Date().toISOString();

const noteSchema = new mongoose.Schema({
  noteID: { type: String, default: generateNoteID() },
  title: { type: String, require: true },
  content: { type: String, require: true },
  dateCreated: { type: Date, default: timestamp },
  dateModified: { type: Date, default: timestamp },
  syncStatus: { type: String, default: "Unsynced" },
  version: { type: Number, default: 1 },
  isDeleted: { type: Boolean, default: false },
});

function generateNoteID() {
  return Math.random().toString(36).substring(7);
}

const Note = mongoose.model('Note', noteSchema);

module.exports = Note;
