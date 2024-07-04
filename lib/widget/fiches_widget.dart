import 'package:app/models/infos/infos.dart';
import 'package:app/pages/actualite/infos_details.dart';
import 'package:app/providers/infos_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FicheInfosWidget extends StatelessWidget {
  final String? idPartcipant;
  final String? idJoueur;
  final String? idEdition;
  final String? idGame;
  const FicheInfosWidget(
      {super.key,
      this.idPartcipant,
      this.idEdition,
      this.idGame,
      this.idJoueur});

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
                /* .getInfosBy(
                  idEdition: idEdition,
                  idGame: idGame,
                  idJoueur: idJoueur,
                  idPartcipant: idPartcipant,
                ) */
                .lastOrNull;
            return info == null
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(top: 5.0),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                imageUrl: '',
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.asset('images/europa.jpg'),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: Text(
                                  info.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
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
  final String? idPartcipant;
  final String? idJoueur;
  final String? idEdition;
  final String? idGame;
  const FicheSponsorWidget(
      {super.key,
      this.idPartcipant,
      this.idEdition,
      this.idGame,
      this.idJoueur});

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
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Image.asset('images/messi.jpg'),
              ),
              Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('sponsor officielle'))
            ],
          ),
        ),
      ),
    );
  }
}
