import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RsvpPage extends StatefulWidget {
  const RsvpPage({super.key});

  @override
  _RsvpPageState createState() => _RsvpPageState();
}

class _RsvpPageState extends State<RsvpPage> {
  final TextEditingController _nameController = TextEditingController();
  final CollectionReference _rsvpCollection =
      FirebaseFirestore.instance.collection('rsvp');

  Future<void> _addRsvp(String name) {
    return _rsvpCollection
        .add({'name': name})
        .then((value) => print("RSVP Added"))
        .catchError((error) => print("Failed to add RSVP: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RSVP for Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addRsvp(_nameController.text);
                _nameController.clear();
              },
              child: const Text('RSVP'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _rsvpCollection.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['name']),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
