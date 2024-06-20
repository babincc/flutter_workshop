import 'package:flutter/material.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/features/form_example/screens/view_models/form_example_screen_view_model.dart';
import 'package:my_skeleton/widgets/views/my_alert.dart';
import 'package:my_skeleton/widgets/views/my_scaffold.dart';
import 'package:my_skeleton/widgets/views/my_text_field.dart';

class FormExampleScreen extends StatelessWidget {
  FormExampleScreen({super.key});

  final FormExampleScreenViewModel viewModel = FormExampleScreenViewModel();

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: const Text('Form Example'),
      ),
      builder: (context) => SingleChildScrollView(
        child: Column(
          children: [
            // FAVORITE COLOR
            MyTextField(
              key: viewModel.colorKey,
              controller: viewModel.colorController,
              validators: viewModel.colorValidators,
              hint: 'Favorite Color',
            ),

            const SizedBox(height: MyMeasurements.elementSpread),

            // FAVORITE SHAPE
            MyTextField(
              key: viewModel.shapeKey,
              controller: viewModel.shapeController,
              validators: viewModel.shapeValidators,
              hint: 'Favorite Shape',
            ),

            const SizedBox(height: MyMeasurements.elementSpread),

            // LUCKY NUMBER
            MyTextField(
              key: viewModel.luckyNumberKey,
              controller: viewModel.luckyNumberController,
              validators: viewModel.luckyNumberValidators,
              hint: 'Lucky Number',
              inputType: InputType.signedDecimal,
            ),

            const SizedBox(height: MyMeasurements.elementSpread),

            // EMAIL
            MyTextField(
              key: viewModel.emailKey,
              controller: viewModel.emailController,
              validators: viewModel.emailValidators,
              hint: 'Email',
              inputType: InputType.email,
              isLastField: true,
            ),

            const SizedBox(height: MyMeasurements.elementSpread),

            // SUBMIT BUTTON
            ElevatedButton(
              onPressed: () async {
                await viewModel.onSubmit().then(
                  (wasSuccessful) {
                    if (!wasSuccessful) return;

                    // DO SOMETHING
                  },
                );
              },
              child: const Text('Submit'),
            ),

            const SizedBox(height: MyMeasurements.elementSpread * 3.0),

            // CLEAR FORM BUTTON
            ElevatedButton(
              onPressed: () async {
                await MyAlert(
                  title: 'Clear Form',
                  content: 'Are you sure you want to clear the form?',
                  buttons: {
                    'Cancel': () {},
                    'Clear': viewModel.clearForm,
                  },
                ).show(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(154, 37, 29, 1.0),
              ),
              child: const Text('Clear Form'),
            ),
          ],
        ),
      ),
    );
  }
}
