import 'package:flutter/material.dart';

class FavoriTitleWidget extends StatelessWidget {
  final bool nonFavori;
  const FavoriTitleWidget({
    super.key,
    this.nonFavori = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      shadowColor: Colors.grey,
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
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
                  SizedBox(
                      width: 35,
                      height: 35,
                      child: Icon(nonFavori ? Icons.star_border : Icons.star)),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Text(
                      nonFavori ? 'Autre' : "Favori",
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
