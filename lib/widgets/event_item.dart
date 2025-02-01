import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import 'dart:io';

class EventItem extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const EventItem({super.key, required this.event, required this.onTap});

  Widget imageView() => event.imagePath != null
      ? Expanded(
          flex: 2,
          child: Image.file(
            File(event.imagePath!),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        )
      : Expanded(
          flex: 2,
          child: Container(
            color: Colors.grey[200],
            child: const Center(
              child: Icon(Icons.image, size: 48, color: Colors.grey),
            ),
          ),
        );

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          imageView(),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          event.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: event.isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          context.read<EventService>().toggleFavorite(event.id);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat("yyyy-MM-dd").format(event.date),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '\$${event.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      event.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
