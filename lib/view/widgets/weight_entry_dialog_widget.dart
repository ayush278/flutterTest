import 'package:flutter/material.dart';

import '../../helpers/app_constants.dart';

class WeightEntryDialogWidget extends StatelessWidget {
  final String title;

  final TextEditingController weightController;
  final String actionBtnText;
  final Function actionBtnOnClick;
  const WeightEntryDialogWidget(
      {super.key,
      required this.title,
      required this.weightController,
      required this.actionBtnText,
      required this.actionBtnOnClick});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: textEntryWidget(weightController),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(AppConstants.cancelBtnTxt),
        ),
        TextButton(
          onPressed: () async {
            actionBtnOnClick();
            Navigator.of(context).pop();
          },
          child: Text(actionBtnText),
        ),
      ],
    );
  }

  Widget textEntryWidget(TextEditingController weightController) {
    return TextFormField(
      controller: weightController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: AppConstants.weightLabelTxt),
    );
  }
}
