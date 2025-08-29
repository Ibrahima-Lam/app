import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
                leading: FaIcon(FontAwesomeIcons.link),
                title: Text('https://fscore-sport.web.app'),
                onTap: () async {
                  String url = 'https://fscore-sport.web.app';
                  await launchUrl(Uri.parse(url));
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: FaIcon(FontAwesomeIcons.facebook),
                title: Text('Facebook'),
                onTap: () async {
                  String url =
                      'https://www.facebook.com/profile.php?id=61563923128420';
                  await launchUrl(Uri.parse(url));
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: FaIcon(FontAwesomeIcons.instagram),
                title: Text('Instagram'),
              ),
            ),
            Card(
              child: ListTile(
                leading: FaIcon(FontAwesomeIcons.telegram),
                title: Text('Télégram'),
                onTap: () async {
                  String url = 'https://t.me/FscoreApp';
                  launchUrl(Uri.parse(url));
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: FaIcon(FontAwesomeIcons.whatsapp),
                title: Text('Whatsapp'),
                onTap: () async {
                  String url =
                      'https://whatsapp.com/channel/0029VagPQsOC6ZvaTk2FcU11';
                  await launchUrl(Uri.parse(url));
                },
              ),
            ),
            // play store
            Card(
              child: ListTile(
                leading: FaIcon(FontAwesomeIcons.googlePlay),
                title: Text('Google Play Store'),
                onTap: () async {
                  String url =
                      'https://play.google.com/store/apps/details?id=com.fscore.app';
                  await launchUrl(Uri.parse(url));
                },
              ),
            ),
            // play store
            Card(
              child: ListTile(
                leading: FaIcon(FontAwesomeIcons.download),
                title: Text('APKPure'),
                onTap: () async {
                  String url = 'https://apkpure.com/p/com.fscore.app';
                  await launchUrl(Uri.parse(url));
                },
              ),
            ),
            SizedBox(height: 20),
            Text('Développé par: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Ibrahima Lam "Amadou Dialadé Lam"'),
            Text('Mauritanie, Boghé, Thialgou'),
            SizedBox(height: 20),
            FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (context, asyncSnapshot) {
                  return Center(
                    child: Text(
                      'Version ${asyncSnapshot.data?.version ?? ''}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  );
                }),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
