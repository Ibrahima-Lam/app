import 'package:app/models/paramettre.dart';
import 'package:app/providers/paramettre_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class CompetitionParamettreListWidget extends StatefulWidget {
  final String codeEdition;
  const CompetitionParamettreListWidget({super.key, required this.codeEdition});

  @override
  State<CompetitionParamettreListWidget> createState() =>
      _CompetitionParamettreListWidgetState();
}

class _CompetitionParamettreListWidgetState
    extends State<CompetitionParamettreListWidget> {
  bool saved = true;
  @override
  Widget build(BuildContext context) {
    return Consumer<ParamettreProvider>(
      builder: (context, paramettreProvider, child) {
        final Paramettre? paramettre =
            paramettreProvider.getCompetitionParamettre(widget.codeEdition) ??
                Paramettre(
                    idParamettre: widget.codeEdition,
                    idEdition: widget.codeEdition);

        return paramettre == null
            ? const Center(
                child: Text('Aucun paramettre trouvé'),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 5.0),
                    CompetitionParamettreListElementWidget(
                      label: 'Afficher la composition',
                      child: Switch(
                        value: paramettre.showComposition,
                        onChanged: (value) async {
                          setState(() {
                            saved = false;
                            paramettre.showComposition = value;
                          });
                        },
                      ),
                    ),
                    CompetitionParamettreListElementWidget(
                      label: 'Afficher les évènements',
                      child: Switch(
                        value: paramettre.showEvenement,
                        onChanged: (value) async {
                          setState(() {
                            saved = false;
                            paramettre.showEvenement = value;
                          });
                        },
                      ),
                    ),
                    CompetitionParamettreListElementWidget(
                      label: 'Afficher les statistiques',
                      child: Switch(
                        value: paramettre.showStatistique,
                        onChanged: (value) async {
                          setState(() {
                            saved = false;
                            paramettre.showStatistique = value;
                          });
                        },
                      ),
                    ),
                    CompetitionParamettreListElementWidget(
                      label: 'Nombre qualification',
                      child: DropdownButton(
                        alignment: Alignment.center,
                        hint: const Text('Nombre qualification'),
                        icon: const Icon(Icons.arrow_drop_down),
                        value: paramettre.success,
                        items: [
                          DropdownMenuItem(value: 0, child: const Text('0')),
                          DropdownMenuItem(value: 1, child: const Text('1')),
                          DropdownMenuItem(value: 2, child: const Text('2')),
                          DropdownMenuItem(value: 4, child: const Text('4')),
                          DropdownMenuItem(value: 8, child: const Text('8')),
                          DropdownMenuItem(value: 16, child: const Text('16')),
                          DropdownMenuItem(value: 32, child: const Text('32')),
                          DropdownMenuItem(value: 64, child: const Text('64')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            saved = false;
                            paramettre.success = value;
                          });
                        },
                      ),
                    ),
                    CompetitionUserListTileWidget(
                      users: paramettre.users,
                      onDelete: (value) {
                        setState(() {
                          saved = false;
                          paramettre.users.remove(value);
                        });
                      },
                      onEdit: (value) async {
                        final String? result = await showDialog(
                            context: context,
                            builder: (context) => UserFormWidget(user: value));
                        if (result != null && result.length > 0) {
                          setState(() {
                            saved = false;
                            paramettre.users[paramettre.users.indexOf(value)] =
                                result.trim();
                          });
                        }
                      },
                      onAdd: () async {
                        final String? result = await showDialog(
                            context: context,
                            builder: (context) => UserFormWidget());
                        if (result != null && result.length > 0) {
                          setState(() {
                            saved = false;
                            paramettre.users.add(result.trim());
                          });
                        }
                      },
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary),
                          onPressed: saved
                              ? null
                              : () async {
                                  setState(() {
                                    saved = true;
                                  });
                                  await paramettreProvider.updateParamettre(
                                      widget.codeEdition, paramettre);
                                },
                          child: const Text('Enregistrer'),
                        ),
                      ),
                    )
                  ],
                ),
              );
      },
    );
  }
}

class CompetitionUserListTileWidget extends StatelessWidget {
  final List<String> users;
  final Function(String) onDelete;
  final Function(String) onEdit;
  final Function() onAdd;
  const CompetitionUserListTileWidget(
      {super.key,
      required this.users,
      required this.onDelete,
      required this.onEdit,
      required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
      child: ExpansionTile(
        title: Text('Liste des utilisateurs',
            style: Theme.of(context).textTheme.titleMedium),
        children: [
          for (var user in users)
            Slidable(
              startActionPane: ActionPane(
                extentRatio: 0.2,
                motion: DrawerMotion(),
                children: [
                  SlidableAction(
                      onPressed: (context) => onDelete(user),
                      backgroundColor: Colors.red,
                      icon: Icons.delete),
                ],
              ),
              endActionPane: ActionPane(
                extentRatio: 0.2,
                motion: DrawerMotion(),
                children: [
                  SlidableAction(
                      onPressed: (context) => onEdit(user),
                      backgroundColor: Colors.blue,
                      icon: Icons.edit),
                ],
              ),
              child: ListTile(
                minVerticalPadding: 0,
                minTileHeight: 50,
                title: Text(user),
              ),
            ),
          Center(
            child:
                OutlinedButton(onPressed: onAdd, child: const Text('Ajouter')),
          )
        ],
      ),
    );
  }
}

class CompetitionParamettreListElementWidget extends StatelessWidget {
  final String label;
  final Widget child;

  const CompetitionParamettreListElementWidget(
      {super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            child,
          ],
        ),
      ),
    );
  }
}

class UserFormWidget extends StatefulWidget {
  final String? user;

  UserFormWidget({super.key, this.user});

  @override
  State<UserFormWidget> createState() => _UserFormWidgetState();
}

class _UserFormWidgetState extends State<UserFormWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.user ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Ajouter un utilisateur'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      insetPadding: const EdgeInsets.all(5),
      contentPadding: const EdgeInsets.all(5),
      children: [
        TextField(
          keyboardType: TextInputType.emailAddress,
          controller: controller,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              hintText: 'Entrez le nom de l\'utilisateur',
              border: InputBorder.none),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                minimumSize: Size(MediaQuery.of(context).size.width * .75, 50)),
            onPressed: () {
              Navigator.of(context).pop(controller.text);
            },
            child: const Text('Ajouter')),
      ],
    );
  }
}
