import 'package:app/controllers/competition/date.dart';
import 'package:app/models/infos/infos.dart';
import 'package:app/providers/infos_provider.dart';
import 'package:app/widget/infos_widget.dart';
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
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          color = _scrollController.offset > 200 ? Colors.white : Colors.black;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDE7F6),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            foregroundColor: color,
            elevation: 2,
            expandedHeight: 300,
            pinned: true,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.navigate_before,
                )),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.infos.id,
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(minHeight: 200),
                    width: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                      imageUrl: widget.infos.imageUrl ?? '',
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/europa.jpg'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  child: Container(
                    constraints: BoxConstraints(minHeight: 300),
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
                        AutreInfosWidet(info: widget.infos),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SponsorWidget(),
                SizedBox(
                  height: 10,
                ),
                PubWidget(),
              ],
            ),
          ),
        ],
      ),
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
      List<Infos> infos = val.getInfosByInfo(info: info);
      return Container(
        child: Column(
            children: infos.map((e) => InfosLessWidget(infos: e)).toList()),
      );
    });
  }
}

class PubWidget extends StatelessWidget {
  const PubWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.grey,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(5.0),
        constraints: BoxConstraints(minHeight: 300),
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Publicité',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                  constraints: BoxConstraints(minHeight: 160),
                  color: Colors.amber,
                ))
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                  constraints: BoxConstraints(minHeight: 100),
                  color: Colors.blueAccent,
                )),
                Expanded(
                    child: Container(
                  constraints: BoxConstraints(minHeight: 100),
                  color: Colors.greenAccent,
                )),
                Expanded(
                    child: Container(
                  constraints: BoxConstraints(minHeight: 100),
                  color: Colors.redAccent,
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SponsorWidget extends StatelessWidget {
  const SponsorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.grey,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(5.0),
        constraints: BoxConstraints(minHeight: 300),
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Contenu sponsorisé',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            CircleAvatar(
              radius: 60,
              child: Text('Pub'),
            )
          ],
        ),
      ),
    );
  }
}
