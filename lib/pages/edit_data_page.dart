import 'package:flutter/material.dart';
import 'package:app_flutter/pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditDataPage extends StatefulWidget {
  final Map listData;
  const EditDataPage({super.key, required this.listData});

  @override
  State<EditDataPage> createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nomController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    // Remplir les champs avec les données existantes
    nomController = TextEditingController(text: widget.listData['name']);
    descriptionController = TextEditingController(text: widget.listData['description']);
  }

  Future<void> _updateData() async {
    if (formKey.currentState?.validate() ?? false) {
      final name = nomController.text.trim();
      final description = descriptionController.text.trim();

      if (name.isEmpty || description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Les champs nom et description ne peuvent pas être vides.")),
        );
        return;
      }

      // Récupérer automatiquement l'ID du produit depuis listData
      final id = widget.listData['id'];
      final url = 'http://localhost:9000/product/update-product/$id';

      try {
        final response = await http.put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({'name': name, 'description': description}),
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
      appBar: AppBar(title: const Text('Modifier les données')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomController,
                decoration: const InputDecoration(labelText: 'Nom du produit'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le nom ne peut pas être vide.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La description ne peut pas être vide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateData,
                child: const Text('Mettre à jour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
