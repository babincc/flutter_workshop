import 'package:flutter_test/flutter_test.dart';
import 'package:n_dimensional_array/domain/models/nd_array.dart';

void main() {
  List testList = [
    // Dimension 1
    [
      // Dimension 2
      [
        // Dimension 3
        [
          // Dimension 4
          1, // [0][0][0][0]
          2, // [0][0][0][1]
        ],
        [
          3, // [0][0][1][1]
          4, // [0][0][1][1]
        ],
      ],
      // Dimension 2
      [
        // Dimension 3
        [
          4, // [0][1][0][0]
          3, // [0][1][0][1]
        ],
        [
          2, // [0][1][1][0]
          1, // [0][1][1][1]
        ],
      ],
    ],
    // Dimension 1
    [
      // Dimension 2
      [
        // Dimension 3
        [
          5, // [1][0][0][0]
          6, // [1][0][0][1]
        ],
        [
          7, // [1][0][1][0]
          8, // [1][0][1][1]
        ],
      ],
      // Dimension 2
      [
        // Dimension 3
        [
          8, // [1][1][0][0]
          7, // [1][1][0][1]
        ],
        [
          6, // [1][1][1][0]
          5, // [1][1][1][1]
        ],
      ],
    ],
    // Dimension 1
    [
      // Dimension 2
      [
        // Dimension 3
        [
          9, // [2][0][0][0]
          10, // [2][0][0][1]
        ],
        [
          11, // [2][0][1][0]
          12, // [2][0][1][1]
        ],
      ],
      // Dimension 2
      [
        // Dimension 3
        [
          12, // [2][1][0][0]
          11, // [2][1][0][1]
        ],
        [
          10, // [2][1][1][0]
          9, // [2][1][1][1]
        ],
      ],
    ],
    // Dimension 1
    [
      // Dimension 2
      [
        // Dimension 3
        [
          13, // [3][0][0][0]
          14, // [3][0][0][1]
        ],
        [
          15, // [3][0][1][0]
          16, // [3][0][1][1]
        ],
      ],
      // Dimension 2
      [
        // Dimension 3
        [
          16, // [3][1][0][0]
          15, // [3][1][0][1]
        ],
        [
          14, // [3][1][1][0]
          13, // [3][1][1][1]
        ],
      ],
    ],
  ];

  group(
    "Coordinate calibration",
    () {
      test(
        "Making sure everything is where it is supposed to be",
        () {
          NdArray ndArray = NdArray.fromList(testList);

          expect(ndArray[0][0][0][0], 1);
          expect(ndArray[0][0][0][1], 2);
          expect(ndArray[0][0][1][0], 3);
          expect(ndArray[0][0][1][1], 4);
          expect(ndArray[0][1][0][0], 4);
          expect(ndArray[0][1][0][1], 3);
          expect(ndArray[0][1][1][0], 2);
          expect(ndArray[0][1][1][1], 1);
          expect(ndArray[1][0][0][0], 5);
          expect(ndArray[1][0][0][1], 6);
          expect(ndArray[1][0][1][0], 7);
          expect(ndArray[1][0][1][1], 8);
          expect(ndArray[1][1][0][0], 8);
          expect(ndArray[1][1][0][1], 7);
          expect(ndArray[1][1][1][0], 6);
          expect(ndArray[1][1][1][1], 5);
          expect(ndArray[2][0][0][0], 9);
          expect(ndArray[2][0][0][1], 10);
          expect(ndArray[2][0][1][0], 11);
          expect(ndArray[2][0][1][1], 12);
          expect(ndArray[2][1][0][0], 12);
          expect(ndArray[2][1][0][1], 11);
          expect(ndArray[2][1][1][0], 10);
          expect(ndArray[2][1][1][1], 9);
          expect(ndArray[3][0][0][0], 13);
          expect(ndArray[3][0][0][1], 14);
          expect(ndArray[3][0][1][0], 15);
          expect(ndArray[3][0][1][1], 16);
          expect(ndArray[3][1][0][0], 16);
          expect(ndArray[3][1][0][1], 15);
          expect(ndArray[3][1][1][0], 14);
          expect(ndArray[3][1][1][1], 13);
        },
      );
    },
  );

  group(
    "==",
    () {
      test(
        "two arrays with the same data should be equal",
        () {
          NdArray ndArray1 = NdArray.fromList(testList);
          NdArray ndArray2 = NdArray(4);

          ndArray2.reshape([4, 2, 2, 2]);

          ndArray2[0][0][0][0] = 1;
          ndArray2[0][0][0][1] = 2;
          ndArray2[0][0][1][0] = 3;
          ndArray2[0][0][1][1] = 4;
          ndArray2[0][1][0][0] = 4;
          ndArray2[0][1][0][1] = 3;
          ndArray2[0][1][1][0] = 2;
          ndArray2[0][1][1][1] = 1;
          ndArray2[1][0][0][0] = 5;
          ndArray2[1][0][0][1] = 6;
          ndArray2[1][0][1][0] = 7;
          ndArray2[1][0][1][1] = 8;
          ndArray2[1][1][0][0] = 8;
          ndArray2[1][1][0][1] = 7;
          ndArray2[1][1][1][0] = 6;
          ndArray2[1][1][1][1] = 5;
          ndArray2[2][0][0][0] = 9;
          ndArray2[2][0][0][1] = 10;
          ndArray2[2][0][1][0] = 11;
          ndArray2[2][0][1][1] = 12;
          ndArray2[2][1][0][0] = 12;
          ndArray2[2][1][0][1] = 11;
          ndArray2[2][1][1][0] = 10;
          ndArray2[2][1][1][1] = 9;
          ndArray2[3][0][0][0] = 13;
          ndArray2[3][0][0][1] = 14;
          ndArray2[3][0][1][0] = 15;
          ndArray2[3][0][1][1] = 16;
          ndArray2[3][1][0][0] = 16;
          ndArray2[3][1][0][1] = 15;
          ndArray2[3][1][1][0] = 14;
          ndArray2[3][1][1][1] = 13;

          expect(ndArray1 == ndArray2, true);
        },
      );

      test(
        "two arrays with different data should not be equal",
        () {
          NdArray ndArray1 = NdArray.fromList(testList);
          NdArray ndArray2 = NdArray(4);

          ndArray2.reshape([4, 2, 2, 2]);

          ndArray2[0][0][0][0] = 1;
          ndArray2[0][0][0][1] = 2;
          ndArray2[0][0][1][0] = 3;
          ndArray2[0][0][1][1] = 4;
          ndArray2[0][1][0][0] = 4;
          ndArray2[0][1][0][1] = 3;
          ndArray2[0][1][1][0] = 2;
          ndArray2[0][1][1][1] = 1;
          ndArray2[1][0][0][0] = 5;
          ndArray2[1][0][0][1] = 6;
          ndArray2[1][0][1][0] = 7;
          ndArray2[1][0][1][1] = 8;
          ndArray2[1][1][0][0] = 8;
          ndArray2[1][1][0][1] = 7;
          ndArray2[1][1][1][0] = 6;
          ndArray2[1][1][1][1] = 5;
          ndArray2[2][0][0][0] = 9;
          ndArray2[2][0][0][1] = 11;
          ndArray2[2][0][1][0] = 11;
          ndArray2[2][0][1][1] = 12;
          ndArray2[2][1][0][0] = 12;
          ndArray2[2][1][0][1] = 11;
          ndArray2[2][1][1][0] = 10;
          ndArray2[2][1][1][1] = 9;
          ndArray2[3][0][0][0] = 13;
          ndArray2[3][0][0][1] = 14;
          ndArray2[3][0][1][0] = 15;
          ndArray2[3][0][1][1] = 16;
          ndArray2[3][1][0][0] = 16;
          ndArray2[3][1][0][1] = 15;
          ndArray2[3][1][1][0] = 14;
          ndArray2[3][1][1][1] = 13;

          expect(ndArray1 == ndArray2, false);
        },
      );

      test(
        "two arrays with the same data in a different order should not be "
        "equal",
        () {
          NdArray ndArray1 = NdArray.fromList(testList);
          NdArray ndArray2 = NdArray(4);

          ndArray2.reshape([4, 2, 2, 2]);

          ndArray2[0][0][0][0] = 2;
          ndArray2[0][0][0][1] = 1;
          ndArray2[0][0][1][0] = 3;
          ndArray2[0][0][1][1] = 4;
          ndArray2[0][1][0][0] = 4;
          ndArray2[0][1][0][1] = 3;
          ndArray2[0][1][1][0] = 2;
          ndArray2[0][1][1][1] = 1;
          ndArray2[1][0][0][0] = 5;
          ndArray2[1][0][0][1] = 6;
          ndArray2[1][0][1][0] = 7;
          ndArray2[1][0][1][1] = 8;
          ndArray2[1][1][0][0] = 8;
          ndArray2[1][1][0][1] = 7;
          ndArray2[1][1][1][0] = 6;
          ndArray2[1][1][1][1] = 5;
          ndArray2[2][0][0][0] = 9;
          ndArray2[2][0][0][1] = 10;
          ndArray2[2][0][1][0] = 11;
          ndArray2[2][0][1][1] = 12;
          ndArray2[2][1][0][0] = 12;
          ndArray2[2][1][0][1] = 11;
          ndArray2[2][1][1][0] = 10;
          ndArray2[2][1][1][1] = 9;
          ndArray2[3][0][0][0] = 13;
          ndArray2[3][0][0][1] = 14;
          ndArray2[3][0][1][0] = 15;
          ndArray2[3][0][1][1] = 16;
          ndArray2[3][1][0][0] = 16;
          ndArray2[3][1][0][1] = 15;
          ndArray2[3][1][1][0] = 14;
          ndArray2[3][1][1][1] = 13;

          expect(ndArray1 == ndArray2, false);
        },
      );
    },
  );

  group(
    "hashCode",
    () {
      test(
        "two arrays with the same data should have the same hash code",
        () {
          NdArray ndArray1 = NdArray.fromList(testList);
          NdArray ndArray2 = NdArray(4);

          ndArray2.reshape([4, 2, 2, 2]);

          ndArray2[0][0][0][0] = 1;
          ndArray2[0][0][0][1] = 2;
          ndArray2[0][0][1][0] = 3;
          ndArray2[0][0][1][1] = 4;
          ndArray2[0][1][0][0] = 4;
          ndArray2[0][1][0][1] = 3;
          ndArray2[0][1][1][0] = 2;
          ndArray2[0][1][1][1] = 1;
          ndArray2[1][0][0][0] = 5;
          ndArray2[1][0][0][1] = 6;
          ndArray2[1][0][1][0] = 7;
          ndArray2[1][0][1][1] = 8;
          ndArray2[1][1][0][0] = 8;
          ndArray2[1][1][0][1] = 7;
          ndArray2[1][1][1][0] = 6;
          ndArray2[1][1][1][1] = 5;
          ndArray2[2][0][0][0] = 9;
          ndArray2[2][0][0][1] = 10;
          ndArray2[2][0][1][0] = 11;
          ndArray2[2][0][1][1] = 12;
          ndArray2[2][1][0][0] = 12;
          ndArray2[2][1][0][1] = 11;
          ndArray2[2][1][1][0] = 10;
          ndArray2[2][1][1][1] = 9;
          ndArray2[3][0][0][0] = 13;
          ndArray2[3][0][0][1] = 14;
          ndArray2[3][0][1][0] = 15;
          ndArray2[3][0][1][1] = 16;
          ndArray2[3][1][0][0] = 16;
          ndArray2[3][1][0][1] = 15;
          ndArray2[3][1][1][0] = 14;
          ndArray2[3][1][1][1] = 13;

          expect(ndArray1.hashCode == ndArray2.hashCode, true);
        },
      );

      test(
        "two arrays with different data should have different hash codes",
        () {
          NdArray ndArray1 = NdArray.fromList(testList);
          NdArray ndArray2 = NdArray(4);

          ndArray2.reshape([4, 2, 2, 2]);

          ndArray2[0][0][0][0] = 1;
          ndArray2[0][0][0][1] = 2;
          ndArray2[0][0][1][0] = 3;
          ndArray2[0][0][1][1] = 4;
          ndArray2[0][1][0][0] = 4;
          ndArray2[0][1][0][1] = 3;
          ndArray2[0][1][1][0] = 2;
          ndArray2[0][1][1][1] = 1;
          ndArray2[1][0][0][0] = 5;
          ndArray2[1][0][0][1] = 6;
          ndArray2[1][0][1][0] = 7;
          ndArray2[1][0][1][1] = 8;
          ndArray2[1][1][0][0] = 8;
          ndArray2[1][1][0][1] = 7;
          ndArray2[1][1][1][0] = 6;
          ndArray2[1][1][1][1] = 5;
          ndArray2[2][0][0][0] = 9;
          ndArray2[2][0][0][1] = 11;
          ndArray2[2][0][1][0] = 11;
          ndArray2[2][0][1][1] = 12;
          ndArray2[2][1][0][0] = 12;
          ndArray2[2][1][0][1] = 11;
          ndArray2[2][1][1][0] = 10;
          ndArray2[2][1][1][1] = 9;
          ndArray2[3][0][0][0] = 13;
          ndArray2[3][0][0][1] = 14;
          ndArray2[3][0][1][0] = 15;
          ndArray2[3][0][1][1] = 16;
          ndArray2[3][1][0][0] = 16;
          ndArray2[3][1][0][1] = 15;
          ndArray2[3][1][1][0] = 14;
          ndArray2[3][1][1][1] = 13;

          expect(ndArray1.hashCode == ndArray2.hashCode, false);
        },
      );

      test(
        "two arrays with the same data in a different order should have "
        "different hash codes",
        () {
          NdArray ndArray1 = NdArray.fromList(testList);
          NdArray ndArray2 = NdArray(4);

          ndArray2.reshape([4, 2, 2, 2]);

          ndArray2[0][0][0][0] = 2;
          ndArray2[0][0][0][1] = 1;
          ndArray2[0][0][1][0] = 3;
          ndArray2[0][0][1][1] = 4;
          ndArray2[0][1][0][0] = 4;
          ndArray2[0][1][0][1] = 3;
          ndArray2[0][1][1][0] = 2;
          ndArray2[0][1][1][1] = 1;
          ndArray2[1][0][0][0] = 5;
          ndArray2[1][0][0][1] = 6;
          ndArray2[1][0][1][0] = 7;
          ndArray2[1][0][1][1] = 8;
          ndArray2[1][1][0][0] = 8;
          ndArray2[1][1][0][1] = 7;
          ndArray2[1][1][1][0] = 6;
          ndArray2[1][1][1][1] = 5;
          ndArray2[2][0][0][0] = 9;
          ndArray2[2][0][0][1] = 10;
          ndArray2[2][0][1][0] = 11;
          ndArray2[2][0][1][1] = 12;
          ndArray2[2][1][0][0] = 12;
          ndArray2[2][1][0][1] = 11;
          ndArray2[2][1][1][0] = 10;
          ndArray2[2][1][1][1] = 9;
          ndArray2[3][0][0][0] = 13;
          ndArray2[3][0][0][1] = 14;
          ndArray2[3][0][1][0] = 15;
          ndArray2[3][0][1][1] = 16;
          ndArray2[3][1][0][0] = 16;
          ndArray2[3][1][0][1] = 15;
          ndArray2[3][1][1][0] = 14;
          ndArray2[3][1][1][1] = 13;

          expect(ndArray1.hashCode == ndArray2.hashCode, false);
        },
      );
    },
  );
}
