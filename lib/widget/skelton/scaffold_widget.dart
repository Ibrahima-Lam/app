import 'package:flutter/material.dart';

class ScaffoldWidget extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? bottom;
  final FloatingActionButton? floatButton;
  final Function()? onPressedCalendar;
  final Function()? onPressedSearch;
  final Function() onPressedStream;
  final Function()? openDrawer;
  final bool playing;
  const ScaffoldWidget({
    super.key,
    this.floatButton,
    this.bottom,
    required this.body,
    this.onPressedCalendar,
    this.onPressedSearch,
    required this.onPressedStream,
    this.openDrawer,
    this.playing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              leading: IconButton(
                onPressed: openDrawer,
                icon: Icon(Icons.menu),
              ),
              floating: true,
              pinned: true,
              title: const Text('Matchs'),
              elevation: 3,
              actions: [
                IconButton(
                  onPressed: onPressedStream,
                  icon: Icon(
                    Icons.stream_outlined,
                    color: playing ? Colors.red : Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: onPressedCalendar,
                  icon: const Icon(Icons.calendar_month),
                ),
                IconButton(
                  onPressed: onPressedSearch,
                  icon: const Icon(Icons.search),
                ),
              ],
              bottom: bottom,
            ),
          ],
          body: body,
        );
      }),
      floatingActionButton: floatButton,
    );
  }
}
