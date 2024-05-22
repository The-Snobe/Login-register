import 'package:flutter/material.dart';
import 'package:app_flutter/pages/home_page.dart';

class EditDataPage extends StatefulWidget {
  final Map ListData;
  const EditDataPage({super.key, required this.ListData});

  @override
  State<EditDataPage> createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController matricule = TextEditingController();
  TextEditingController nom = TextEditingController();
  TextEditingController adresse = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mettre a jour"),
      ),
      body: Form(
        key: formkey,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: matricule,
                decoration: const InputDecoration(
                  labelText: "Matricule",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Le matricule ne peut etre vide.";
                  }
                },
              ),
              SizedBox(height: 16.0),
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
                    return "Le nom ne peut etre vide.";
                  }
                },
              ),
              SizedBox(height: 16.0,),
              TextFormField(
                controller: adresse,
                decoration: const InputDecoration(
                  labelText: "Adresse",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "L'adresse ne peut etre vide.";
                  }
                },
              ),
              SizedBox(height: 16.0,),
              ElevatedButton(onPressed: (){
                Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: ((context)=>HomePage())), (route) => false);
              }, child: const Text("Mettre a jour"))
            ],
          ),
        ),
      ),
    );
  }
}