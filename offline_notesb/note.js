const mongoose = require('mongoose');

const noteSchema = new mongoose.Schema({
  title: String,
  content: String,
  dateCreated: Date,
  dateModified: Date,
  syncStatus: String,
  version: Number,
  isDeleted: Boolean,
});

module.exports = mongoose.model('Note', noteSchema);
