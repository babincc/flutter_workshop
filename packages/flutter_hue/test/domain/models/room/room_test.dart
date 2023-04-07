import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/models/room/room.dart';
import 'package:flutter_hue/domain/models/room/room_archetype.dart';
import 'package:flutter_hue/domain/models/room/room_metadata.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Room testRoom = Room(
    type: ResourceType.room,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    children: [
      Relative(
        type: ResourceType.device,
        id: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
      ),
      Relative(
        type: ResourceType.device,
        id: "00001111-2222-3333-4444-555566667777",
      ),
      Relative(
        type: ResourceType.device,
        id: "12345678-1234-1234-1234-123456789012",
      ),
      Relative(
        type: ResourceType.device,
        id: "abababab-abab-abab-abab-abababababab",
      ),
    ],
    services: [
      Relative(
        type: ResourceType.groupedLight,
        id: "99999999-9999-8888-7777-666655554444",
      ),
    ],
    metadata: RoomMetadata(
      name: "My Bedroom",
      archetype: RoomArchetype.bedroom,
    ),
  );

  final Map<String, dynamic> testRoomJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.children: [
      {
        ApiFields.rid: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
        ApiFields.rType: ResourceType.device.value,
      },
      {
        ApiFields.rid: "00001111-2222-3333-4444-555566667777",
        ApiFields.rType: ResourceType.device.value,
      },
      {
        ApiFields.rid: "12345678-1234-1234-1234-123456789012",
        ApiFields.rType: ResourceType.device.value,
      },
      {
        ApiFields.rid: "abababab-abab-abab-abab-abababababab",
        ApiFields.rType: ResourceType.device.value,
      }
    ],
    ApiFields.services: [
      {
        ApiFields.rid: "99999999-9999-8888-7777-666655554444",
        ApiFields.rType: ResourceType.groupedLight.value,
      },
    ],
    ApiFields.metadata: {
      ApiFields.name: "My Bedroom",
      ApiFields.archetype: RoomArchetype.bedroom.value,
    },
    ApiFields.type: ResourceType.room.value,
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            Room.fromJson(testRoomJson),
            testRoom,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            Room.fromJson({ApiFields.data: testRoomJson}),
            testRoom,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            Room.fromJson({
              ApiFields.data: [testRoomJson]
            }),
            testRoom,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            Room.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testRoomJson]
            }),
            testRoom,
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
          Room copyRoom = testRoom.copyWith();

          expect(
            copyRoom.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testRoomJson,
          );
        },
      );

      test(
        "with changes",
        () {
          Room copyRoom = testRoom.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyRoomJson =
              Map<String, dynamic>.from(testRoomJson);

          copyRoomJson[ApiFields.id] = "00000000-0000-0000-0000-000000000000";
          copyRoomJson[ApiFields.idV1] = "/test/1234-5678-9012-3456-7890";

          expect(
            copyRoom.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyRoomJson,
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
            testRoom.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testRoomJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testRoom.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          Room alteredRoom = testRoom.copyWith();
          alteredRoom.type = ResourceType.device;

          expect(
            alteredRoom.toJson(optimizeFor: OptimizeFor.put),
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
              testRoom.copyWith(id: "bad_value");
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
              testRoom.copyWith(idV1: "bad_value");
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
              testRoom.copyWith(
                metadata: RoomMetadata(
                  name: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                  archetype: testRoom.metadata.archetype,
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
              testRoom.metadata.name = "";
            },
            throwsA(isA<InvalidNameException>()),
          );
        },
      );
    },
  );
}
