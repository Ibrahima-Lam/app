import 'package:app/controllers/competition/date.dart';
import 'package:app/models/infos.dart';
import 'package:app/widget/infos_widget.dart';
import 'package:flutter/material.dart';

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
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(widget.infos.image!),
                          fit: BoxFit.cover),
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
                        AutreInfosWidet(),
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
  const AutreInfosWidet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: List.generate(
            5,
            (index) => InfosLessWidget(
                  infos: Infos(
                      id: '$index',
                      text:
                          'the text of an other new. $index it to get this here cause it can allow to be informed in all brakinking news ',
                      title:
                          'title of an other infos $index i hope this this title is so usefull cause it help to access by link to go there',
                      datetime: DateTime.parse('2024-03-23').toString(),
                      source: 'Bein Sport'),
                )),
      ),
    );
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
