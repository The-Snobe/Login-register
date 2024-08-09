import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home_page.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nom = TextEditingController();
  final TextEditingController description = TextEditingController();

  Future<void> _submitData() async {
    if (formKey.currentState?.validate() ?? false) {
      final name = nom.text.trim();
      final desc = description.text.trim();

      // Vérifiez que les champs ne sont pas vides avant d'envoyer la requête
      if (name.isEmpty || desc.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Les champs nom et description ne peuvent pas être vides.")),
        );
        return;
      }

      final url = 'http://localhost:9000/product/create-product/';

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',  // Ajout du Content-Type
            'Accept': 'application/json',
          },
          body: jsonEncode({'name': name, 'description': desc}),
        );

        if (response.statusCode == 200) {
          // Si la requête est réussie, naviguer vers HomePage
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
          );
        } else {
          print('Erreur lors de l\'ajout des données : ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erreur lors de l'ajout des données.")),
          );
        }
      } catch (e) {
        print('Erreur de connexion : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur de connexion.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajout des données"),
      ),
      body: Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: nom,
                decoration: const InputDecoration(
                  labelText: "Nom",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Le nom ne peut être vide.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: description,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "La description ne peut être vide.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text("Enregistrer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
