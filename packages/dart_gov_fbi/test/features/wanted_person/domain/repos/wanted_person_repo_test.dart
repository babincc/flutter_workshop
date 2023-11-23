import 'dart:math';

import 'package:dart_gov_fbi/dart_gov_fbi.dart';
import 'package:test/test.dart';

void main() {
  // This can't be tested since CloudFlare blocks your IP address for a few
  // minutes if you make too many requests too quickly.
  // test(
  //   'fetchAllWantedPersons',
  //   () async {
  //     final int total = (await fetchWantedPersons()).total ?? -1;
  //     final List<WantedPerson> result = await fetchAllWantedPersons();

  //     expect(
  //       result.length,
  //       total,
  //     );
  //   },
  // );

  group(
    'fetchWantedPersons',
    () {
      test(
        'allDefaults',
        () async {
          final WantedPersonResultSet result = await fetchWantedPersons();

          expect(
            result.isNotEmpty &&
                result.wantedPersons != null &&
                result.wantedPersons!.length == 50,
            true,
          );
        },
      );

      test(
        'negative page size',
        () async {
          final WantedPersonResultSet result =
              await fetchWantedPersons(pageSize: -50);

          expect(
            result.isNotEmpty &&
                result.wantedPersons != null &&
                result.wantedPersons!.length == 1,
            true,
          );
        },
      );

      test(
        'page size == 0',
        () async {
          final WantedPersonResultSet result =
              await fetchWantedPersons(pageSize: 0);

          expect(
            result.isNotEmpty &&
                result.wantedPersons != null &&
                result.wantedPersons!.length == 1,
            true,
          );
        },
      );

      test(
        'page size == 1',
        () async {
          final WantedPersonResultSet result =
              await fetchWantedPersons(pageSize: 1);

          expect(
            result.isNotEmpty &&
                result.wantedPersons != null &&
                result.wantedPersons!.length == 1,
            true,
          );
        },
      );

      test(
        'random page size',
        () async {
          final int pageSize = Random().nextInt((49 + 1) - 2) + 2;

          final WantedPersonResultSet result =
              await fetchWantedPersons(pageSize: pageSize);

          expect(
            result.isNotEmpty &&
                result.wantedPersons != null &&
                result.wantedPersons!.length == pageSize,
            true,
          );
        },
      );

      test(
        'random page',
        () async {
          final WantedPersonResultSet result = await fetchWantedPersons(
              page: Random().nextInt((15 + 1) - 2) + 2);

          expect(
            result.isNotEmpty &&
                result.wantedPersons != null &&
                result.wantedPersons!.length == 50,
            true,
          );
        },
      );

      test(
        'random page size & random page',
        () async {
          final int pageSize = Random().nextInt((49 + 1) - 2) + 2;

          final WantedPersonResultSet result = await fetchWantedPersons(
            pageSize: pageSize,
            page: Random().nextInt((15 + 1) - 2) + 2,
          );

          expect(
            result.isNotEmpty &&
                result.wantedPersons != null &&
                result.wantedPersons!.length == pageSize,
            true,
          );
        },
      );
    },
  );

  group(
    'fetchWantedPerson',
    () {
      test(
        'id that exists',
        () async {
          final WantedPersonResultSet result = await fetchWantedPersons();

          final WantedPerson wantedPerson = result.wantedPersons!.first;

          final WantedPerson wantedPerson2 =
              await fetchWantedPerson(wantedPerson.id!);

          expect(
            wantedPerson == wantedPerson2,
            true,
          );
        },
      );

      test(
        'non-existent id',
        () async {
          final WantedPerson result = await fetchWantedPerson('MadeUpId123');

          expect(
            result.isEmpty,
            true,
          );
        },
      );
    },
  );
}
