import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycoachflutter/ExercisesPage.dart';

class UserDetailsPage extends StatelessWidget {
  final DocumentSnapshot user;

  const UserDetailsPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user['name']} ${user['surname']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${user['name']}', style: TextStyle(fontSize: 18)),
            Text('Cognome: ${user['surname']}', style: TextStyle(fontSize: 18)),
            Text('Email: ${user['email']}', style: TextStyle(fontSize: 18)),
            Text('Telefono: ${user['phone']}', style: TextStyle(fontSize: 18)),
            Text('Altezza: ${user['height']}', style: TextStyle(fontSize: 18)),
            Text('Peso: ${user['weight']}', style: TextStyle(fontSize: 18)),
            Text('BMI: ${user['bmi']}', style: TextStyle(fontSize: 18)),
            Text('Giorni di allenamento: ${user['days']}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text('Giorni:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: user.reference.collection('giorni').orderBy('day').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var days = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: days.length,
                    itemBuilder: (context, index) {
                      var day = days[index];
                      return ListTile(
                        title: Text('Giorno ${day['day']}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExercisesPage(
                                email: user['email'],
                                day: day['day'],
                              ),
                            ),
                          );
                        },
                      );
                    },
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

