import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import 'event_edit_view.dart';

class EventDetailView extends StatelessWidget {
  final Event event;

  const EventDetailView({super.key, required this.event});

  Future<void> _showDeleteConfirm(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (context.mounted) {
        await context.read<EventService>().deleteEvent(event.id);
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventService = context.watch<EventService>();
    final eventDetail = eventService.getEventById(event.id) ?? event;
    return Scaffold(
      appBar: AppBar(
        title: Text(eventDetail.title),
        actions: [
          IconButton(
              icon: Icon(
                eventDetail.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: eventDetail.isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () =>
                  // context.read<EventService>().toggleFavorite(event.id),
                  eventService.toggleFavorite(eventDetail.id)),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventEditView(event: eventDetail),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirm(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (eventDetail.imagePath != null)
              Image.file(
                File(eventDetail.imagePath!),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            Text(eventDetail.title,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Date: ${eventDetail.date.toLocal()}'.split(' ')[0],
              // style: const TextStyle(fontSize: 16),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Price: \$${eventDetail.price.toStringAsFixed(2)}',
              // style: const TextStyle(fontSize: 16),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              eventDetail.description,
              // style: const TextStyle(fontSize: 16, color: Colors.grey),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
