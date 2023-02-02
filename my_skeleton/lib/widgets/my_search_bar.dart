import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:my_skeleton/constants/strings/strings.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/providers/my_string_provider.dart';
import 'package:my_skeleton/utils/my_tools.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// All of the strings on this page.
    final Strings strings = MyStringProvider.of(
      context,
      listen: true,
    ).strings;

    final TextEditingController searchController = TextEditingController();

    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: searchController,
        style: Theme.of(context).textTheme.bodyText2,
        onSubmitted: (text) {
          // TODO
        },
        onChanged: (String newText) {
          // TODO
        },
        decoration: MyThemeProvider.myInputDecoration(
          hint: MyTools.capitalizeFirstLetter(strings.search),
        ),
      ),
      suggestionsCallback: (String currentText) async {
        return await getSuggestions(currentText);
      },
      itemBuilder: (context, suggestion) {
        if (suggestion != null) {
          return suggestionListItem();
        } else {
          // ERROR: Did not pass the assertion "suggestion != null && suggestion
          // is String"!
          return Container();
        }
      },
      onSuggestionSelected: (suggestion) {
        onSuggestionSelected();
      },
      hideOnEmpty: true,
    );
  }

  /// This method sends back a list of suggestions to be displayed as auto-
  /// complete options for the user.
  FutureOr<Iterable> getSuggestions(String partialName) async {
    // TODO

    return [];
  }

  /// This method is called when the user selects a suggestion from the list of
  /// auto-complete options.
  void onSuggestionSelected() {
    // TODO
  }

  ListTile suggestionListItem() {
    // TODO

    return const ListTile(
      leading: Icon(Icons.person),
      title: Text("Placeholder"),
    );
  }
}
