import 'package:flutter_hue/domain/models/light/light_color/light_color_xy.dart';
import 'package:flutter_hue/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "isUnitInterval",
    () {
      test(
        "in range",
        () {
          expect(Validators.isUnitInterval(0), true);
          expect(Validators.isUnitInterval(0.0000001), true);
          expect(Validators.isUnitInterval(0.5), true);
          expect(Validators.isUnitInterval(0.9999999), true);
          expect(Validators.isUnitInterval(1), true);
        },
      );

      test(
        "out of range",
        () {
          expect(Validators.isUnitInterval(-1), false);
          expect(Validators.isUnitInterval(2), false);
          expect(Validators.isUnitInterval(1.1), false);
        },
      );

      test(
        "edge case constants",
        () {
          expect(Validators.isUnitInterval(double.nan), false);
          expect(Validators.isUnitInterval(double.infinity), false);
          expect(Validators.isUnitInterval(double.negativeInfinity), false);
        },
      );
    },
  );

  group(
    "isValidGradient",
    () {
      test(
        "null",
        () {
          expect(
            Validators.isValidGradient(null),
            true,
          );
        },
      );

      test(
        "empty",
        () {
          expect(
            Validators.isValidGradient(
              [],
            ),
            true,
          );
        },
      );

      test(
        "valid number of elements",
        () {
          expect(
            Validators.isValidGradient(
              [
                LightColorXy(x: 0.1, y: 0.2),
                LightColorXy(x: 0.3, y: 0.4),
              ],
            ),
            true,
          );

          expect(
            Validators.isValidGradient(
              [
                LightColorXy(x: 0.1, y: 0.2),
                LightColorXy(x: 0.3, y: 0.4),
                LightColorXy(x: 0.5, y: 0.6),
              ],
            ),
            true,
          );

          expect(
            Validators.isValidGradient(
              [
                LightColorXy(x: 0.1, y: 0.2),
                LightColorXy(x: 0.3, y: 0.4),
                LightColorXy(x: 0.5, y: 0.6),
                LightColorXy(x: 0.7, y: 0.8),
              ],
            ),
            true,
          );

          expect(
            Validators.isValidGradient(
              [
                LightColorXy(x: 0.1, y: 0.2),
                LightColorXy(x: 0.3, y: 0.4),
                LightColorXy(x: 0.5, y: 0.6),
                LightColorXy(x: 0.7, y: 0.8),
                LightColorXy(x: 0.9, y: 1.0),
              ],
            ),
            true,
          );
        },
      );

      test(
        "invalid number of elements (too few)",
        () {
          expect(
            Validators.isValidGradient(
              [LightColorXy(x: 0.1, y: 0.2)],
            ),
            false,
          );
        },
      );

      test(
        "invalid number of elements (too many)",
        () {
          expect(
            Validators.isValidGradient(
              [
                LightColorXy(x: 0.1, y: 0.2),
                LightColorXy(x: 0.3, y: 0.4),
                LightColorXy(x: 0.5, y: 0.6),
                LightColorXy(x: 0.7, y: 0.8),
                LightColorXy(x: 0.9, y: 1.0),
                LightColorXy(x: 0.11, y: 0.12),
              ],
            ),
            false,
          );
        },
      );
    },
  );

  group(
    "isValidGradientDraft",
    () {
      test(
        "null",
        () {
          expect(
            Validators.isValidGradientDraft(null),
            true,
          );
        },
      );

      test(
        "valid range of elements",
        () {
          expect(
            Validators.isValidGradientDraft(
              [],
            ),
            true,
          );

          expect(
            Validators.isValidGradientDraft(
              [LightColorXy(x: 0.1, y: 0.2)],
            ),
            true,
          );

          expect(
            Validators.isValidGradientDraft(
              [
                LightColorXy(x: 0.1, y: 0.2),
                LightColorXy(x: 0.3, y: 0.4),
              ],
            ),
            true,
          );

          expect(
            Validators.isValidGradientDraft(
              [
                LightColorXy(x: 0.1, y: 0.2),
                LightColorXy(x: 0.3, y: 0.4),
                LightColorXy(x: 0.5, y: 0.6),
              ],
            ),
            true,
          );

          expect(
            Validators.isValidGradientDraft(
              [
                LightColorXy(x: 0.1, y: 0.2),
                LightColorXy(x: 0.3, y: 0.4),
                LightColorXy(x: 0.5, y: 0.6),
                LightColorXy(x: 0.7, y: 0.8),
              ],
            ),
            true,
          );

          expect(
            Validators.isValidGradientDraft(
              [
                LightColorXy(x: 0.1, y: 0.2),
                LightColorXy(x: 0.3, y: 0.4),
                LightColorXy(x: 0.5, y: 0.6),
                LightColorXy(x: 0.7, y: 0.8),
                LightColorXy(x: 0.9, y: 1.0),
              ],
            ),
            true,
          );
        },
      );

      test(
        "invalid range of elements (too many)",
        () {
          expect(
            Validators.isValidGradientDraft(
              [
                LightColorXy(x: 0.1, y: 0.2),
                LightColorXy(x: 0.3, y: 0.4),
                LightColorXy(x: 0.5, y: 0.6),
                LightColorXy(x: 0.7, y: 0.8),
                LightColorXy(x: 0.9, y: 1.0),
                LightColorXy(x: 0.11, y: 0.12),
              ],
            ),
            false,
          );
        },
      );
    },
  );

  group(
    "isValidId",
    () {
      test(
        "valid id format",
        () {
          expect(
            Validators.isValidId("01234567-89ab-cdef-0123-456789abcdef"),
            true,
          );
        },
      );

      test(
        "invalid id format",
        () {
          expect(
            Validators.isValidId("0123456789ab-cdef-0123-456789abcdef"),
            false,
          );

          expect(
            Validators.isValidId("01234567-89ab-cdef-0123456789abcdef"),
            false,
          );

          expect(
            Validators.isValidId("01234567-89ab-cdef-0123-456789abcde"),
            false,
          );

          expect(
            Validators.isValidId("01234567-89ab-cdef-0123-456789abcdeg"),
            false,
          );
        },
      );
    },
  );

  group(
    "isValidIdV1",
    () {
      test(
        "valid idV1 format",
        () {
          expect(Validators.isValidIdV1("/path/123id"), true);

          expect(Validators.isValidIdV1(""), true);
        },
      );

      test(
        "invalid idV1 format",
        () {
          expect(Validators.isValidIdV1("/path/to/123_idV1"), false);

          expect(Validators.isValidIdV1("/path/to/-idV1"), false);

          expect(Validators.isValidIdV1("/path/to/idV1-with-very-long-name"),
              false);

          expect(Validators.isValidIdV1("/path/to/idV1"), false);

          expect(Validators.isValidIdV1("/path/to/"), false);
        },
      );
    },
  );

  group(
    "isValidIpAddress",
    () {
      test(
        "valid IP address format",
        () {
          expect(Validators.isValidIpAddress("192.168.1.1"), true);

          expect(Validators.isValidIpAddress("255.255.255.255"), true);

          expect(Validators.isValidIpAddress("10.0.0.1"), true);

          expect(Validators.isValidIpAddress("172.16.0.1"), true);
        },
      );

      test(
        "invalid IP address format",
        () {
          expect(Validators.isValidIpAddress("192.168.1.1.1"), false);

          expect(Validators.isValidIpAddress("192.168.1"), false);
        },
      );
    },
  );

  group(
    "isValidLatitude",
    () {
      test(
        "valid latitude values",
        () {
          expect(Validators.isValidLatitude(-90.0), true);
          expect(Validators.isValidLatitude(-45.0), true);
          expect(Validators.isValidLatitude(0.0), true);
          expect(Validators.isValidLatitude(45.0), true);
          expect(Validators.isValidLatitude(90.0), true);
        },
      );

      test(
        "invalid latitude values",
        () {
          expect(Validators.isValidLatitude(-91.0), false);
          expect(Validators.isValidLatitude(-100.0), false);
          expect(Validators.isValidLatitude(91.0), false);
          expect(Validators.isValidLatitude(100.0), false);
        },
      );
    },
  );

  group(
    "isValidLongitude",
    () {
      test(
        "valid longitude",
        () {
          expect(Validators.isValidLongitude(0), true);
          expect(Validators.isValidLongitude(-180), true);
          expect(Validators.isValidLongitude(180), true);
          expect(Validators.isValidLongitude(90), true);
          expect(Validators.isValidLongitude(-90), true);
        },
      );

      test(
        "invalid longitude",
        () {
          expect(Validators.isValidLongitude(-180.1), false);
          expect(Validators.isValidLongitude(180.1), false);
          expect(Validators.isValidLongitude(190), false);
          expect(Validators.isValidLongitude(-190), false);
        },
      );
    },
  );

  group(
    "isValidMacAddress",
    () {
      test(
        "valid mac address",
        () {
          expect(
            Validators.isValidMacAddress("00:11:22:33:44:55"),
            true,
          );
          expect(
            Validators.isValidMacAddress("00:11:22:33:44:55:66"),
            true,
          );
          expect(
            Validators.isValidMacAddress("00:11:22:33:44:55:66"),
            true,
          );
          expect(
            Validators.isValidMacAddress("00:a1:22:3b:4c:5d"),
            true,
          );
        },
      );

      test(
        "invalid mac address",
        () {
          expect(
            Validators.isValidMacAddress("001122334455"),
            false,
          );
          expect(
            Validators.isValidMacAddress("00:11:22:33:44:5Z"),
            false,
          );
          expect(
            Validators.isValidMacAddress("00:11:22:33:44:5"),
            false,
          );
          expect(
            Validators.isValidMacAddress("00:11:22:33:44:55:6a:"),
            false,
          );
          expect(
            Validators.isValidMacAddress("00:11:22:33:44:55:66:77:"),
            false,
          );
        },
      );
    },
  );

  group(
    "isValidMired",
    () {
      test(
        "valid mired",
        () {
          expect(Validators.isValidMired(153), true);
          expect(Validators.isValidMired(300), true);
          expect(Validators.isValidMired(500), true);
        },
      );

      test(
        "invalid mired",
        () {
          expect(Validators.isValidMired(152), false);
          expect(Validators.isValidMired(501), false);
          expect(Validators.isValidMired(1000), false);
          expect(Validators.isValidMired(-100), false);
        },
      );
    },
  );

  group(
    "isValidMirek",
    () {
      test(
        "valid mirek",
        () {
          expect(Validators.isValidMirek(153), true);
          expect(Validators.isValidMirek(300), true);
          expect(Validators.isValidMirek(500), true);
        },
      );

      test(
        "invalid mirek",
        () {
          expect(Validators.isValidMirek(152), false);
          expect(Validators.isValidMirek(501), false);
          expect(Validators.isValidMirek(1000), false);
          expect(Validators.isValidMirek(-100), false);
        },
      );
    },
  );

  group(
    "isValidName",
    () {
      test(
        "valid name length",
        () {
          expect(Validators.isValidName("a"), true);
          expect(Validators.isValidName("abcdefghijklmnopqrstuvwxyz"), true);
          expect(
              Validators.isValidName("12345678901234567890123456789012"), true);
        },
      );

      test(
        "invalid name length",
        () {
          expect(Validators.isValidName(""), false);
          expect(
            Validators.isValidName("abcdefghijklmnopqrstuvwxyz0123456789"),
            false,
          );
        },
      );
    },
  );

  group(
    "isValidPercentage",
    () {
      test(
        "valid percentage",
        () {
          expect(Validators.isValidPercentage(0), true);
          expect(Validators.isValidPercentage(50), true);
          expect(Validators.isValidPercentage(100), true);
        },
      );

      test(
        "invalid percentage",
        () {
          expect(Validators.isValidPercentage(-0.1), false);
          expect(Validators.isValidPercentage(100.1), false);
        },
      );
    },
  );

  group(
    "isValidScriptId",
    () {
      test(
        "valid script ID",
        () {
          expect(
            Validators.isValidScriptId("01234567-89ab-cdef-0123-456789abcdef"),
            true,
          );
          expect(
            Validators.isValidScriptId("ffffffff-ffff-ffff-ffff-ffffffffffff"),
            true,
          );
        },
      );

      test(
        "invalid script ID",
        () {
          expect(
            Validators.isValidScriptId("01234567-89ab-cdef-0123-456789abcdefg"),
            false,
          );
          expect(
            Validators.isValidScriptId("01234567-89ab-cdef-0123-456789abcde"),
            false,
          );
          expect(
            Validators.isValidScriptId("01234567-89ab-cdef-0123-456789abcdef "),
            false,
          );
          expect(
            Validators.isValidScriptId("01234567-89ab-cdef-0123-456789abcdeF"),
            false,
          );
          expect(
            Validators.isValidScriptId(" 01234567-89ab-cdef-0123-456789abcdef"),
            false,
          );
        },
      );
    },
  );

  group(
    "isValidScriptVersion",
    () {
      test(
        "valid script version",
        () {
          expect(Validators.isValidScriptVersion("1.0"), true);
          expect(Validators.isValidScriptVersion("12.345.678"), true);
          expect(Validators.isValidScriptVersion("9.012"), true);
        },
      );

      test(
        "invalid script version",
        () {
          expect(Validators.isValidScriptVersion(""), false);
          expect(Validators.isValidScriptVersion(".123"), false);
          expect(Validators.isValidScriptVersion("123."), false);
          expect(Validators.isValidScriptVersion("123"), false);
          expect(Validators.isValidScriptVersion("1.23.456.789"), false);
          expect(Validators.isValidScriptVersion("1.23a"), false);
          expect(Validators.isValidScriptVersion("1.2.3.4"), false);
        },
      );
    },
  );

  group(
    "isValidSoftwareVersion",
    () {
      test(
        "valid software version",
        () {
          expect(
            Validators.isValidSoftwareVersion("1.0.0"),
            true,
          );
          expect(
            Validators.isValidSoftwareVersion("11.22.333"),
            true,
          );
          expect(
            Validators.isValidSoftwareVersion("100.200.300"),
            true,
          );
        },
      );

      test(
        "invalid software version",
        () {
          expect(
            Validators.isValidSoftwareVersion(""),
            false,
          );
          expect(
            Validators.isValidSoftwareVersion("1"),
            false,
          );
          expect(
            Validators.isValidSoftwareVersion("1.0"),
            false,
          );
          expect(
            Validators.isValidSoftwareVersion("1.0."),
            false,
          );
          expect(
            Validators.isValidSoftwareVersion("1.0.0.0"),
            false,
          );
          expect(
            Validators.isValidSoftwareVersion("1.0.a"),
            false,
          );
          expect(
            Validators.isValidSoftwareVersion("a.b.c"),
            false,
          );
        },
      );
    },
  );

  group(
    "isValidValue",
    () {
      test(
        "value is in validValues list",
        () {
          expect(Validators.isValidValue(1, [1, 2, 3]), true);
          expect(Validators.isValidValue("hello", ["hello", "world"]), true);
          expect(Validators.isValidValue(true, [false, true]), true);
        },
      );

      test(
        "value is not in validValues list",
        () {
          expect(Validators.isValidValue(4, [1, 2, 3]), false);
          expect(Validators.isValidValue("goodbye", ["hello", "world"]), false);
          expect(Validators.isValidValue(false, [true]), false);
        },
      );

      test(
        "validValues list is empty and value is empty",
        () {
          expect(Validators.isValidValue("", []), true);
          expect(Validators.isValidValue([], []), true);
        },
      );

      test(
        "validValues list is empty and value is not empty",
        () {
          expect(Validators.isValidValue("hello", []), false);
          expect(Validators.isValidValue([1, 2, 3], []), false);
        },
      );

      test(
        "value is null",
        () {
          expect(Validators.isValidValue(null, []), false);
          expect(Validators.isValidValue(null, [1, 2, 3]), false);
          expect(Validators.isValidValue(null, ["hello", "world"]), false);
        },
      );
    },
  );
}
