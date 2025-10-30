import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';
import 'add_note_screen.dart';
import 'add_list_screen.dart';
import 'edit_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => loading = true);
    final fetched = await ApiService.getNotes();
    setState(() {
      notes = fetched;
      loading = false;
    });
  }

  void _delete(String id) async {
    await ApiService.deleteNote(id);
    _fetch();
  }

  void _logout() async {
    await ApiService.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _toggleListItem(Note note, int index) async {
    await ApiService.toggleListItem(note.id, index);
    _fetch();
  }

  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(children: [
          ListTile(
            leading: const Icon(Icons.note_add),
            title: const Text('Add Note'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/add_note').then((_) => _fetch());
            },
          ),
          ListTile(
            leading: const Icon(Icons.playlist_add_check),
            title: const Text('Add List'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/add_list').then((_) => _fetch());
            },
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickNotes'),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetch,
              child: notes.isEmpty
                  ? ListView(
                      children: const [SizedBox(height: 120), Center(child: Text('No notes yet — create one!'))],
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 360,
                        childAspectRatio: 1.0,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                      itemCount: notes.length,
                      itemBuilder: (context, idx) {
                        final n = notes[idx];
                        return NoteCard(
                          note: n,
                          onEdit: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (_) => EditNoteScreen(note: n)));
                            _fetch();
                          },
                          onDelete: () => _delete(n.id),
                          onToggleItem: (index) => _toggleListItem(n, index),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMenu,
        child: const Icon(Icons.add),
      ),
    );
  }
}
