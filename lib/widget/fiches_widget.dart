import 'package:app/core/params/categorie/categorie_params.dart';
import 'package:app/models/infos/infos.dart';
import 'package:app/pages/actualite/infos_details.dart';
import 'package:app/providers/infos_provider.dart';
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
    return StreamBuilder(
        stream: context.read<InfosProvider>().getInformations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('erreur!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer<InfosProvider>(builder: (context, infos, child) {
            final Infos? info = infos
                .infos

                /* Todo  .getInfosBy(
                 categorie: categorieParams
                )  */
                .lastOrNull;
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
                          width: MediaQuery.sizeOf(context).width,
                          constraints: const BoxConstraints(
                            minHeight: 100,
                          ),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width,
                                padding: const EdgeInsets.only(
                                    top: 5, left: 2, right: 2, bottom: 5),
                                constraints:
                                    const BoxConstraints(maxHeight: 250),
                                child: CachedNetworkImage(
                                  imageUrl: '',
                                  errorWidget: (context, url, error) =>
                                      AnimatedContainer(
                                    duration: Durations.medium1,
                                    child: Image.asset(
                                      'images/santiago.jpg',
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
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Card(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          constraints: const BoxConstraints(
            minHeight: 200,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: '',
                errorWidget: (context, url, error) => AnimatedContainer(
                    duration: Durations.medium1,
                    child: Image.asset('images/fusion.jpg', fit: BoxFit.cover)),
              ),
              Container(
                  padding: const EdgeInsets.all(10.0), child: Text('Sponsor'))
            ],
          ),
        ),
      ),
    );
  }
}
