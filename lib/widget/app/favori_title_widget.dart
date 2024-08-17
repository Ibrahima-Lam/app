import 'package:flutter/material.dart';

class FavoriTitleWidget extends StatelessWidget {
  final bool nonFavori;
  final EdgeInsetsGeometry? margin;
  final String? title;
  final Widget? icon;
  const FavoriTitleWidget(
      {super.key, this.nonFavori = false, this.margin, this.icon, this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
      shadowColor: Colors.grey,
      elevation: 2,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 35,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.white,
              Color.fromARGB(255, 232, 247, 245),
              Colors.white,
              Color.fromARGB(255, 232, 247, 245),
            ]),
            borderRadius: BorderRadius.circular(4.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (icon != null)
                    icon!
                  else
                    SizedBox(
                        width: 35,
                        height: 35,
                        child:
                            Icon(nonFavori ? Icons.star_border : Icons.star)),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Text(
                      title ?? (nonFavori ? 'Autres' : "Favoris"),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 60,
            )
          ],
        ),
      ),
    );
  }
}
