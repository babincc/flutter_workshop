import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_configuration.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_configuration_channel/entertainment_configuration_channel.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_configuration_channel/entertainment_configuration_channel_member.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_configuration_location.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_configuration_metadata.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_configuration_position.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_configuration_stream_proxy.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/exceptions/unit_interval_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final EntertainmentConfiguration testEntertainmentConfiguration =
      EntertainmentConfiguration(
    type: ResourceType.entertainmentConfiguration,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    metadata: EntertainmentConfigurationMetadata(name: "TV Time"),
    configurationType: "screen",
    status: "inactive",
    activeStreamer: Relative(
      type: ResourceType.device,
      id: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    ),
    streamProxy: EntertainmentConfigurationStreamProxy(
      mode: "auto",
      node: Relative(
        type: ResourceType.device,
        id: "99999999-9999-8888-7777-666655554444",
      ),
    ),
    channels: [
      EntertainmentConfigurationChannel(
        channelId: 130,
        position: EntertainmentConfigurationPosition(
          x: 0.5,
          y: 0.5,
          z: 0.5,
        ),
        members: [
          EntertainmentConfigurationChannelMember(
            service: Relative(
              type: ResourceType.device,
              id: "ffffffff-ffff-ffff-ffff-ffffffffffff",
            ),
            index: 0,
          ),
        ],
      ),
    ],
    locations: [
      EntertainmentConfigurationLocation(
        service: Relative(
          type: ResourceType.device,
          id: "abababab-abab-abab-abab-abababababab",
        ),
        positions: [
          EntertainmentConfigurationPosition(
            x: 0.5,
            y: 0.5,
            z: 0.5,
          ),
        ],
        equalizationFactor: 0.2,
      ),
    ],
    lightServices: [
      Relative(
        type: ResourceType.device,
        id: "00001111-2222-3333-4444-555566667777",
      ),
    ],
  );

  final Map<String, dynamic> testEntertainmentConfigurationJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.type: ResourceType.entertainmentConfiguration.value,
    ApiFields.metadata: {
      ApiFields.name: "TV Time",
    },
    ApiFields.name: "",
    ApiFields.configurationType: "screen",
    ApiFields.status: "inactive",
    ApiFields.activeStreamer: {
      ApiFields.rid: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
      ApiFields.rType: ResourceType.device.value,
    },
    ApiFields.streamProxy: {
      ApiFields.mode: "auto",
      ApiFields.node: {
        ApiFields.rid: "99999999-9999-8888-7777-666655554444",
        ApiFields.rType: ResourceType.device.value,
      },
    },
    ApiFields.channels: [
      {
        ApiFields.channelId: 130,
        ApiFields.position: {
          ApiFields.x: 0.5,
          ApiFields.y: 0.5,
          ApiFields.z: 0.5,
        },
        ApiFields.members: [
          {
            ApiFields.service: {
              ApiFields.rid: "ffffffff-ffff-ffff-ffff-ffffffffffff",
              ApiFields.rType: ResourceType.device.value,
            },
            ApiFields.index: 0,
          },
        ],
      },
    ],
    ApiFields.locations: [
      {
        ApiFields.service: {
          ApiFields.rid: "abababab-abab-abab-abab-abababababab",
          ApiFields.rType: ResourceType.device.value,
        },
        ApiFields.position: {
          ApiFields.x: 0.0,
          ApiFields.y: 0.0,
          ApiFields.z: 0.0,
        },
        ApiFields.positions: [
          {
            ApiFields.x: 0.5,
            ApiFields.y: 0.5,
            ApiFields.z: 0.5,
          },
        ],
        ApiFields.equalizationFactor: 0.2,
      },
    ],
    ApiFields.lightServices: [
      {
        ApiFields.rid: "00001111-2222-3333-4444-555566667777",
        ApiFields.rType: ResourceType.device.value,
      },
    ],
    ApiFields.action: null,
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            EntertainmentConfiguration.fromJson(
                testEntertainmentConfigurationJson),
            testEntertainmentConfiguration,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            EntertainmentConfiguration.fromJson(
                {ApiFields.data: testEntertainmentConfigurationJson}),
            testEntertainmentConfiguration,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            EntertainmentConfiguration.fromJson({
              ApiFields.data: [testEntertainmentConfigurationJson]
            }),
            testEntertainmentConfiguration,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            EntertainmentConfiguration.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testEntertainmentConfigurationJson]
            }),
            testEntertainmentConfiguration,
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
          EntertainmentConfiguration copyEntertainmentConfiguration =
              testEntertainmentConfiguration.copyWith();

          expect(
            copyEntertainmentConfiguration.toJson(
                optimizeFor: OptimizeFor.dontOptimize),
            testEntertainmentConfigurationJson,
          );
        },
      );

      test(
        "with changes",
        () {
          EntertainmentConfiguration copyEntertainmentConfiguration =
              testEntertainmentConfiguration.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyEntertainmentConfigurationJson =
              Map<String, dynamic>.from(testEntertainmentConfigurationJson);

          copyEntertainmentConfigurationJson[ApiFields.id] =
              "00000000-0000-0000-0000-000000000000";
          copyEntertainmentConfigurationJson[ApiFields.idV1] =
              "/test/1234-5678-9012-3456-7890";

          expect(
            copyEntertainmentConfiguration.toJson(
                optimizeFor: OptimizeFor.dontOptimize),
            copyEntertainmentConfigurationJson,
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
            testEntertainmentConfiguration.toJson(
                optimizeFor: OptimizeFor.dontOptimize),
            testEntertainmentConfigurationJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testEntertainmentConfiguration.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          EntertainmentConfiguration alteredEntertainmentConfiguration =
              testEntertainmentConfiguration.copyWith();
          alteredEntertainmentConfiguration.type = ResourceType.device;

          expect(
            alteredEntertainmentConfiguration.toJson(
                optimizeFor: OptimizeFor.put),
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
              testEntertainmentConfiguration.copyWith(id: "bad_value");
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
              testEntertainmentConfiguration.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );

      group(
        "metadata",
        () {
          test(
            "invalid name (deprecated) assertion",
            () {
              expect(
                () {
                  testEntertainmentConfiguration.copyWith(
                    name:
                        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                  );
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
                  testEntertainmentConfiguration.copyWith(
                    metadata: EntertainmentConfigurationMetadata(
                      name:
                          "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
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
                  testEntertainmentConfiguration.metadata.name = "";
                },
                throwsA(isA<InvalidNameException>()),
              );
            },
          );
        },
      );

      group(
        "channel",
        () {
          test(
            "invalid channel id (low) assertion",
            () {
              expect(
                () {
                  testEntertainmentConfiguration.copyWith(
                    channels: [
                      EntertainmentConfigurationChannel(
                        channelId: -1,
                        position: testEntertainmentConfiguration
                            .channels.first.position,
                        members: testEntertainmentConfiguration
                            .channels.first.members,
                      ),
                    ],
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid channel id (high) assertion",
            () {
              expect(
                () {
                  testEntertainmentConfiguration.copyWith(
                    channels: [
                      EntertainmentConfigurationChannel(
                        channelId: 256,
                        position: testEntertainmentConfiguration
                            .channels.first.position,
                        members: testEntertainmentConfiguration
                            .channels.first.members,
                      ),
                    ],
                  );
                },
                throwsAssertionError,
              );
            },
          );
        },
      );

      group(
        "location",
        () {
          test(
            "invalid equalization factor (low) assertion",
            () {
              expect(
                () {
                  testEntertainmentConfiguration.copyWith(
                    locations: [
                      EntertainmentConfigurationLocation(
                        service: testEntertainmentConfiguration
                            .locations.first.service,
                        positions: testEntertainmentConfiguration
                            .locations.first.positions,
                        equalizationFactor: -0.0000001,
                      ),
                    ],
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid equalization factor (low) exception",
            () {
              expect(
                () {
                  testEntertainmentConfiguration
                      .locations.first.equalizationFactor = -0.0000001;
                },
                throwsA(isA<UnitIntervalException>()),
              );
            },
          );

          test(
            "invalid equalization factor (high) assertion",
            () {
              expect(
                () {
                  testEntertainmentConfiguration.copyWith(
                    locations: [
                      EntertainmentConfigurationLocation(
                        service: testEntertainmentConfiguration
                            .locations.first.service,
                        positions: testEntertainmentConfiguration
                            .locations.first.positions,
                        equalizationFactor: 1.0000001,
                      ),
                    ],
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid equalization factor (high) exception",
            () {
              expect(
                () {
                  testEntertainmentConfiguration
                      .locations.first.equalizationFactor = 1.0000001;
                },
                throwsA(isA<UnitIntervalException>()),
              );
            },
          );
        },
      );
    },
  );
}
