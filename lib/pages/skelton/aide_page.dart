import 'package:fscore/pages/skelton/contact_page.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:flutter/material.dart';

class AidePage extends StatelessWidget {
  const AidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Aide'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Veillez contacter les administrateurs pour plus d\'informations.'),
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
      ),
    );
  }
}
