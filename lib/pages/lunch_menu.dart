import 'package:flutter/material.dart';
import 'package:lunch_counselor/components/scheme_picker.dart';
import 'package:lunch_counselor/modal/menu_model.dart';
import 'package:lunch_counselor/modal/provider_scheme.dart';
import 'package:lunch_counselor/pages/add_menu_page.dart';
import 'package:lunch_counselor/services/menu_service.dart';
import 'package:lunch_counselor/utils/common_utils.dart';
import 'package:provider/provider.dart';
import 'main_page.dart';

class LunchMenu extends StatefulWidget {
  final TitleChangeFunction titleChangeFunction;

  const LunchMenu({Key? key, required this.titleChangeFunction})
      : super(key: key);

  @override
  State createState() => _LunchMenuState();
}

class _LunchMenuState extends State<LunchMenu> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  List<MenuModel> _menuList = [];
  int? _currentSchemeId;

  @override
  void initState() {
    super.initState();
    _currentSchemeId = Provider
        .of<SchemeProvider>(context, listen: false).currentSchemeId;
    _refreshList(_currentSchemeId);
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
          return _refreshList(_currentSchemeId);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: SchemePicker(
                onChanged: (value) {
                  setState(() {
                    _currentSchemeId = value;
                  });
                  _refreshIndicatorKey.currentState?.show();
                  _refreshList(_currentSchemeId);
                },
              ),
            ),
            Expanded(
                child: ListView.separated(
                  itemCount: _menuList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                        foregroundColor: Theme
                            .of(context)
                            .colorScheme
                            .onPrimary,
                        child: Text(
                          _menuList[index]
                              .name
                              .characters
                              .characterAt(0)
                              .toString()
                              .toUpperCase(),
                        ),
                      ),
                      title: Text(
                        _menuList[index].name,
                      ),
                      onLongPress: () {
                        MenuService.deleteMenu(_menuList[index].id!).then((
                            effectRow) {
                          if (effectRow == 1) {
                            _refreshIndicatorKey.currentState?.show();
                            _refreshList(_currentSchemeId);
                            CommonUtils.showSnackBar(context, 'Menu deleted');
                          }
                        });
                      },
                      dense: false,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _navigateToAdd(context);
        },
      ),
    );
  }

  Future<void> _navigateToAdd(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AddMenuPage()));
    CommonUtils.showSnackBar(
        context, result != null ? 'Added $result' : 'Cancel add');
    debugPrint('Added $result');
    _refreshIndicatorKey.currentState?.show();
    _refreshList(_currentSchemeId);
  }


  void _refreshList(int? schemeId) {
    MenuService.listMenu(schemeId).then((value) =>
    {
      setState(() {
        _menuList = value;
      })
    });
  }
}
