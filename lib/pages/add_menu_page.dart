import 'package:flutter/material.dart';
import 'package:lunch_counselor/modal/menu_model.dart';
import 'package:lunch_counselor/modal/provider_scheme.dart';
import 'package:lunch_counselor/modal/scheme_model.dart';
import 'package:lunch_counselor/services/menu_service.dart';
import 'package:lunch_counselor/services/scheme_service.dart';
import 'package:lunch_counselor/utils/common_utils.dart';
import 'package:provider/provider.dart';

class AddMenuPage extends StatefulWidget {
  const AddMenuPage({Key? key}) : super(key: key);

  @override
  State createState() => AddMenuPageState();
}

class AddMenuPageState extends State<AddMenuPage> {
  final _formKey = GlobalKey<FormState>();

  // render data
  List<SchemeModel> _schemeList = [];
  final Color inactiveBkColor = const Color(0x338cc0de);

  bool _weightValid = true;

  // form input
  late String _foodName;
  double _weight = 1.0;
  int? _selectedSchemeId;
  int? _selectedSchemeChip;
  late String _newSchemeName;
  late String _updatingSchemeName;

  @override
  void initState() {
    super.initState();
    _listAllScheme();
    _selectedSchemeId =
        Provider.of<SchemeProvider>(context, listen: false).currentSchemeId;
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
                    thumbColor: _weightValid
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                    label: _weight.toString(),
                    divisions: 20,
                    onChanged: (double newVal) {
                      setState(() {
                        _weight = newVal;
                        _weightValid = newVal >= 0.1;
                      });
                    }),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    ...List<Widget>.generate(_schemeList.length, (index) {
                      return InputChip(
                        checkmarkColor: Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: inactiveBkColor,
                        selectedColor: Theme.of(context).colorScheme.primary,
                        labelStyle: TextStyle(
                            color: _selectedSchemeChip == index
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.primary),
                        deleteIcon: const Icon(Icons.edit_note_outlined),
                        deleteIconColor: _selectedSchemeChip == index
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.primary,
                        onDeleted: _selectedSchemeChip == index
                            ? () {
                                _showSaveDialog(context, 'Update Scheme', () {
                                  _updateScheme(
                                      _updatingSchemeName, _selectedSchemeId!);
                                }, (value) {
                                  setState(() {
                                    _updatingSchemeName = value;
                                  });
                                }, (value) {
                                  _updateScheme(value, _selectedSchemeId!);
                                });
                              }
                            : null,
                        label: Text(
                          _schemeList[index].name,
                        ),
                        selected: _selectedSchemeChip == index,
                        onSelected: (select) {
                          setState(() {
                            _selectedSchemeChip = select ? index : null;
                            _selectedSchemeId =
                                select ? _schemeList[index].id : null;
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
                      backgroundColor: inactiveBkColor,
                      label: Text(
                        'Add Scheme',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      onPressed: () {
                        _showSaveDialog(context, 'New Scheme', () {
                          _saveScheme(_newSchemeName);
                        }, (value) {
                          setState(() {
                            _newSchemeName = value;
                          });
                        }, (value) {
                          _saveScheme(value);
                        }); // showDialog
                      },
                    ),
                  ],
                ),
              ].expand((element) => [
                    element,
                    const SizedBox(
                      height: 30,
                    )
                  ])
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.done),
        onPressed: () {
          var valid = _formKey.currentState!.validate();
          if (!valid) {
            return;
          }
          if (_weight <= 0) {
            CommonUtils.showSnackBar(context, 'The weight cannot be 0');
            return;
          }
          debugPrint('foodName: $_foodName, weight: ${_weight.toString()}');
          var menu = MenuModel(
              name: _foodName, weight: _weight, schemeId: _selectedSchemeId!);

          MenuService.insertMenu(menu).then((value) {
            debugPrint('insert successfully');
            Navigator.pop(context, _foodName);
          });
        },
      ),
    );
  }

  Future _showSaveDialog(
      BuildContext context,
      String title,
      VoidCallback onPressCallback,
      ValueChanged<String> onValueChange,
      ValueChanged<String> onFieldSubmitted) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title,),
            contentPadding: const EdgeInsets.all(16),
            content: TextFormField(
              autofocus: true,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Scheme Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                onValueChange(value);
              },
              onFieldSubmitted: (value) {
                onFieldSubmitted(value);
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  onPressCallback();
                },
                child: const Text(
                  'SAVE',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

  void _saveScheme(String value) {
    debugPrint('field submit $value');
    SchemeService.insertScheme(SchemeModel(name: value)).then((value) {
      Navigator.of(context).pop();
      _listAllScheme();
    });
  }

  void _updateScheme(String value, int id) {
    debugPrint('field submit $value');
    SchemeService.updateScheme(SchemeModel(name: value, id: id)).then((value) {
      Navigator.of(context).pop();
      _listAllScheme();
    });
  }

  _listAllScheme() {
    SchemeService.listScheme().then((value) {
      setState(() {
        _schemeList = value;
      });
    });
  }
}
