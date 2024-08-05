import 'package:flutter/material.dart';

class PlusInfosPage extends StatelessWidget {
  const PlusInfosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plus d\'informations'),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.facebook),
              title: Text('Facebook'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.pages),
              title: Text('Instagram'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.telegram),
              title: Text('Télégram'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.chat),
              title: Text('Whatsapp'),
            ),
          ),
        ],
      ),
    );
  }
}
