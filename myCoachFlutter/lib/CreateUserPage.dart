import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({Key? key}) : super(key: key);

  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();

  Future<void> _createUser() async {
    String name = _nameController.text;
    String surname = _surnameController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
    String height = _heightController.text;
    String weight = _weightController.text;
    String bmi = _bmiController.text;
    String days = _daysController.text;

    if (name.isNotEmpty &&
        surname.isNotEmpty &&
        email.isNotEmpty &&
        phone.isNotEmpty &&
        height.isNotEmpty &&
        weight.isNotEmpty &&
        bmi.isNotEmpty &&
        days.isNotEmpty) {
      int? daysInt = int.tryParse(days);

      if (daysInt == null || daysInt < 1 || daysInt > 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('I giorni possono essere massimo 5')),
        );
      } else {
        DocumentReference userRef = await FirebaseFirestore.instance.collection('users').add({
          'name': name,
          'surname': surname,
          'email': email,
          'phone': phone,
          'height': height,
          'weight': weight,
          'bmi': bmi,
          'days': days,
        });

        for (int i = 1; i <= daysInt; i++) {
          await userRef.collection('giorni').add({
            'email': email,
            'day': i,
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Utente creato con successo')),
        );

        // Clear the input fields
        _nameController.clear();
        _surnameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _heightController.clear();
        _weightController.clear();
        _bmiController.clear();
        _daysController.clear();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compila tutti i campi correttamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crea allievo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextFormField(
                controller: _surnameController,
                decoration: const InputDecoration(labelText: 'Cognome'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Telefono'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      decoration: const InputDecoration(labelText: 'Altezza'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      decoration: const InputDecoration(labelText: 'Peso'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _bmiController,
                      decoration: const InputDecoration(labelText: 'BMI'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _daysController,
                      decoration: const InputDecoration(labelText: 'Giorni(max 5gg)'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createUser,
                child: const Text('Aggiungi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}