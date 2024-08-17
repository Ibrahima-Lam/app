import 'package:app/core/params/categorie/categorie_params.dart';
import 'package:app/models/infos/infos.dart';
import 'package:app/models/sponsor.dart';
import 'package:app/pages/actualite/infos_details.dart';
import 'package:app/providers/infos_provider.dart';
import 'package:app/providers/sponsor_provider.dart';
import 'package:app/widget/infos/infos_error_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FicheInfosWidget extends StatelessWidget {
  final CategorieParams categorieParams;
  const FicheInfosWidget({
    super.key,
    required this.categorieParams,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<InfosProvider>().getInformations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('erreur!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer<InfosProvider>(
              builder: (context, infosProvider, child) {
            final Infos? info =
                infosProvider.getInfosBy(categorie: categorieParams).lastOrNull;
            return info == null
                ? const SizedBox()
                : Container(
                    padding: const EdgeInsets.only(top: 5.0),
                    constraints: const BoxConstraints(minHeight: 200),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => InfosDetails(infos: info)));
                      },
                      child: Card(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          constraints: const BoxConstraints(
                            minHeight: 100,
                          ),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                    top: 5, left: 2, right: 2, bottom: 5),
                                constraints:
                                    const BoxConstraints(maxHeight: 250),
                                child: (info.imageUrl ?? '').isEmpty
                                    ? InfosErrorWidget()
                                    : CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: info.imageUrl ?? '',
                                        errorWidget: (context, url, error) =>
                                            AnimatedContainer(
                                          duration: Durations.medium1,
                                          child: Image.asset(
                                            'images/infos.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: Text(
                                  info.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
          });
        });
  }
}

class FicheSponsorWidget extends StatelessWidget {
  final CategorieParams categorieParams;
  const FicheSponsorWidget({
    super.key,
    required this.categorieParams,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SponsorProvider>(
        builder: (context, sponsorProvider, child) {
      List<Sponsor> sponsors = [];
      if (!categorieParams.isNull) {
        sponsors = sponsorProvider.sponsors;
      } else
        sponsors = sponsorProvider.sponsors;
      sponsors..shuffle();

      Sponsor? sponsor = sponsors.lastOrNull;

      return sponsor == null
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Card(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  constraints: const BoxConstraints(
                    minHeight: 200,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: sponsor.imageUrl.isEmpty
                            ? FichesErrorWidget()
                            : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: sponsor.imageUrl,
                                errorWidget: (context, url, error) =>
                                    FichesErrorWidget(),
                              ),
                      ),
                      Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(sponsor.nom))
                    ],
                  ),
                ),
              ),
            );
    });
  }
}

class FichesErrorWidget extends StatelessWidget {
  const FichesErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Durations.medium1,
        child: Image.asset('images/football.jpg', fit: BoxFit.cover));
  }
}
