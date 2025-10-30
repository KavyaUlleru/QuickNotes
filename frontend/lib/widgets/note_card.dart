import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(int index)? onToggleItem;

  const NoteCard({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
    this.onToggleItem,
  });

  Color _hexToColor(String hex) {
    final h = hex.replaceFirst('#', '');
    final s = h.length == 3 ? h.split('').map((c) => '$c$c').join() : h;
    return Color(int.parse('0xff$s'));
  }

  @override
  Widget build(BuildContext context) {
    final bg = _hexToColor(note.color);
    return GestureDetector(
      onTap: onEdit,
      child: Card(
        elevation: 2,
        color: bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Expanded(child: Text(note.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                IconButton(icon: const Icon(Icons.delete, size: 20), onPressed: onDelete),
              ],
            ),
            const SizedBox(height: 8),
            if (note.type == 'text')
              Expanded(child: Text(note.content, overflow: TextOverflow.fade))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: note.listItems.length,
                  itemBuilder: (_, i) {
                    final it = note.listItems[i];
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (onToggleItem != null) onToggleItem!(i);
                          },
                          child: Icon(it.done ? Icons.check_box : Icons.check_box_outline_blank, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(it.text, style: TextStyle(decoration: it.done ? TextDecoration.lineThrough : null))),
                      ],
                    );
                  },
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
