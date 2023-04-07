import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/models/smart_scene/smart_scene.dart';
import 'package:flutter_hue/domain/models/smart_scene/smart_scene_active_timeslot.dart';
import 'package:flutter_hue/domain/models/smart_scene/smart_scene_metadata.dart';
import 'package:flutter_hue/domain/models/smart_scene/smart_scene_week/smart_scene_week.dart';
import 'package:flutter_hue/domain/models/smart_scene/smart_scene_week/smart_scene_week_start_time.dart';
import 'package:flutter_hue/domain/models/smart_scene/smart_scene_week/smart_scene_week_timeslot.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/exceptions/time_format_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final SmartScene testSmartScene = SmartScene(
    type: ResourceType.smartScene,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    metadata: SmartSceneMetadata(
      name: "Nighttime Noon",
      image: Relative(
        type: ResourceType.publicImage,
        id: "ffffffff-ffff-ffff-ffff-ffffffffffff",
      ),
    ),
    group: Relative(
      type: ResourceType.room,
      id: "00001111-2222-3333-4444-555566667777",
    ),
    weekTimeslots: [
      SmartSceneWeek(
        timeslots: [
          SmartSceneWeekTimeslot(
            startTime: SmartSceneWeekStartTime(
              kind: "time",
              hour: 12,
              minute: 0,
              second: 0,
            ),
            target: Relative(
              type: ResourceType.scene,
              id: "abababab-abab-abab-abab-abababababab",
            ),
          ),
        ],
        recurrence: [
          "monday",
          "tuesday",
          "wednesday",
          "thursday",
          "friday",
        ],
      ),
    ],
    activeTimeslot: SmartSceneActiveTimeslot.empty(),
    state: "active",
  );

  final Map<String, dynamic> testSmartSceneJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.type: ResourceType.smartScene.value,
    ApiFields.metadata: {
      ApiFields.name: "Nighttime Noon",
      ApiFields.image: {
        ApiFields.rid: "ffffffff-ffff-ffff-ffff-ffffffffffff",
        ApiFields.rType: ResourceType.publicImage.value,
      },
    },
    ApiFields.group: {
      ApiFields.rid: "00001111-2222-3333-4444-555566667777",
      ApiFields.rType: ResourceType.room.value,
    },
    ApiFields.weekTimeslots: [
      {
        ApiFields.timeslots: [
          {
            ApiFields.startTime: {
              ApiFields.kind: "time",
              ApiFields.time: {
                ApiFields.hour: 12,
                ApiFields.minute: 0,
                ApiFields.second: 0,
              },
            },
            ApiFields.target: {
              ApiFields.rid: "abababab-abab-abab-abab-abababababab",
              ApiFields.rType: ResourceType.scene.value,
            },
          },
        ],
        ApiFields.recurrence: [
          "monday",
          "tuesday",
          "wednesday",
          "thursday",
          "friday",
        ],
      },
    ],
    ApiFields.activeTimeslot: {
      ApiFields.timeslotId: 0,
      ApiFields.weekday: "",
    },
    ApiFields.state: "active",
    ApiFields.recall: {
      ApiFields.action: null,
    },
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            SmartScene.fromJson(testSmartSceneJson),
            testSmartScene,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            SmartScene.fromJson({ApiFields.data: testSmartSceneJson}),
            testSmartScene,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            SmartScene.fromJson({
              ApiFields.data: [testSmartSceneJson]
            }),
            testSmartScene,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            SmartScene.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testSmartSceneJson]
            }),
            testSmartScene,
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
          SmartScene copySmartScene = testSmartScene.copyWith();

          expect(
            copySmartScene.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testSmartSceneJson,
          );
        },
      );

      test(
        "with changes",
        () {
          SmartScene copySmartScene = testSmartScene.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copySmartSceneJson =
              Map<String, dynamic>.from(testSmartSceneJson);

          copySmartSceneJson[ApiFields.id] =
              "00000000-0000-0000-0000-000000000000";
          copySmartSceneJson[ApiFields.idV1] = "/test/1234-5678-9012-3456-7890";

          expect(
            copySmartScene.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copySmartSceneJson,
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
            testSmartScene.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testSmartSceneJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testSmartScene.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          SmartScene alteredSmartScene = testSmartScene.copyWith();
          alteredSmartScene.type = ResourceType.device;

          expect(
            alteredSmartScene.toJson(optimizeFor: OptimizeFor.put),
            {
              "type": ResourceType.device.value,
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
              testSmartScene.copyWith(id: "bad_value");
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
              testSmartScene.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );

      test(
        "invalid name assertion",
        () {
          expect(
            () {
              testSmartScene.copyWith(
                metadata: SmartSceneMetadata(
                  name: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                  image: Relative.fromJson({}),
                ),
              );
            },
            throwsAssertionError,
          );
        },
      );

      test(
        "invalid name exception",
        () {
          expect(
            () {
              testSmartScene.metadata.name = "";
            },
            throwsA(isA<InvalidNameException>()),
          );
        },
      );

      group(
        "start time",
        () {
          test(
            "invalid hour (low) assertion",
            () {
              expect(
                () {
                  SmartSceneWeek(
                    timeslots: [
                      SmartSceneWeekTimeslot(
                        startTime: SmartSceneWeekStartTime(
                          kind: "time",
                          hour: -1,
                          minute: 0,
                          second: 0,
                        ),
                        target: Relative(
                          type: ResourceType.scene,
                          id: "99999999-9999-8888-7777-666655554444",
                        ),
                      ),
                    ],
                    recurrence: ["sunday"],
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid hour (high) assertion",
            () {
              expect(
                () {
                  SmartSceneWeek(
                    timeslots: [
                      SmartSceneWeekTimeslot(
                        startTime: SmartSceneWeekStartTime(
                          kind: "time",
                          hour: 24,
                          minute: 59,
                          second: 59,
                        ),
                        target: Relative(
                          type: ResourceType.scene,
                          id: "99999999-9999-8888-7777-666655554444",
                        ),
                      ),
                    ],
                    recurrence: ["sunday"],
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid minute (low) assertion",
            () {
              expect(
                () {
                  SmartSceneWeek(
                    timeslots: [
                      SmartSceneWeekTimeslot(
                        startTime: SmartSceneWeekStartTime(
                          kind: "time",
                          hour: 0,
                          minute: -1,
                          second: 0,
                        ),
                        target: Relative(
                          type: ResourceType.scene,
                          id: "99999999-9999-8888-7777-666655554444",
                        ),
                      ),
                    ],
                    recurrence: ["sunday"],
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid minute (high) assertion",
            () {
              expect(
                () {
                  SmartSceneWeek(
                    timeslots: [
                      SmartSceneWeekTimeslot(
                        startTime: SmartSceneWeekStartTime(
                          kind: "time",
                          hour: 23,
                          minute: 60,
                          second: 59,
                        ),
                        target: Relative(
                          type: ResourceType.scene,
                          id: "99999999-9999-8888-7777-666655554444",
                        ),
                      ),
                    ],
                    recurrence: ["sunday"],
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid second (low) assertion",
            () {
              expect(
                () {
                  SmartSceneWeek(
                    timeslots: [
                      SmartSceneWeekTimeslot(
                        startTime: SmartSceneWeekStartTime(
                          kind: "time",
                          hour: 0,
                          minute: 0,
                          second: -1,
                        ),
                        target: Relative(
                          type: ResourceType.scene,
                          id: "99999999-9999-8888-7777-666655554444",
                        ),
                      ),
                    ],
                    recurrence: ["sunday"],
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid second (high) assertion",
            () {
              expect(
                () {
                  SmartSceneWeek(
                    timeslots: [
                      SmartSceneWeekTimeslot(
                        startTime: SmartSceneWeekStartTime(
                          kind: "time",
                          hour: 23,
                          minute: 59,
                          second: 60,
                        ),
                        target: Relative(
                          type: ResourceType.scene,
                          id: "99999999-9999-8888-7777-666655554444",
                        ),
                      ),
                    ],
                    recurrence: ["sunday"],
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid hour (low) exception",
            () {
              expect(
                () {
                  testSmartScene
                      .weekTimeslots.first.timeslots.first.startTime.hour = -1;
                },
                throwsA(isA<InvalidHourException>()),
              );
            },
          );

          test(
            "invalid hour (high) exception",
            () {
              expect(
                () {
                  testSmartScene
                      .weekTimeslots.first.timeslots.first.startTime.hour = 60;
                },
                throwsA(isA<InvalidHourException>()),
              );
            },
          );

          test(
            "invalid minute (low) exception",
            () {
              expect(
                () {
                  testSmartScene.weekTimeslots.first.timeslots.first.startTime
                      .minute = -1;
                },
                throwsA(isA<InvalidMinuteException>()),
              );
            },
          );

          test(
            "invalid minute (high) exception",
            () {
              expect(
                () {
                  testSmartScene.weekTimeslots.first.timeslots.first.startTime
                      .minute = 60;
                },
                throwsA(isA<InvalidMinuteException>()),
              );
            },
          );

          test(
            "invalid second (low) exception",
            () {
              expect(
                () {
                  testSmartScene.weekTimeslots.first.timeslots.first.startTime
                      .second = -1;
                },
                throwsA(isA<InvalidSecondException>()),
              );
            },
          );

          test(
            "invalid second (high) exception",
            () {
              expect(
                () {
                  testSmartScene.weekTimeslots.first.timeslots.first.startTime
                      .second = 60;
                },
                throwsA(isA<InvalidSecondException>()),
              );
            },
          );
        },
      );
    },
  );
}
