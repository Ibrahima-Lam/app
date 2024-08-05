import 'package:app/pages/skelton/contact_page.dart';
import 'package:flutter/material.dart';

class SignalerPage extends StatelessWidget {
  const SignalerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signaler'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Veillez contacter les administrateurs pour signaler un probleme.'),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ContactPage()));
                },
                child: Text('Contacter les administrateurs'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
