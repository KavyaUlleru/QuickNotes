class Note {
  final String id;
  final String type; // 'text' or 'list'
  final String title;
  final String content;
  final String color; // hex like #fff or #ffffff
  final List<ListItem> listItems;

  Note({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.color,
    required this.listItems,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    List<ListItem> items = [];
    if (json['listItems'] != null) {
      items = (json['listItems'] as List)
          .map((i) => ListItem.fromJson(i))
          .toList();
    }
    return Note(
      id: json['_id'],
      type: json['type'] ?? 'text',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      color: json['color'] ?? '#ffffff',
      listItems: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'content': content,
      'color': color,
      'listItems': listItems.map((e) => e.toJson()).toList(),
    };
  }
}

class ListItem {
  String text;
  bool done;
  ListItem({required this.text, required this.done});

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(text: json['text'] ?? '', done: json['done'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'done': done};
  }
}
