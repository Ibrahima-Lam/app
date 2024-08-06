import 'dart:io';

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
                    path: 'ibrahimaaboulam02@gmail.com',
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
              onTap: () async {
                var whatsapp = "+22241022382";
                var whatsappURl_android =
                    "whatsapp://send?phone=" + whatsapp + "&text=";
                var whatappURL_ios =
                    "https://wa.me/$whatsapp?text=${Uri.parse("")}";
                if (Platform.isIOS) {
                  if (await canLaunchUrl(Uri.parse(whatappURL_ios))) {
                    await launchUrl(Uri.parse(whatappURL_ios));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: new Text("whatsapp non installé")));
                  }
                } else {
                  // android , web
                  if (await canLaunchUrl(Uri.parse(whatsappURl_android))) {
                    await launchUrl(Uri.parse(whatsappURl_android));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: new Text("whatsapp non installé")));
                  }
                }
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
