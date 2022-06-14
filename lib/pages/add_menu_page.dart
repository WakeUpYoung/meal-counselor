import 'package:flutter/material.dart';
import 'package:lunch_counselor/modal/menu_modal.dart';
import 'package:lunch_counselor/modal/scheme_modal.dart';
import 'package:lunch_counselor/services/menu_service.dart';
import 'package:lunch_counselor/services/scheme_service.dart';

class AddMenuPage extends StatefulWidget {

  const AddMenuPage({Key? key}) : super(key: key);

  @override
  State createState() => AddMenuPageState();

}

class AddMenuPageState extends State<AddMenuPage> {
  final _formKey = GlobalKey<FormState>();

  // render data
  List<SchemeModal> _schemeList = [];

  // form input
  late String _foodName;
  double _weight = 1.0;
  int? _selectedSchemeId;

  @override
  void initState() {
    super.initState();
    _listAllScheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Menu'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ...[
                TextFormField(
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a food name.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.insert_emoticon),
                    labelText: 'Food Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _foodName = value;
                  },
                ),
                Slider(
                    value: _weight,
                    max: 2,
                    label: _weight.toString(),
                    divisions: 20,
                    onChanged: (double newVal) {
                      setState(() {
                        _weight = newVal;
                      });
                    }
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    ...List<Widget>.generate(_schemeList.length,
                        (index) {
                      return ChoiceChip(
                        selectedColor: Theme.of(context).colorScheme.primary,
                        label: Text(_schemeList[index].name),
                        selected: _selectedSchemeId == index,
                        onSelected: (select) {
                          setState(() {
                            _selectedSchemeId = select ? index : null;
                          });
                        },
                      );
                    }),
                    InputChip(
                      avatar: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        child: const Icon(Icons.add),
                      ),
                      label: const Text('Add Scheme'),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                          return AlertDialog(
                            title: const Text('Add new Scheme'),
                            contentPadding: const EdgeInsets.all(16),
                            content:
                              TextFormField(
                                autofocus: true,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                  labelText: 'Scheme Name',
                                  border: OutlineInputBorder(),
                                ),

                                onFieldSubmitted: (value) {
                                  debugPrint('field submit $value');
                                  Navigator.pop(context);
                                },
                              ),
                            actions: [
                              TextButton(onPressed: () {

                              },
                              child: const Text('Save')),
                            ],
                          );
                        }
                        ); // showDialog
                      },
                    ),
                  ],
                ),
              ].expand((element) => [
                element,
                const SizedBox(height: 30,)
              ])
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        child: const Icon(Icons.done),
        onPressed: () {
          var valid = _formKey.currentState!.validate();
          if (!valid) {
            return;
          }
          debugPrint('foodName: $_foodName, weight: ${_weight.toString()}');
          var menu = MenuModal(
              name: _foodName,
              weight: _weight,
              schemeId: _selectedSchemeId != null ? _selectedSchemeId! : 1);

          MenuService.insertMenu(menu)
              .then((value) {
                debugPrint('insert successfully');
                Navigator.pop(context, _foodName);
          });
        },
      ),
    );
  }

  _listAllScheme() {
    SchemeService.listScheme()
        .then((value) {
          setState(() {
            _schemeList = value;
          });
    });
  }

}