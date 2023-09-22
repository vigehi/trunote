const mongoose = require('mongoose');

var timestamp = new Date().toISOString();

const noteSchema = new mongoose.Schema({
  title: {type: String, require: true},
  content: {type: String, require: true},
  dateCreated: { type: Date, default: timestamp },
  dateModified: { type: Date, default: timestamp },
  syncStatus: { type: String, default: "Unsynced" },
  version: { type: Number, default: 1 },
  isDeleted: {type: Boolean, default: false},
});

const Note = mongoose.model('Note', noteSchema);

module.exports = Note;
