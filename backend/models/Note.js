import mongoose from 'mongoose';

const listItemSchema = new mongoose.Schema({
  text: { type: String, required: true },
  completed: { type: Boolean, default: false },
});

const noteSchema = new mongoose.Schema(
  {
    title: { type: String, required: true },
    content: { type: String },
    type: { type: String, enum: ['note', 'list', 'text'], default: 'note' },
    listItems: [listItemSchema],
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  },
  { timestamps: true }
);

export default mongoose.model('Note', noteSchema);
