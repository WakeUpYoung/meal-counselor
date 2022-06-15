import 'package:flutter/material.dart';
import 'package:lunch_counselor/modal/provider_scheme.dart';
import 'package:lunch_counselor/services/scheme_service.dart';
import 'package:provider/provider.dart';

import '../modal/scheme_model.dart';

class SchemePicker extends StatefulWidget {
  final ValueChanged<int>? onChanged;

  const SchemePicker({Key? key, this.onChanged}) : super(key: key);

  @override
  State createState() => _SchemePickerState();
}

class _SchemePickerState extends State<SchemePicker> {

  List<SchemeModel> _schemeList = [];

  @override
  void initState() {
    super.initState();
    refreshSchemeList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SchemeProvider>(
      builder: (context, model, child) {
        return Container(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          margin: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
          ),
          child: DropdownButton<int>(
            value: context.watch<SchemeProvider>().currentSchemeId,
            icon: const Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.white,
            ),
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(fontWeight: FontWeight.bold),
            underline: Container(
              color: Colors.transparent,
            ),
            dropdownColor: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
            items: _schemeList
                .map((e) => DropdownMenuItem(
                      value: e.id,
                      child: Text(
                        e.name,
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                context.read<SchemeProvider>().setCurrentSchemeId(value ?? 0);
              });
              if (widget.onChanged != null) {
                widget.onChanged!(value!);
              }
            },
          ),
        );
      },
    );
  }

  refreshSchemeList() async {
    List<SchemeModel> results = await SchemeService.listScheme();
    setState(() {
      _schemeList = results;
    });
  }
}
