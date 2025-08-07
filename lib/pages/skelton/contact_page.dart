import 'dart:io';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: Scaffold(
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
                leading: FaIcon(FontAwesomeIcons.phone),
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
                leading: FaIcon(FontAwesomeIcons.commentSms),
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
                leading: FaIcon(FontAwesomeIcons.envelope),
                title: Text('Email'),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () async {
                  var whatsapp = "+22241022382";
                  var whatsappURl_android =
                      "whatsapp://send?phone=" + whatsapp + "&text=FScore";
                  var whatappURL_ios =
                      "https://wa.me/$whatsapp?text=${Uri.parse("")}";
                  if (Platform.isIOS) {
                    await launchUrl(Uri.parse(whatappURL_ios),
                        mode: LaunchMode.externalApplication);
                  } else {
                    // android , web
                    await launchUrl(Uri.parse(whatsappURl_android),
                        mode: LaunchMode.externalApplication);
                  }
                },
                leading: FaIcon(FontAwesomeIcons.whatsapp),
                title: Text('Whatsapp'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
