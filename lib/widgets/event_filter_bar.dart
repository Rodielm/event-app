import 'package:flutter/material.dart';

class EventFilterBar extends StatelessWidget {
  final bool showPastEvents;
  final bool favoritesOnly;
  final String sortBy;
  final ValueChanged<bool> onShowPastEventsChanged;
  final ValueChanged<bool> onFavoritesOnlyChanged;
  final ValueChanged<String> onSortByChanged;

  const EventFilterBar(
      {super.key,
      required this.showPastEvents,
      required this.favoritesOnly,
      required this.sortBy,
      required this.onShowPastEventsChanged,
      required this.onFavoritesOnlyChanged,
      required this.onSortByChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          ToggleButtons(
            isSelected: [sortBy == 'date', sortBy == 'price'],
            onPressed: (index) {
              onSortByChanged(index == 0 ? 'date' : 'price');
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Sort by Date'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Sort by Price'),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              Checkbox(
                value: showPastEvents,
                onChanged: (value) => onShowPastEventsChanged(value!),
              ),
              const Text('Show Past Events'),
            ],
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              Checkbox(
                value: favoritesOnly,
                onChanged: (value) => onFavoritesOnlyChanged(value!),
              ),
              const Text('Favorites Only'),
            ],
          ),
        ],
      ),
    );
  }
}
