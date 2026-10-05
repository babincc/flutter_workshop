import 'package:flutter/material.dart';
import 'package:my_skeleton/domain/models/my_user.dart';
import 'package:my_skeleton/domain/repos/my_user_repo.dart';
import 'package:my_skeleton/utils/my_validator.dart';
import 'package:my_skeleton/widgets/views/my_text_field.dart';

class ProfilePersonalInfoFormViewModel {
  ProfilePersonalInfoFormViewModel({required this.user}) {
    _init();
  }

  final MyUser user;

  bool readOnly = true;

  void _init() {
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
  }

  // =========================== FORM ELEMENTS =================================

  // ----------------------------- FORM KEYS -----------------------------------

  final GlobalKey<MyTextFieldState> firstNameKey = GlobalKey();

  final GlobalKey<MyTextFieldState> lastNameKey = GlobalKey();

  // ------------------------- FORM CONTROLLERS --------------------------------

  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  // -------------------------- FORM VALIDATORS --------------------------------

  final List<MyTextFieldValidator> firstNameValidators = [
    MyTextFieldValidator(
      test: (value) => value.isEmpty || MyValidator.isValidName(value),
      expected: true,
      errorText: 'Invalid name',
    ),
  ];

  final List<MyTextFieldValidator> lastNameValidators = [
    MyTextFieldValidator(
      test: (value) => value.isEmpty || MyValidator.isValidName(value),
      expected: true,
      errorText: 'Invalid name',
    ),
  ];

  // --------------------------- FORM GETTERS ----------------------------------

  /// The first name text.
  String get firstName => firstNameController.text.trim();

  /// The last name text.
  String get lastName => lastNameController.text.trim();

  // ======================== END FORM ELEMENTS ================================

  /// Whether or not the user has input any data into the form.
  bool get hasData {
    final bool hasFirstNameData = firstName != user.firstName;

    final bool hasLastNameData = lastName != user.lastName;

    return hasFirstNameData || hasLastNameData;
  }

  /// Clears the form and all error messages.
  void clearForm() {
    // Clear all text fields.
    firstNameController.clear();
    lastNameController.clear();

    // Clear all error messages.
    MyTextField.setErrorText(key: firstNameKey, errorText: null);
    MyTextField.setErrorText(key: lastNameKey, errorText: null);

    _init();
  }

  /// Called when the user hits the submit button for the form.
  ///
  /// This method will validate the form, and if there are no errors, it will
  /// submit the form. If there are errors, they will be displayed, and the form
  /// will not be submitted.
  ///
  /// Returns `true` if the data was submitted to the database successfully. If
  /// there is a failure to properly add this data to the database, `false` is
  /// returned instead. If the form has input errors, an `null` is returned.
  Future<bool?> onSubmit() async {
    if (await hasErrors()) return null;

    final MyUser tempUser = user.copyWith(
      firstName: firstName,
      lastName: lastName,
    );

    final bool wasSuccessful = await MyUserRepo.updateUser(tempUser);

    // Only update the user object if the user successfully updated in the
    // database.
    if (wasSuccessful) {
      user.firstName = firstName;
      user.lastName = lastName;
    }

    return wasSuccessful;
  }

  /// Whether or not the form has errors.
  ///
  /// If `displayErrorMsg` is `true`, then error messages will be displayed, if
  /// there are any.
  Future<bool> hasErrors([bool displayErrorMsg = true]) async {
    bool firstNameHasErrors = false;
    if (firstNameKey.currentState != null &&
        firstNameKey.currentState!.mounted) {
      firstNameHasErrors = await firstNameKey.currentState!.hasErrors(
        displayErrorMsg: displayErrorMsg,
      );
    }

    bool lastNameHasErrors = false;
    if (lastNameKey.currentState != null && lastNameKey.currentState!.mounted) {
      lastNameHasErrors = await lastNameKey.currentState!.hasErrors(
        displayErrorMsg: displayErrorMsg,
      );
    }

    return firstNameHasErrors || lastNameHasErrors;
  }

  /// Properly dispose this view model.
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
  }
}
