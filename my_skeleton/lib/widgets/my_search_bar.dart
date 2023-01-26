import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:my_skeleton/my_theme/theme/my_theme.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        decoration: MyTheme.of(context).myInputDecoration(
          context,
          searchController,
          hint: "Search",
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
