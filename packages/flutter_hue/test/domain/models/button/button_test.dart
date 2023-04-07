import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/button/button.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Button testButton = Button(
    type: ResourceType.button,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    owner: Relative(
      type: ResourceType.device,
      id: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    ),
    controlId: 3,
    lastEvent: "short_release",
  );

  final Map<String, dynamic> testButtonJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.owner: {
      ApiFields.rType: ResourceType.device.value,
      ApiFields.rid: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    },
    ApiFields.type: ResourceType.button.value,
    ApiFields.metadata: {
      ApiFields.controlId: 3,
    },
    ApiFields.button: {
      ApiFields.lastEvent: "short_release",
    },
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            Button.fromJson(testButtonJson),
            testButton,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            Button.fromJson({ApiFields.data: testButtonJson}),
            testButton,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            Button.fromJson({
              ApiFields.data: [testButtonJson]
            }),
            testButton,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            Button.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testButtonJson]
            }),
            testButton,
          );
        },
      );
    },
  );

  group(
    "copyWith",
    () {
      test(
        "no change",
        () {
          Button copyButton = testButton.copyWith();

          expect(
            copyButton.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testButtonJson,
          );
        },
      );

      test(
        "with changes",
        () {
          Button copyButton = testButton.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyButtonJson =
              Map<String, dynamic>.from(testButtonJson);

          copyButtonJson[ApiFields.id] = "00000000-0000-0000-0000-000000000000";
          copyButtonJson[ApiFields.idV1] = "/test/1234-5678-9012-3456-7890";

          expect(
            copyButton.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyButtonJson,
          );
        },
      );
    },
  );

  group(
    "toJson",
    () {
      test(
        "don't optimize",
        () {
          expect(
            testButton.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testButtonJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testButton.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          Button alteredButton = testButton.copyWith();
          alteredButton.type = ResourceType.device;

          expect(
            alteredButton.toJson(optimizeFor: OptimizeFor.put),
            {
              ApiFields.type: ResourceType.device.value,
            },
          );
        },
      );
    },
  );

  group(
    "exceptions and assertions",
    () {
      test(
        "invalid id assertion",
        () {
          expect(
            () {
              testButton.copyWith(id: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );

      test(
        "invalid idV1 assertion",
        () {
          expect(
            () {
              testButton.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );

      test(
        "invalid control id (low) assertion",
        () {
          expect(
            () {
              testButton.copyWith(controlId: -14);
            },
            throwsAssertionError,
          );
        },
      );

      test(
        "invalid control id (high) assertion",
        () {
          expect(
            () {
              testButton.copyWith(controlId: 9);
            },
            throwsAssertionError,
          );
        },
      );
    },
  );
}
