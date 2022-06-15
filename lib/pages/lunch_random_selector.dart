import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lunch_counselor/components/scheme_picker.dart';
import 'package:lunch_counselor/services/menu_service.dart';
import 'package:provider/provider.dart';

import '../modal/menu_model.dart';
import '../modal/provider_scheme.dart';
import 'main_page.dart';

class LunchRandomSelector extends StatefulWidget {
  final TitleChangeFunction titleChangeFunction;

  const LunchRandomSelector({Key? key, required this.titleChangeFunction})
      : super(key: key);

  @override
  State createState() => _RandomSelector();
}

class _RandomSelector extends State<LunchRandomSelector> {
  final _title = 'Lunch Counselor';

  String _selectedLunch = 'Lunch !';
  int? _currentSchemeId;

  @override
  void initState() {
    super.initState();
    _currentSchemeId = Provider
        .of<SchemeProvider>(context, listen: false).currentSchemeId;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.titleChangeFunction(_title);
    });
    return Stack(
      children: [
        InkWell(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedLunch,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            _weighedRandom().then((value) => {
              setState(() {
                _selectedLunch = value != null ? value.name : 'Error !';
              })
            });
          },
        ),
        Positioned(
          left: 16,
          top: 16,
          child: SchemePicker(
            onChanged: (value) {
              setState(() {
                _currentSchemeId = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Future<MenuModel?> _weighedRandom() async {
    double? sumWeight = await MenuService.sumTheWeight(_currentSchemeId);
    debugPrint('the total weight is $sumWeight');
    var random = Random(DateTime.now().millisecondsSinceEpoch);
    var nextDouble = random.nextDouble() * sumWeight!;
    debugPrint('random number is $nextDouble');
    List<MenuModel> menuList = await MenuService.listMenu(_currentSchemeId);
    double i = 0;
    for (var element in menuList) {
      i += element.weight;
      if (i > nextDouble) {
        return element;
      }
    }
    return null;
  }
}
