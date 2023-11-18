import 'dart:math';

import 'package:dart_gov_fbi/dart_gov_fbi.dart';
import 'package:test/test.dart';

void main() {
  // This can't be tested since CloudFlare blocks your IP address for a few
  // minutes if you make too many requests too quickly.
  // test(
  //   'fetchAllArtCrimes',
  //   () async {
  //     final int total = (await fetchArtCrimes()).total ?? -1;
  //     final List<ArtCrime> result = await fetchAllArtCrimes();

  //     expect(
  //       result.length,
  //       total,
  //     );
  //   },
  // );

  group(
    'fetchArtCrimes',
    () {
      test(
        'allDefaults',
        () async {
          final ArtCrimeResultSet result = await fetchArtCrimes();

          expect(
            result.isNotEmpty &&
                result.artCrimes != null &&
                result.artCrimes!.length == 50,
            true,
          );
        },
      );

      test(
        'negative page size',
        () async {
          final ArtCrimeResultSet result = await fetchArtCrimes(pageSize: -50);

          expect(
            result.isNotEmpty &&
                result.artCrimes != null &&
                result.artCrimes!.length == 1,
            true,
          );
        },
      );

      test(
        'page size == 0',
        () async {
          final ArtCrimeResultSet result = await fetchArtCrimes(pageSize: 0);

          expect(
            result.isNotEmpty &&
                result.artCrimes != null &&
                result.artCrimes!.length == 1,
            true,
          );
        },
      );

      test(
        'page size == 1',
        () async {
          final ArtCrimeResultSet result = await fetchArtCrimes(pageSize: 1);

          expect(
            result.isNotEmpty &&
                result.artCrimes != null &&
                result.artCrimes!.length == 1,
            true,
          );
        },
      );

      test(
        'random page size',
        () async {
          final int pageSize = Random().nextInt((49 + 1) - 2) + 2;

          final ArtCrimeResultSet result =
              await fetchArtCrimes(pageSize: pageSize);

          expect(
            result.isNotEmpty &&
                result.artCrimes != null &&
                result.artCrimes!.length == pageSize,
            true,
          );
        },
      );

      test(
        'random page',
        () async {
          final ArtCrimeResultSet result =
              await fetchArtCrimes(page: Random().nextInt((15 + 1) - 2) + 2);

          expect(
            result.isNotEmpty &&
                result.artCrimes != null &&
                result.artCrimes!.length == 50,
            true,
          );
        },
      );

      test(
        'random page size & random page',
        () async {
          final int pageSize = Random().nextInt((49 + 1) - 2) + 2;

          final ArtCrimeResultSet result = await fetchArtCrimes(
            pageSize: pageSize,
            page: Random().nextInt((15 + 1) - 2) + 2,
          );

          expect(
            result.isNotEmpty &&
                result.artCrimes != null &&
                result.artCrimes!.length == pageSize,
            true,
          );
        },
      );
    },
  );

  group(
    'fetchArtCrime',
    () {
      test(
        'id that exists',
        () async {
          final ArtCrimeResultSet result = await fetchArtCrimes();

          final ArtCrime artCrime = result.artCrimes!.first;

          final ArtCrime artCrime2 = await fetchArtCrime(artCrime.id!);

          expect(
            artCrime == artCrime2,
            true,
          );
        },
      );

      test(
        'non-existent id',
        () async {
          final ArtCrime result = await fetchArtCrime('MadeUpId123');

          expect(
            result.isEmpty,
            true,
          );
        },
      );
    },
  );
}
