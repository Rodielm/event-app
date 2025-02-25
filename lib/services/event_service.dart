import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';

class EventService with ChangeNotifier {
  static const String _storageKey = 'events';
  List<Event> _events = [];
  final SharedPreferences _prefs;

  List<Event> get events => _events;

  EventService(this._prefs) {
    _loadEvents();
  }

  Event? getEventById(String id) {
    return _events.firstWhere((e) => e.id == id);
  }

  List<Event> getFilteredEvents(
      {bool showPastEvents = false,
      bool favoritesOnly = false,
      String sortBy = 'date'}) {
    var filteredEvents = [..._events];

    if (!showPastEvents) {
      filteredEvents = filteredEvents
          .where((event) => event.date.isAfter(DateTime.now()))
          .toList();
    }

    if (favoritesOnly) {
      filteredEvents =
          filteredEvents.where((event) => event.isFavorite).toList();
    }

    switch (sortBy) {
      case 'date':
        filteredEvents.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'price':
        filteredEvents.sort((a, b) => a.price.compareTo(b.price));
        break;
    }
    return filteredEvents;
  }

  Future<void> _loadEvents() async {
    final eventsJson = _prefs.getString(_storageKey);
    if (eventsJson != null) {
      final List<dynamic> decodedEvents = json.decode(eventsJson);
      _events = decodedEvents.map((e) => Event.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveEvents() async {
    final eventsJson = json.encode(_events.map((e) => e.toJson()).toList());
    await _prefs.setString(_storageKey, eventsJson);
  }

  Future<void> addEvent(Event event) async {
    _events.add(event);
    await _saveEvents();
    notifyListeners();
  }

  Future<void> updateEvent(Event event) async {
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
      await _saveEvents();
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String id) async {
    _events.removeWhere((event) => event.id == id);
    await _saveEvents();
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    final index = _events.indexWhere((event) => event.id == id);
    if (index != -1) {
      _events[index].isFavorite = !_events[index].isFavorite;
      await _saveEvents();
    }
    await _saveEvents();
    notifyListeners();
  }
}
