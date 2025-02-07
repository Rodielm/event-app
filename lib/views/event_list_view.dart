import 'package:event_desktop_app/services/event_service.dart';
import 'package:event_desktop_app/views/event_add_view.dart';
import 'package:event_desktop_app/widgets/event_filter_bar.dart';
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
          EventFilterBar(
            showPastEvents: _showPastEvents,
            favoritesOnly: _favoriteOnly,
            sortBy: _sortBy,
            onShowPastEventsChanged: (val) {
              setState(() => _showPastEvents = val);
              // onFilterChange(_showPastEvents, val);
            },
            onFavoritesOnlyChanged: (val) {
              setState(() => _favoriteOnly = val);
              // onFilterChange(_favoriteOnly, val);
            },
            onSortByChanged: (val) {
              // onFilterChange(_sortBy, val);
              setState(() => _sortBy = val);
            },
          ),
          Expanded(
            child: Consumer<EventService>(
              builder: (ctx, service, _) {
                final events = service.getFilteredEvents(
                    showPastEvents: _showPastEvents,
                    favoritesOnly: _favoriteOnly,
                    sortBy: _sortBy);

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: events.length,
                  itemBuilder: (ctx, idx) => EventItem(
                    event: events[idx],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailView(event: events[idx]),
                      ),
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
