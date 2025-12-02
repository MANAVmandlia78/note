import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesHome(),
    );
  }
}

class NotesHome extends StatefulWidget {
  const NotesHome({super.key});

  @override
  State<NotesHome> createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  List<String> notes = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  /// Load stored notes
  void loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notes = prefs.getStringList("notes") ?? [];
    });
  }

  /// Add and store note
  void addNote() async {
    if (controller.text.isEmpty) return;

    setState(() {
      notes.add(controller.text);
      controller.clear();
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("notes", notes);
  }

  /// Delete and update notes
  void deleteNote(int index) async {
    setState(() {
      notes.removeAt(index);
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("notes", notes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notes App")),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Enter note",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          ElevatedButton(
            onPressed: addNote,
            child: const Text("Add Note"),
          ),

          Expanded(
            child: notes.isEmpty
                ? const Center(child: Text("No notes yet"))
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, i) {
                      return Card(
                        child: ListTile(
                          title: Text(notes[i]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteNote(i),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
