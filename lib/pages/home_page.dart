import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_flutter/pages/add_data_page.dart';
import 'package:app_flutter/pages/edit_data_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _listdata = [];

  @override
  void initState() {
    super.initState();
    _getdata();
  }

  Future<void> _getdata() async {
    final url = 'http://localhost:9000/product/get-products/';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print(data);  // Pour déboguer les données reçues
        setState(() {
          _listdata = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _deletedata(String id) async {
    final url = 'http://localhost:9000/product/delete-product/$id';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
      ),
      body: ListView.builder(
        itemCount: _listdata.length,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => EditDataPage(
                      ListData: {
                        "name": _listdata[index]['name'],
                        "description": _listdata[index]['description'],
                      },
                    )),
                  ),
                );
              },
              child: ListTile(

                title: Text(_listdata[index]['name'] ?? ''),
                subtitle: Text(_listdata[index]['description'] ?? ''),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertDialog(
                          content: Text(
                            "Etes-vous sûr de vouloir supprimer les données ${_listdata[index]['name']}?",
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                String id = _listdata[index]['id'] ?? '';
                                _deletedata(id).then((value) {
                                  if (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Les données ont été supprimées avec succès"),
                                      ),
                                    );
                                    _getdata();
                                    Navigator.of(context).pop(); // Fermer le dialogue
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Échec de la suppression des données"),
                                      ),
                                    );
                                  }
                                });
                              },
                              child: const Text("Oui"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Non"),
                            ),
                          ],
                        );
                      }),
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddData()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
