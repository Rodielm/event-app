import 'package:uuid/uuid.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final double price;
  final String? imagePath;
  bool isFavorite;

  Event({
    String? id,
    required this.title,
    required this.description,
    required this.date,
    required this.price,
    this.imagePath,
    this.isFavorite = false,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
        'price': price,
        'imagePath': imagePath,
        'isFavorite': isFavorite,
      };

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      price: json['price'].toDouble(),
      imagePath: json['imagePath'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
