// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Task {
  int id;
  String title;
  String content;
  bool done;
  bool urgent;
  Task({
    required this.id,
    required this.title,
    required this.content,
    required this.done,
    required this.urgent,
  });

  Task copyWith({
    int? id,
    String? title,
    String? content,
    bool? done,
    bool? urgent,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      done: done ?? this.done,
      urgent: urgent ?? this.urgent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'done': done,
      'urgent': urgent,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
      done: map['done'] as bool,
      urgent: map['urgent'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Task(id: $id, title: $title, content: $content, done: $done, urgent: $urgent)';
  }

  @override
  bool operator ==(covariant Task other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.content == content &&
        other.done == done &&
        other.urgent == urgent;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        content.hashCode ^
        done.hashCode ^
        urgent.hashCode;
  }
}
