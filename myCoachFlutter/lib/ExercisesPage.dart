import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mycoachflutter/CreateUserPage.dart';
import 'package:mycoachflutter/UserDetailsPage.dart';
import 'firebase_options.dart';

class ExercisesPage extends StatefulWidget {
  final String email;
  final int day;

  const ExercisesPage({Key? key, required this.email, required this.day}) : super(key: key);

  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  Future<void> _addExercise() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController seriesController = TextEditingController();
    TextEditingController repetitionsController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Esercizio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome esercizio'),
              ),
              TextField(
                controller: seriesController,
                decoration: const InputDecoration(labelText: 'Serie'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: repetitionsController,
                decoration: const InputDecoration(labelText: 'Ripetizioni'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    seriesController.text.isNotEmpty &&
                    repetitionsController.text.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.email)
                      .collection('giorni')
                      .doc(widget.day.toString())
                      .collection('exercises')
                      .add({
                    'name': nameController.text,
                    'series': seriesController.text,
                    'repetitions': repetitionsController.text,
                    'email': widget.email,
                    'day': widget.day,
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Aggiungi'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giorno ${widget.day}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addExercise,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.email)
            .collection('giorni')
            .doc(widget.day.toString())
            .collection('exercises')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var exercises = snapshot.data!.docs;
          return ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              var exercise = exercises[index];
              return ListTile(
                title: Text(exercise['name']),
                subtitle: Text('Serie: ${exercise['series']}, Ripetizioni: ${exercise['repetitions']}'),
              );
            },
          );
        },
      ),
    );
  }
}