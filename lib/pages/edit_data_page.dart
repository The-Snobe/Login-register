import 'package:flutter/material.dart';
import 'package:app_flutter/pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditDataPage extends StatefulWidget {
  final Map ListData;
  const EditDataPage({super.key, required this.ListData});

  @override
  State<EditDataPage> createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nom;
  late TextEditingController adresse;

  @override
  void initState() {
    super.initState();
    // Remplir les champs avec les données existantes
    nom = TextEditingController(text: widget.ListData['name']);
    adresse = TextEditingController(text: widget.ListData['description']);
  }

  Future<void> _updateData() async {
    if (formKey.currentState?.validate() ?? false) {
      final name = nom.text.trim();
      final desc = adresse.text.trim();

      if (name.isEmpty || desc.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Les champs nom et description ne peuvent pas être vides.")),
        );
        return;
      }

      final url = 'http://localhost:9000/product/update-product/${widget.ListData['id']}';

      try {
        final response = await http.put(
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
          print('Erreur lors de la mise à jour des données : ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erreur lors de la mise à jour des données.")),
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
        title: const Text("Mettre à jour"),
      ),
      body: Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16.0),
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
                controller: adresse,
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
                onPressed: _updateData,
                child: const Text("Mettre à jour"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
