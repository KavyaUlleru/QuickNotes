const Note = require('../models/Note');

// Get all notes for a user
exports.getNotes = async (req, res) => {
  try {
    const notes = await Note.find({ user: req.user.id }).sort({ createdAt: -1 });
    res.json(notes);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
};

// Add a new note or list
exports.addNote = async (req, res) => {
  const { title, content, list } = req.body;
  try {
    const note = new Note({ user: req.user.id, title, content, list });
    await note.save();
    res.json(note);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
};
