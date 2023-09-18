const express = require('express');
const mongoose = require('mongoose');

const app = express();
const port = process.env.PORT || 3000;

// Connect to MongoDB
mongoose.connect('mongodb://localhost/notes', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// Define routes here (e.g., /api/notes)

// Start the server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
