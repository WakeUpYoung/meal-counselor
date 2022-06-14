import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lunch_counselor/pages/lunch_menu.dart';
import 'package:lunch_counselor/pages/lunch_random_selector.dart';

typedef TitleChangeFunction = void Function(String text);

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State createState() => MainPageState();

}

class MainPageState extends State<MainPage> {

  String _titleBarText = 'A Title';
  setTitleBar(newTitle) {
    setState(() {
      _titleBarText = newTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titleBarText),
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.secondary,
            tabs: const <Widget>[
              Tab(
                icon: Icon(Icons.flash_on),
              ),
              Tab(
                icon: Icon(Icons.assignment),
              ),

            ],
          ),
        ),
        body: TabBarView(
          children: [
            LunchRandomSelector(
              titleChangeFunction: setTitleBar,
            ),
            LunchMenu(
              titleChangeFunction: setTitleBar,
            )
          ],
        ),
      ),
    );
  }

}

