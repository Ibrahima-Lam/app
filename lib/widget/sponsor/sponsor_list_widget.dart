import 'package:fscore/core/params/categorie/categorie_params.dart';
import 'package:fscore/models/sponsor.dart';
import 'package:fscore/providers/sponsor_provider.dart';
import 'package:fscore/widget/sponsor/sponsor_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SponsorListWidget extends StatelessWidget {
  final CategorieParams? categorieParams;
  SponsorListWidget({super.key, required this.categorieParams});
  final ScrollController scrollController =
      ScrollController(initialScrollOffset: 0);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<SponsorProvider>().getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('erreur!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer<SponsorProvider>(
              builder: (context, sponsorProvider, child) {
            List<Sponsor> sponsors = [];
            if (categorieParams != null && !(categorieParams?.isNull ?? true)) {
              sponsors =
                  sponsorProvider.getSponsorBy(categorie: categorieParams);
            } else
              sponsors = sponsorProvider.sponsors;
            sponsors..shuffle();
            sponsors = sponsors.take(5).toList();

            return Scrollbar(
              radius: Radius.circular(10),
              controller: scrollController,
              child: sponsors.isEmpty
                  ? const SizedBox()
                  : Container(
                      constraints: BoxConstraints(maxHeight: 360),
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: sponsors
                                .map(
                                  (e) => SponsorWidget(sponsor: e),
                                )
                                .toList()),
                      ),
                    ),
            );
          });
        });
  }
}
