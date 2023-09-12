import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../helpers/app_constants.dart';
import '../model/weight_entry_model.dart';
import '../view_model/weight_view_model.dart';
import 'widgets/weight_entry_dialog_widget.dart';

class WeightEntryList extends StatelessWidget {
  const WeightEntryList({super.key});

  @override
  Widget build(BuildContext context) {
    WeightViewModel wightViewModel = Provider.of<WeightViewModel>(context);

    return StreamBuilder<List<WeightEntry>>(
      stream: wightViewModel.getWeightEntriesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(AppConstants.emptylistMessage),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${AppConstants.error} ${snapshot.error}');
        } else {
          return listSection(snapshot.data, wightViewModel);
        }
      },
    );
  }

  Widget listSection(
      List<WeightEntry>? weightEntries, WeightViewModel wightViewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: weightEntries!.length,
        itemBuilder: (context, index) {
          return listTitleView(weightEntries[index], context, wightViewModel);
        },
      ),
    );
  }

  Widget listTitleView(
      WeightEntry entry, BuildContext context, WeightViewModel wightViewModel) {
    return ListTile(
      title: Text('${entry.weight} ${AppConstants.weightUnit}'),
      subtitle: Text(
        '${AppConstants.date} ${DateFormat(AppConstants.dateTimeFormat).format(entry.timestamp)}',
      ),
      trailing: editDeleteView(entry, context, wightViewModel),
    );
  }

  Widget editDeleteView(
      WeightEntry entry, BuildContext context, WeightViewModel wightViewModel) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) {
                TextEditingController textEditingController =
                    TextEditingController(text: entry.weight.toString());
                return WeightEntryDialogWidget(
                  title: AppConstants.addWeight,
                  weightController: textEditingController,
                  actionBtnText: AppConstants.saveBtnTxt,
                  actionBtnOnClick: () {
                    wightViewModel.updateWeightEntry(
                        entry.id, double.parse(textEditingController.text));
                  },
                );
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            await wightViewModel.deleteWeightEntry(entry.id);
          },
        ),
      ],
    );
  }

  Widget alerDialogView(
      WeightEntry entry,
      BuildContext context,
      WeightViewModel wightViewModel,
      TextEditingController textEditingController) {
    return AlertDialog(
      title: const Text(AppConstants.editWeight),
      content: WeightEntryDialogWidget(
        title: AppConstants.editWeight,
        weightController: textEditingController,
        actionBtnText: AppConstants.saveBtnTxt,
        actionBtnOnClick: () {
          wightViewModel.updateWeightEntry(
              entry.id, double.parse(textEditingController.text));
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(AppConstants.cancelBtnTxt),
        ),
        TextButton(
          onPressed: () async {
            wightViewModel.updateWeightEntry(
                entry.id, double.parse(textEditingController.text));
            Navigator.of(context).pop();
          },
          child: const Text(AppConstants.saveBtnTxt),
        ),
      ],
    );
  }
}
