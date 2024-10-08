import 'package:app/controllers/competition/date.dart';
import 'package:app/core/extension/list_extension.dart';
import 'package:app/models/competition.dart';
import 'package:app/models/infos/infos.dart';
import 'package:app/pages/actualite/infos_details.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/widget/infos/infos_error_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfosWidget extends StatefulWidget {
  final Infos infos;

  const InfosWidget({
    super.key,
    required this.infos,
  });

  @override
  State<InfosWidget> createState() => _InfosWidgetState();
}

class _InfosWidgetState extends State<InfosWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InfosDetails(infos: widget.infos)));
        setState(() {});
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        color: Colors.white,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 185),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: widget.infos.idInfos,
                    child: Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width * .30,
                      child: (widget.infos.imageUrl ?? '').isEmpty
                          ? InfosErrorWidget()
                          : CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: widget.infos.imageUrl ?? '',
                              errorWidget: (context, url, error) =>
                                  InfosErrorWidget()),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              widget.infos.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            widget.infos.text,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.infos.source!),
                    Text(DateController.frDateTime(widget.infos.datetime)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfosFullWidget extends StatefulWidget {
  final Infos infos;
  const InfosFullWidget({
    super.key,
    required this.infos,
  });

  @override
  State<InfosFullWidget> createState() => _InfosFullWidgetState();
}

class _InfosFullWidgetState extends State<InfosFullWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CompetitionProvider>(
        builder: (context, competitionProvider, child) {
      final Competition? competition = competitionProvider
          .collection.competitions
          .singleWhereOrNull((competition) =>
              competition.codeEdition == widget.infos.idEdition);

      return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => InfosDetails(infos: widget.infos)));
          setState(() {});
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          elevation: 2,
          color: Colors.white,
          child: Container(
            constraints: BoxConstraints(
              minHeight: 200,
            ),
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Hero(
                  tag: widget.infos.idInfos,
                  child: Container(
                    height: 260,
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
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.infos.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    widget.infos.text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(competition?.nomCompetition ?? 'Global'),
                      Text(DateController.frDateTime(widget.infos.datetime)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class InfosLessWidget extends StatelessWidget {
  final Infos infos;
  const InfosLessWidget({super.key, required this.infos});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InfosDetails(infos: infos)));
      },
      child: Container(
        constraints: BoxConstraints(maxHeight: 160),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: infos.idInfos + 'other',
              child: Container(
                height: 150,
                width: MediaQuery.of(context).size.width * .30,
                child: (infos.imageUrl ?? '').isEmpty
                    ? InfosErrorWidget()
                    : CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: infos.imageUrl ?? '',
                        errorWidget: (context, url, error) =>
                            InfosErrorWidget(),
                      ),
              ),
            ),
            Expanded(
                child: Container(
              constraints: BoxConstraints(minHeight: 150),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        infos.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        infos.text,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(DateController.frDateTime(infos.datetime)),
                    ],
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
