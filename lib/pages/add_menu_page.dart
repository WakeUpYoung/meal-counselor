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

  bool _weightValid = true;

  // form input
  late String _foodName;
  double _weight = 1.0;
  int? _selectedSchemeId;
  int? _selectedSchemeChip;
  late String _newSchemeName;

  @override
  void initState() {
    super.initState();
    _listAllScheme();
    _selectedSchemeId = Provider.of<SchemeProvider>(context, listen: false).currentSchemeId;
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
                    thumbColor: _weightValid ? Theme.of(context).colorScheme.primary :
                      Theme.of(context).colorScheme.error,
                    label: _weight.toString(),
                    divisions: 20,
                    onChanged: (double newVal) {
                      setState(() {
                        _weight = newVal;
                        _weightValid = newVal >= 0.1;
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
                        avatar: _selectedSchemeChip == index ? CircleAvatar(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            child: const Icon(Icons.done),
                        ) : null,
                        selectedColor: Theme.of(context).colorScheme.primary,
                        labelStyle: TextStyle(
                          color: _selectedSchemeChip == index ?
                          Theme.of(context).colorScheme.onPrimary :
                          Theme.of(context).colorScheme.primary
                        ),
                        label: Text(_schemeList[index].name,),
                        selected: _selectedSchemeChip == index,
                        onSelected: (select) {
                          setState(() {
                            _selectedSchemeChip = select ? index : null;
                            _selectedSchemeId = select ? _schemeList[index].id : null;
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
                      label: const Text('Add Scheme',),
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
                                onChanged: (value) {
                                  _newSchemeName = value;
                                },

                                onFieldSubmitted: (value) {
                                  _saveScheme(value);
                                },
                              ),
                            actions: [
                              TextButton(onPressed: () {
                                _saveScheme(_newSchemeName);
                              },
                              child: const Text('SAVE',
                                style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
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
          if (_weight <= 0) {
            CommonUtils.showSnackBar(context, 'The weight cannot be 0');
            return;
          }
          debugPrint('foodName: $_foodName, weight: ${_weight.toString()}');
          var menu = MenuModel(
              name: _foodName,
              weight: _weight,
              schemeId: _selectedSchemeId!);

          MenuService.insertMenu(menu)
              .then((value) {
                debugPrint('insert successfully');
                Navigator.pop(context, _foodName);
          });
        },
      ),
    );
  }

  void _saveScheme(String value) {
    debugPrint('field submit $value');
    SchemeService.insertScheme(
        SchemeModel(name: value)
    ).then((value) {
      Navigator.of(context).pop();
      _listAllScheme();
    });
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