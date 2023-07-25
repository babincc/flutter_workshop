import 'package:flutter_test/flutter_test.dart';
import 'package:n_dimensional_array/utils/list_tools.dart';

void main() {
  group(
    "countDimensions",
    () {
      test(
        "returns 1 for a 1D list",
        () {
          final list = [1, 2, 3];

          expect(ListTools.countDimensions(list), 1);
        },
      );

      test(
        "returns 2 for a 2D list",
        () {
          final list = [
            [1, 2],
            [3, 4],
          ];

          expect(ListTools.countDimensions(list), 2);
        },
      );

      test(
        "returns 3 for a 3D list",
        () {
          final list = [
            [
              [1, 2],
              [3, 4],
            ],
            [
              [5, 6],
              [7, 8],
            ],
          ];

          expect(ListTools.countDimensions(list), 3);
        },
      );

      test(
        "returns 4 for a 4D list",
        () {
          final list = [
            [
              [
                [1, 2],
                [3, 4],
              ],
              [
                [5, 6],
                [7, 8],
              ],
            ],
            [
              [
                [9, 10],
                [11, 12],
              ],
              [
                [13, 14],
                [15, 16],
              ],
            ],
          ];

          expect(ListTools.countDimensions(list), 4);
        },
      );
    },
  );

  group(
    "getShape",
    () {
      test(
        "1D list",
        () {
          final list = [1, 2, 3];

          expect(ListTools.getShape(list), [3]);
        },
      );

      test(
        "2D list",
        () {
          final list = [
            [1, 2],
            [3, 4],
          ];

          expect(ListTools.getShape(list), [2, 2]);
        },
      );

      test(
        "3D list",
        () {
          final list = [
            [
              [1, 2],
              [3, 4],
            ],
          ];

          expect(ListTools.getShape(list), [1, 2, 2]);
        },
      );

      test(
        "4D list",
        () {
          final list = [
            [
              [
                [1, 2],
                [3, 4],
              ],
              [
                [5, 6],
                [7, 8],
              ],
            ],
            [
              [
                [9, 10],
                [11, 12],
              ],
              [
                [13, 14],
                [15, 16],
              ],
            ],
          ];

          expect(ListTools.getShape(list), [2, 2, 2, 2]);
        },
      );
    },
  );
}
