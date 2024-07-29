import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact'),
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              onTap: () {
                try {
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: '+22241022382',
                  );
                  launchUrl(launchUri);
                } catch (e) {}
              },
              leading: Icon(Icons.call),
              title: Text('Appeler'),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                try {
                  final Uri launchUri = Uri(
                    scheme: 'sms',
                    path: '+22241022382',
                  );
                  launchUrl(launchUri);
                } catch (e) {}
              },
              leading: Icon(Icons.sms),
              title: Text('SMS'),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                try {
                  final Uri launchUri = Uri(
                    scheme: 'mailto',
                    path: 'ibrahimaaboulam@gmail.com',
                  );
                  launchUrl(launchUri);
                } catch (e) {}
              },
              leading: Icon(Icons.mail),
              title: Text('Email'),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                try {
                  launchUrl(Uri.parse('https://web.whatsapp.com/'),
                      mode: LaunchMode.externalApplication);
                } catch (e) {}
              },
              leading: Icon(Icons.chat),
              title: Text('Whatsapp'),
            ),
          ),
        ],
      ),
    );
  }
}
