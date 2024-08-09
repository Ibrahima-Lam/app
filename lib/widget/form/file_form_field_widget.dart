import 'dart:io';

import 'package:app/widget/form/text_form_field_widget.dart';
import 'package:app/widget/modals/confirm_dialog_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FileFormFieldWidget extends StatefulWidget {
  final String hintText;
  final String directory;
  final TextEditingController controller;
  const FileFormFieldWidget(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.directory});

  @override
  State<FileFormFieldWidget> createState() => _FileFormFieldWidgetState();
}

class _FileFormFieldWidgetState extends State<FileFormFieldWidget> {
  bool isLoading = false;
  void setIsloading(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  void _storeImage(XFile image) async {
    final bool? confirm = await showDialog(
        context: context,
        builder: (context) => ConfirmDialogWidget(
            title: 'Enregistrer ?',
            content: 'Voulez vous enregistrer cette image ?'));
    if (confirm != true) return;
    setIsloading(true);
    final FirebaseStorage storage = FirebaseStorage.instance;
    File file = File(image.path);
    Reference ref = storage.ref().child('${widget.directory}/${image.name}');
    await ref.putFile(file);
    widget.controller.text = await ref.getDownloadURL();
    setIsloading(false);
  }

  void _onCameraPressed() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _storeImage(image);
    }
  }

  void _onGalleryPressed() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _storeImage(image);
    }
  }

  _onListPressed() async {
    final String? url = await showModalBottomSheet<String>(
        context: context,
        builder: (context) => FilesBottomSheet(directory: widget.directory));
    if ((url ?? '').isNotEmpty) {
      widget.controller.text = url!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        TextFormFieldWidget(
          prefixIcon: IconButton(
              onPressed: _onListPressed, icon: const Icon(Icons.list)),
          suffixIcon: PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: IconButton(
                  onPressed: _onGalleryPressed,
                  icon: const Icon(Icons.attach_file),
                ),
                value: 1,
              ),
              PopupMenuItem(
                child: IconButton(
                  onPressed: _onCameraPressed,
                  icon: const Icon(Icons.camera_alt),
                ),
              ),
            ],
          ),
          controller: widget.controller,
          hintText: widget.hintText,
          keyboardType: TextInputType.url,
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }
}

class FilesBottomSheet extends StatelessWidget {
  final String directory;
  const FilesBottomSheet({super.key, required this.directory});

  Future<List<Map<String, dynamic>>> _getFiles() async {
    List<Map<String, dynamic>> files = [];
    final FirebaseStorage storage = FirebaseStorage.instance;
    final references = await storage.ref().child(directory).list();
    print(references.items);
    for (final Reference reference in references.items) {
      files.add({
        'name': reference.name,
        'url': await reference.getDownloadURL(),
      });
    }
    return files;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getFiles(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final List<Map> references = snapshot.data ?? [];

          return DraggableScrollableSheet(
              initialChildSize: 0.9,
              builder: (context, controller) {
                return references.isEmpty
                    ? Center(child: Text('Aucune image'))
                    : ListView.builder(
                        controller: controller,
                        itemCount: references.length,
                        itemBuilder: (context, index) {
                          print(references[index]['url']);
                          return ListTile(
                            onTap: () => Navigator.pop(
                                context, references[index]['url'] ?? ''),
                            leading: (references[index]['url'] ?? '').isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: ImageWidget(
                                                      url: references[index]
                                                          ['url']),
                                                ),
                                              ));
                                    },
                                    child: ClipOval(
                                      child: ImageWidget(
                                          url: references[index]['url']),
                                    ),
                                  )
                                : const Icon(Icons.error),
                            title: Text(references[index]['name'],
                                overflow: TextOverflow.ellipsis, maxLines: 2),
                            trailing: IconButton(
                              onPressed: () async {
                                final bool? confirm = await showDialog(
                                    context: context,
                                    builder: (context) => ConfirmDialogWidget(
                                        title: 'Supprimer ?',
                                        content:
                                            'Voulez vous supprimer cette image ?'));
                                if (confirm != true) return;
                                final FirebaseStorage storage =
                                    FirebaseStorage.instance;
                                await storage
                                    .ref()
                                    .child(directory)
                                    .child(references[index]['name'])
                                    .delete();
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          );
                        },
                      );
              });
        });
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
