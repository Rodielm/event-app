import 'package:event_desktop_app/services/event_service.dart';
import 'package:event_desktop_app/views/event_add_view.dart';
import 'package:event_desktop_app/widgets/event_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'event_detail.view.dart';

class EventListView extends StatefulWidget {
  const EventListView({super.key});

  @override
  EventListViewState createState() => EventListViewState();
}

class EventListViewState extends State<EventListView> {
  bool _showPastEvents = false;
  bool _favoriteOnly = false;
  String _sortBy = 'date';

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event List'),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 80),
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to the event creation view
              Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => EventAddView(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<EventService>(
              builder: (ctx, service, _) {
                final events = service.events;

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: events.length,
                  itemBuilder: (ctx, idx) => Card(
                    child: TextButton(
                      onPressed: () => {},
                      child: Text(''),
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
