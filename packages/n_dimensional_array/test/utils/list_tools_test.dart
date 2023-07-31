import 'package:n_dimensional_array/n_dimensional_array.dart';
import 'package:test/test.dart';

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
    "extractDimension",
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

      test(
        "extract first dimension",
        () {
          List<NdArray> actual =
              ListTools.extractDimension(dimension: 1, list: list);

          List<NdArray> expected = [
            NdArray.fromList([
              [
                [1, 2],
                [3, 4],
              ],
              [
                [5, 6],
                [7, 8],
              ],
            ]),
            NdArray.fromList([
              [
                [9, 10],
                [11, 12],
              ],
              [
                [13, 14],
                [15, 16],
              ],
            ]),
          ];

          expect(actual, expected);
        },
      );

      test(
        "extract second dimension",
        () {
          List<NdArray> actual =
              ListTools.extractDimension(dimension: 2, list: list);

          List<NdArray> expected = [
            NdArray.fromList([
              [1, 2],
              [3, 4],
            ]),
            NdArray.fromList([
              [5, 6],
              [7, 8],
            ]),
            NdArray.fromList([
              [9, 10],
              [11, 12],
            ]),
            NdArray.fromList([
              [13, 14],
              [15, 16],
            ]),
          ];

          expect(actual, expected);
        },
      );

      test(
        "extract third dimension",
        () {
          List<NdArray> actual =
              ListTools.extractDimension(dimension: 3, list: list);

          List<NdArray> expected = [
            NdArray.fromList([1, 2]),
            NdArray.fromList([3, 4]),
            NdArray.fromList([5, 6]),
            NdArray.fromList([7, 8]),
            NdArray.fromList([9, 10]),
            NdArray.fromList([11, 12]),
            NdArray.fromList([13, 14]),
            NdArray.fromList([15, 16]),
          ];

          expect(actual, expected);
        },
      );

      test(
        "extract fourth dimension",
        () {
          List<NdArray> actual =
              ListTools.extractDimension(dimension: 4, list: list);

          List<NdArray> expected = [
            NdArray.fromList([1]),
            NdArray.fromList([2]),
            NdArray.fromList([3]),
            NdArray.fromList([4]),
            NdArray.fromList([5]),
            NdArray.fromList([6]),
            NdArray.fromList([7]),
            NdArray.fromList([8]),
            NdArray.fromList([9]),
            NdArray.fromList([10]),
            NdArray.fromList([11]),
            NdArray.fromList([12]),
            NdArray.fromList([13]),
            NdArray.fromList([14]),
            NdArray.fromList([15]),
            NdArray.fromList([16]),
          ];

          expect(actual, expected);
        },
      );

      test(
        "extract fifth dimension",
        () {
          expect(
            () => ListTools.extractDimension(dimension: 5, list: list),
            throwsArgumentError,
          );
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
