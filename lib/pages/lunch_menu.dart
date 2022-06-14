import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lunch_counselor/modal/menu_modal.dart';
import 'package:lunch_counselor/pages/add_menu_page.dart';
import 'package:lunch_counselor/services/menu_service.dart';
import 'main_page.dart';


class LunchMenu extends StatefulWidget {

  final TitleChangeFunction titleChangeFunction;

  const LunchMenu({Key? key, required this.titleChangeFunction}) : super(key: key);

  @override
  State createState() => _LunchMenuState();
}

class _LunchMenuState extends State<LunchMenu> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  List<MenuModal> _data = [];

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.titleChangeFunction('Lunch Menu');
    });
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          return _refreshList();
        },
        child: ListView.separated(
          itemCount: _data.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                radius: Theme.of(context).textTheme.displayMedium!.fontSize,
                child: Text(_data[index].name.characters
                    .characterAt(0).toString().toUpperCase(),),
              ),
              title: Text(_data[index].name,
                style: Theme.of(context).textTheme.displayMedium,),
              onLongPress: () {
                MenuService.deleteMenu(_data[index].id!)
                    .then((effectRow) {
                      if (effectRow == 1) {
                        _refreshIndicatorKey.currentState?.show();
                        _refreshList();
                        _showSnackBar(context, 'Menu deleted');
                      }
                });
              },
              dense: true,
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        child: const Icon(Icons.add),
        onPressed: () {
          _navigateToAdd(context);
        },
      ),
    );

  }

  Future<void> _navigateToAdd(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddMenuPage())
    );
    _showSnackBar(context, result != null ? 'Added $result' : 'Cancel add');
    debugPrint('Added $result');
    _refreshIndicatorKey.currentState?.show();
    _refreshList();
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }
  
  void _refreshList() {
    MenuService.listMenu()
    .then((value) => {
      setState(() {
        _data = value;
      })
    });
  }

}