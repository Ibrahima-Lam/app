import 'package:flutter/material.dart';

class SearchFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  const SearchFieldWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
        ),
        width: MediaQuery.sizeOf(context).width,
        height: 50,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  return controller.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            controller.text = '';
                          },
                          icon: Icon(Icons.clear))
                      : const SizedBox();
                }),
            border: InputBorder.none,
            hintText: 'Recherche...',
          ),
        ),
      ),
    );
  }
}
