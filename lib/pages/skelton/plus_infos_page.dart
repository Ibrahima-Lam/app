import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlusInfosPage extends StatelessWidget {
  const PlusInfosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Plus d\'informations'),
        ),
        body: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.link),
                title: Text('https://fscore-sport.web.app'),
                onTap: () async {
                  String url = 'https://fscore-sport.web.app';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    launchUrl(Uri.parse(url));
                  }
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.facebook),
                title: Text('Facebook'),
                onTap: () async {
                  String url =
                      'https://www.facebook.com/profile.php?id=61563923128420';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    launchUrl(Uri.parse(url));
                  }
                },
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
                onTap: () async {
                  String url = 'https://t.me/FscoreApp';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    launchUrl(Uri.parse(url));
                  }
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.chat),
                title: Text('Whatsapp'),
                onTap: () async {
                  String url =
                      'https://whatsapp.com/channel/0029VagPQsOC6ZvaTk2FcU11';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    launchUrl(Uri.parse(url));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
