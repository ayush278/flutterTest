import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testflutter/helpers/app_constants.dart';
import 'package:testflutter/view/widgets/weight_entry_dialog_widget.dart';
import '../view_model/weight_view_model.dart';
import 'weight_entry_list.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final wightViewModel = Provider.of<WeightViewModel>(context);

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: AppBar(
          title: const Text(AppConstants.weightAppBarTxt),
          actions: [
            if (wightViewModel.user != null)
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: () async {
                  await wightViewModel.signOut();
                },
              ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: wightViewModel.isLoading
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                )
              : mainBodySection(wightViewModel),
        ),
        floatingActionButton: wightViewModel.user != null
            ? addWeightFloatinBtn(wightViewModel, context)
            : Container());
  }

  Widget mainBodySection(WeightViewModel wightViewModel) {
    return wightViewModel.user == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  wightViewModel.signInAnonymously();
                },
                child: const Text(AppConstants.signInBtnTxt),
              ),
            ],
          )
        : WeightEntryList();
  }

  Widget addWeightFloatinBtn(
      WeightViewModel wightViewModel, BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) {
            TextEditingController textEditingController =
                TextEditingController();
            return WeightEntryDialogWidget(
              title: AppConstants.addWeight,
              weightController: textEditingController,
              actionBtnText: AppConstants.addBtnTxt,
              actionBtnOnClick: () {
                wightViewModel
                    .addWeightEntry(double.parse(textEditingController.text));
              },
            );
          },
        );
      },
      elevation: 6.0, // Adjust elevation as needed
      backgroundColor: Colors.blue,
      icon: const Icon(Icons.add),
      label: const Text(AppConstants.addWeight),
    );
  }
}
