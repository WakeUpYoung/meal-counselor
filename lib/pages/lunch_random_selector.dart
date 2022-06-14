import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lunch_counselor/services/menu_service.dart';

import '../modal/menu_modal.dart';
import 'main_page.dart';

class LunchRandomSelector extends StatefulWidget {

  final TitleChangeFunction titleChangeFunction;

  const LunchRandomSelector({Key? key, required this.titleChangeFunction}) : super(key: key);

  @override
  State createState() => _RandomSelector();

}

class _RandomSelector extends State<LunchRandomSelector> {
  final _title = 'Lunch Counselor';

  String _selectedLunch = 'Selector';

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.titleChangeFunction(_title);
    });
    return InkWell(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_selectedLunch,
                style: Theme.of(context).textTheme.displayMedium,),
            ],
          ),
        ),
      ),
      onTap: () {
        _weighedRandom()
            .then((value) => {
              setState((){
                _selectedLunch = value != null ?
                  value.name : 'Error !';
              })
        });
      },
    );
  }

  Future<MenuModal?> _weighedRandom() async {
    double? sumWeight = await MenuService.sumTheWeight();
    debugPrint('the total weight is $sumWeight');
    var random = Random(DateTime.now().millisecondsSinceEpoch);
    var nextDouble = random.nextDouble() * sumWeight!;
    debugPrint('random number is $nextDouble');
    List<MenuModal> menuList = await MenuService.listMenu();
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