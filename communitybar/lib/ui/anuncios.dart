import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class Event {
  String title;
  String description;
  String picture; // You can use image URLs or local asset paths
  DateTime date;
  List<String> participants;

  Event(this.title, this.description, this.picture, this.date, this.participants);
}

class EventManager {
  List<Event> events = [];

  void createEvent(Event event) {
    events.add(event);
  }

  void updateEvent(Event oldEvent, Event newEvent) {
    int index = events.indexOf(oldEvent);
    if (index != -1) {
      events[index] = newEvent;
    }
  }

  void deleteEvent(Event event) {
    events.remove(event);
  }
}



class Announcements extends StatelessWidget {
  final EventManager eventManager = EventManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Announcements',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: EventListScreen(eventManager: eventManager),
    );
  }
}

class EventListScreen extends StatefulWidget {
  final EventManager eventManager;

  EventListScreen({required this.eventManager});

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event Announcements')),
      body: ListView.builder(
        itemCount: widget.eventManager.events.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.eventManager.events[index].title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailScreen(
                    event: widget.eventManager.events[index],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventFormScreen(
                eventManager: widget.eventManager,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  final Event event;

  EventDetailScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: Column(
        children: [
          Image.network(event.picture), // Display picture using network image or local asset
          Text(event.description),
          Text('Date: ${event.date.toString()}'),
          Text('Participants: ${event.participants.join(', ')}'),
        ],
      ),
    );
  }
}

class EventFormScreen extends StatefulWidget {
  final EventManager eventManager;

  EventFormScreen({required this.eventManager});

  @override
  _EventFormScreenState createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _pictureController;
  late TextEditingController _dateController;
  File? _selectedImage; // Variable to store the selected image file

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _pictureController = TextEditingController();
    _dateController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _pictureController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _submitForm() {
    String title = _titleController.text;
    String description = _descriptionController.text;
    String picture = _pictureController.text;
    DateTime date = DateTime.parse(_dateController.text);

    Event newEvent = Event(title, description, picture, date, []);

    widget.eventManager.createEvent(newEvent);

    Navigator.pop(context);
  }

  void _openImagePicker() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear un nuevo evento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Nombre de evento'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripcion'),
            ),
            ElevatedButton(
              onPressed: _openImagePicker, // Call the image picker method
              child: Text('Elegir Imagen'),
            ),
            _selectedImage != null
                ? Image.file(_selectedImage!) // Display the selected image
                : SizedBox(),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Crear Evento'),
            ),
          ],
        ),
      ),
    );
  }
}