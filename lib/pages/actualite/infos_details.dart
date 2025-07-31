import 'package:fscore/controllers/competition/date.dart';
import 'package:fscore/core/extension/list_extension.dart';
import 'package:fscore/core/params/categorie/categorie_params.dart';
import 'package:fscore/models/competition.dart';
import 'package:fscore/models/infos/infos.dart';
import 'package:fscore/providers/competition_provider.dart';
import 'package:fscore/providers/infos_provider.dart';
import 'package:fscore/widget/infos/infos_error_widget.dart';
import 'package:fscore/widget/infos/infos_widget.dart';
import 'package:fscore/widget/logos/competition_logo_image.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:fscore/widget/sponsor/sponsor_list_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfosDetails extends StatefulWidget {
  final Infos infos;
  const InfosDetails({super.key, required this.infos});

  @override
  State<InfosDetails> createState() => _InfosDetailsState();
}

class _InfosDetailsState extends State<InfosDetails> {
  late final ScrollController _scrollController;
  Color color = Colors.black;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: Scaffold(
          /* backgroundColor: Color(0xFFEDE7F6), violet clair */
          body: Consumer<CompetitionProvider>(
              builder: (context, competitionProvider, child) {
        final Competition? competition = competitionProvider
            .collection.competitions
            .singleWhereOrNull((competition) =>
                competition.codeEdition == widget.infos.idEdition);

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            ListenableBuilder(
                listenable: _scrollController,
                builder: (context, _) {
                  return SliverAppBar(
                    foregroundColor: _scrollController.offset > 200
                        ? Colors.white
                        : Colors.black,
                    elevation: 2,
                    expandedHeight: 300,
                    pinned: true,
                    leading: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.navigate_before,
                        )),
                    flexibleSpace: FlexibleSpaceBar(
                      title: Row(
                        children: [
                          if (competition != null) ...[
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: CompetitionImageLogoWidget(
                                  url: competition.imageUrl),
                            ),
                            SizedBox(width: 10)
                          ],
                          Text(
                            competition?.nomCompetition ?? 'Global',
                            style: TextStyle(
                              fontSize: 17,
                              color: _scrollController.offset > 200
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      expandedTitleScale: 1,
                      background: Hero(
                        tag: widget.infos.idInfos,
                        child: Center(
                          child: Container(
                            constraints: BoxConstraints(minHeight: 200),
                            width: MediaQuery.of(context).size.width,
                            child: (widget.infos.imageUrl ?? '').isEmpty
                                ? InfosErrorWidget()
                                : CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: widget.infos.imageUrl ?? '',
                                    errorWidget: (context, url, error) =>
                                        InfosErrorWidget(),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height),
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(widget.infos.source!),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(DateController.frDateTime(
                                      widget.infos.datetime)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.infos.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.infos.text,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          AutreInfosWidet(info: widget.infos),
                        ],
                      ),
                    ),
                  ),
                  SponsorListWidget(
                    categorieParams: null,
                  ),
                ],
              ),
            ),
          ],
        );
      })),
    );
  }
}

// -----------------------------------------Autre infos-----------------------------------------------

class AutreInfosWidet extends StatelessWidget {
  final Infos info;
  const AutreInfosWidet({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Consumer<InfosProvider>(builder: (context, val, child) {
      List<Infos> infos = val.getInfosBy(
          idInfosExclus: info.idInfos,
          categorie: CategorieParams(
            idEdition: info.idEdition,
            idGame: info.idGame,
            idParticipant: info.idParticipant,
            idJoueur: info.idJoueur,
            idArbitre: info.idArbitre,
            idCoach: info.idCoach,
          ));
      return infos.isEmpty
          ? const SizedBox()
          : Container(
              child: Column(children: [
                SizedBox(
                  height: 200,
                ),
                Center(
                  child: Text(
                    'Autre information',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                ...infos.map((e) => InfosLessWidget(infos: e)).toList()
              ]),
            );
    });
  }
}
