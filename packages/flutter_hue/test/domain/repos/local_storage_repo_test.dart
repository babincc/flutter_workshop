import 'package:flutter_hue/domain/repos/local_storage_repo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "encrypting and decrypting",
    () {
      const String plaintext1 = "A very simple plaintext.";
      const String plaintext2 =
          "A more complex plaintext.\nWith multiple lines.";
      const String plaintext3 =
          "A plaintext with special characters: !@#\$%^&*()";
      const String plaintext4 =
          "A plaintext with emojis: 😃😄😁😆😅😂🤣☺️😊😇🙂🙃🤔🤭🤫🤥😶😐😑😬🙄";

      group(
        "defaults",
        () {
          test(
            "default 1",
            () {
              final String ciphertext = LocalStorageRepo.encrypt(plaintext1);

              expect(
                LocalStorageRepo.decrypt(ciphertext),
                plaintext1,
              );
            },
          );

          test(
            "default 2",
            () {
              final String ciphertext = LocalStorageRepo.encrypt(plaintext2);

              expect(
                LocalStorageRepo.decrypt(ciphertext),
                plaintext2,
              );
            },
          );

          test(
            "default 3",
            () {
              final String ciphertext = LocalStorageRepo.encrypt(plaintext3);

              expect(
                LocalStorageRepo.decrypt(ciphertext),
                plaintext3,
              );
            },
          );

          test(
            "default 4",
            () {
              final String ciphertext = LocalStorageRepo.encrypt(plaintext4);

              expect(
                LocalStorageRepo.decrypt(ciphertext),
                plaintext4,
              );
            },
          );
        },
      );

      group(
        "additional algorithms",
        () {
          encrypter(String plaintext) => "abcd${plaintext}1234";
          decrypter(String ciphertext) =>
              ciphertext.substring(4, ciphertext.length - 4);

          group(
            "expected successes",
            () {
              test(
                "additional algorithm (success) 1",
                () {
                  final String ciphertext =
                      LocalStorageRepo.encrypt(plaintext1, encrypter);

                  expect(
                    LocalStorageRepo.decrypt(ciphertext, decrypter),
                    plaintext1,
                  );
                },
              );

              test(
                "additional algorithm (success) 2",
                () {
                  final String ciphertext =
                      LocalStorageRepo.encrypt(plaintext2, encrypter);

                  expect(
                    LocalStorageRepo.decrypt(ciphertext, decrypter),
                    plaintext2,
                  );
                },
              );

              test(
                "additional algorithm (success) 3",
                () {
                  final String ciphertext =
                      LocalStorageRepo.encrypt(plaintext3, encrypter);

                  expect(
                    LocalStorageRepo.decrypt(ciphertext, decrypter),
                    plaintext3,
                  );
                },
              );

              test(
                "additional algorithm (success) 4",
                () {
                  final String ciphertext =
                      LocalStorageRepo.encrypt(plaintext4, encrypter);

                  expect(
                    LocalStorageRepo.decrypt(ciphertext, decrypter),
                    plaintext4,
                  );
                },
              );
            },
          );

          group(
            "expected fails",
            () {
              group(
                "added encrypter with no decrypter",
                () {
                  test(
                    "additional enc algorithm (no dec) 1",
                    () {
                      final String ciphertext =
                          LocalStorageRepo.encrypt(plaintext1, encrypter);

                      final String? actual =
                          LocalStorageRepo.decrypt(ciphertext);

                      expect(
                        actual == plaintext1,
                        false,
                      );
                    },
                  );

                  test(
                    "additional enc algorithm (no dec) 2",
                    () {
                      final String ciphertext =
                          LocalStorageRepo.encrypt(plaintext2, encrypter);

                      final String? actual =
                          LocalStorageRepo.decrypt(ciphertext);

                      expect(
                        actual == plaintext2,
                        false,
                      );
                    },
                  );

                  test(
                    "additional enc algorithm (no dec) 3",
                    () {
                      final String ciphertext =
                          LocalStorageRepo.encrypt(plaintext3, encrypter);

                      final String? actual =
                          LocalStorageRepo.decrypt(ciphertext);

                      expect(
                        actual == plaintext3,
                        false,
                      );
                    },
                  );

                  test(
                    "additional enc algorithm (no dec) 4",
                    () {
                      final String ciphertext =
                          LocalStorageRepo.encrypt(plaintext4, encrypter);

                      final String? actual =
                          LocalStorageRepo.decrypt(ciphertext);

                      expect(
                        actual == plaintext4,
                        false,
                      );
                    },
                  );
                },
              );

              group(
                "added decrypter with no encrypter",
                () {
                  test(
                    "additional dec algorithm (no enc) 1",
                    () {
                      final String ciphertext =
                          LocalStorageRepo.encrypt(plaintext1);

                      final String? actual =
                          LocalStorageRepo.decrypt(ciphertext, decrypter);

                      expect(
                        actual == plaintext1,
                        false,
                      );
                    },
                  );

                  test(
                    "additional dec algorithm (no enc) 2",
                    () {
                      final String ciphertext =
                          LocalStorageRepo.encrypt(plaintext2);

                      final String? actual =
                          LocalStorageRepo.decrypt(ciphertext, decrypter);

                      expect(
                        actual == plaintext2,
                        false,
                      );
                    },
                  );

                  test(
                    "additional dec algorithm (no enc) 3",
                    () {
                      final String ciphertext =
                          LocalStorageRepo.encrypt(plaintext3);

                      final String? actual =
                          LocalStorageRepo.decrypt(ciphertext, decrypter);

                      expect(
                        actual == plaintext3,
                        false,
                      );
                    },
                  );

                  test(
                    "additional dec algorithm (no enc) 4",
                    () {
                      final String ciphertext =
                          LocalStorageRepo.encrypt(plaintext4);

                      final String? actual =
                          LocalStorageRepo.decrypt(ciphertext, decrypter);

                      expect(
                        actual == plaintext4,
                        false,
                      );
                    },
                  );
                },
              );

              group(
                "non-matching encrypters and decrypters",
                () {
                  bogusEncrypter(String plaintext) => "$plaintext\n$plaintext";
                  bogusDecrypter(String ciphertext) =>
                      ciphertext.substring(0, (ciphertext.length / 3).floor());

                  test(
                    "additional algorithm (bogus dec) 1",
                    () {
                      final String ciphertext =
                          LocalStorageRepo.encrypt(plaintext1, encrypter);

                      final actual =
                          LocalStorageRepo.decrypt(ciphertext, bogusDecrypter);

                      expect(
                        actual == plaintext1,
                        false,
                      );
                    },
                  );

                  test(
                    "additional algorithm (bogus dec) 2",
                    () {
                      final String ciphertext =
                          LocalStorageRepo.encrypt(plaintext2, encrypter);

                      final actual =
                          LocalStorageRepo.decrypt(ciphertext, bogusDecrypter);

                      expect(
                        actual == plaintext2,
                        false,
                      );
                    },
                  );

                  test(
                    "additional algorithm (bogus dec) 3",
                    () {
                      final String ciphertext =
                          LocalStorageRepo.encrypt(plaintext3, encrypter);

                      final actual =
                          LocalStorageRepo.decrypt(ciphertext, bogusDecrypter);

                      expect(
                        actual == plaintext3,
                        false,
                      );
                    },
                  );

                  test(
                    "additional algorithm (bogus dec) 4",
                    () {
                      final String ciphertext =
                          LocalStorageRepo.encrypt(plaintext4, encrypter);

                      final actual =
                          LocalStorageRepo.decrypt(ciphertext, bogusDecrypter);

                      expect(
                        actual == plaintext4,
                        false,
                      );
                    },
                  );

                  test(
                    "additional algorithm (bogus enc) 1",
                    () {
                      final String ciphertext =
                          LocalStorageRepo.encrypt(plaintext1, bogusEncrypter);

                      final actual =
                          LocalStorageRepo.decrypt(ciphertext, decrypter);

                      expect(
                        actual == plaintext1,
                        false,
                      );
                    },
                  );

                  test(
                    "additional algorithm (bogus enc) 2",
                    () {
                      final String ciphertext =
                          LocalStorageRepo.encrypt(plaintext2, bogusEncrypter);

                      final actual =
                          LocalStorageRepo.decrypt(ciphertext, decrypter);

                      expect(
                        actual == plaintext2,
                        false,
                      );
                    },
                  );

                  test(
                    "additional algorithm (bogus enc) 3",
                    () {
                      final String ciphertext =
                          LocalStorageRepo.encrypt(plaintext3, bogusEncrypter);

                      final actual =
                          LocalStorageRepo.decrypt(ciphertext, decrypter);

                      expect(
                        actual == plaintext3,
                        false,
                      );
                    },
                  );

                  test(
                    "additional algorithm (bogus enc) 4",
                    () {
                      final String ciphertext =
                          LocalStorageRepo.encrypt(plaintext4, bogusEncrypter);

                      final actual =
                          LocalStorageRepo.decrypt(ciphertext, decrypter);

                      expect(
                        actual == plaintext4,
                        false,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}
