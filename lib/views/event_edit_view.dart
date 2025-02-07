import 'dart:io';

import 'package:event_desktop_app/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';

class EventEditView extends StatefulWidget {
  final Event event;

  const EventEditView({super.key, required this.event});

  @override
  _EventEditViewState createState() => _EventEditViewState();
}

class _EventEditViewState extends State<EventEditView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _descriptionCtrl;
  late TextEditingController _priceCtrl;
  late DateTime _selectedDate;
  String? _imagePath;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.event.title);
    _descriptionCtrl = TextEditingController(text: widget.event.description);
    _priceCtrl = TextEditingController(text: widget.event.price.toString());
    _selectedDate = widget.event.date;
    _imagePath = widget.event.imagePath;
  }

  void _onChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  Future<bool> _confirmDiscard() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text('Do you want to discard your unsaved changes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      final updatedEvent = Event(
        id: widget.event.id,
        title: _titleCtrl.text,
        description: _descriptionCtrl.text,
        date: _selectedDate,
        price: double.parse(_priceCtrl.text),
        imagePath: _imagePath,
        isFavorite: widget.event.isFavorite,
      );
      await context.read<EventService>().updateEvent(updatedEvent);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && _hasChanges) {
          bool discard = await _confirmDiscard();
          if (discard) {
            Navigator.of(context).pop(true); // Pass result back
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Event'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.length < 5 ||
                        value.length > 50) {
                      return 'Title must be between 5 and 50 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionCtrl,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) {
                    if (value != null &&
                        (value.length < 5 || value.length > 255)) {
                      return 'Description must be between 5 and 255 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceCtrl,
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              double.parse(value) < 0) {
                            return 'Price must be a non-negative number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'Date'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_selectedDate.toLocal()}'.split(' ')[0],
                              ),
                              const Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_imagePath != null)
                  Image.file(
                    File(_imagePath!),
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Select Image'),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _updateEvent,
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }
}
