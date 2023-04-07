import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/entertainment/entertainment.dart';
import 'package:flutter_hue/domain/models/entertainment/entertainment_segment/entertainment_segment.dart';
import 'package:flutter_hue/domain/models/entertainment/entertainment_segment/entertainment_segment_capabilities.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Entertainment testEntertainment = Entertainment(
    type: ResourceType.entertainment,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    owner: Relative(
      type: ResourceType.device,
      id: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    ),
    isRenderer: false,
    isProxy: false,
    isEqualizer: false,
    maxStreams: 2,
    segmentCapabilities: EntertainmentSegmentCapabilities(
      isConfigurable: false,
      maxSegments: 5,
      segments: [
        EntertainmentSegment(
          start: 0,
          length: 3,
        ),
      ],
    ),
  );

  final Map<String, dynamic> testEntertainmentJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.type: ResourceType.entertainment.value,
    ApiFields.owner: {
      ApiFields.rType: ResourceType.device.value,
      ApiFields.rid: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    },
    ApiFields.isRenderer: false,
    ApiFields.isProxy: false,
    ApiFields.isEqualizer: false,
    ApiFields.maxStreams: 2,
    ApiFields.segments: {
      ApiFields.isConfigurable: false,
      ApiFields.maxSegments: 5,
      ApiFields.segments: [
        {
          ApiFields.start: 0,
          ApiFields.length: 3,
        },
      ],
    },
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            Entertainment.fromJson(testEntertainmentJson),
            testEntertainment,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            Entertainment.fromJson({ApiFields.data: testEntertainmentJson}),
            testEntertainment,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            Entertainment.fromJson({
              ApiFields.data: [testEntertainmentJson]
            }),
            testEntertainment,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            Entertainment.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testEntertainmentJson]
            }),
            testEntertainment,
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
          Entertainment copyEntertainment = testEntertainment.copyWith();

          expect(
            copyEntertainment.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testEntertainmentJson,
          );
        },
      );

      test(
        "with changes",
        () {
          Entertainment copyEntertainment = testEntertainment.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyEntertainmentJson =
              Map<String, dynamic>.from(testEntertainmentJson);

          copyEntertainmentJson[ApiFields.id] =
              "00000000-0000-0000-0000-000000000000";
          copyEntertainmentJson[ApiFields.idV1] =
              "/test/1234-5678-9012-3456-7890";

          expect(
            copyEntertainment.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyEntertainmentJson,
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
            testEntertainment.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testEntertainmentJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testEntertainment.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          Entertainment alteredEntertainment = testEntertainment.copyWith();
          alteredEntertainment.type = ResourceType.device;

          expect(
            alteredEntertainment.toJson(optimizeFor: OptimizeFor.put),
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
              testEntertainment.copyWith(id: "bad_value");
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
              testEntertainment.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );

      test(
        "invalid max streams assertion",
        () {
          expect(
            () {
              testEntertainment.copyWith(maxStreams: 0);
            },
            throwsAssertionError,
          );
        },
      );

      group(
        "segments",
        () {
          test(
            "invalid max segments assertion",
            () {
              expect(
                () {
                  testEntertainment.copyWith(
                    segmentCapabilities: EntertainmentSegmentCapabilities(
                      isConfigurable:
                          testEntertainment.segmentCapabilities.isConfigurable,
                      maxSegments: 0,
                      segments: testEntertainment.segmentCapabilities.segments,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid start assertion",
            () {
              expect(
                () {
                  testEntertainment.copyWith(
                    segmentCapabilities:
                        testEntertainment.segmentCapabilities.copyWith(
                      segments: [
                        EntertainmentSegment(
                          start: -1,
                          length: 3,
                        )
                      ],
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid length assertion",
            () {
              expect(
                () {
                  testEntertainment.copyWith(
                    segmentCapabilities:
                        testEntertainment.segmentCapabilities.copyWith(
                      segments: [
                        EntertainmentSegment(
                          start: 0,
                          length: 0,
                        )
                      ],
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );
        },
      );
    },
  );
}
