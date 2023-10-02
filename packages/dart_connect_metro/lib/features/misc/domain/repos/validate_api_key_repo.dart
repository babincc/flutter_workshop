import 'package:dart_connect_metro/features/misc/domain/services/validate_api_key_service.dart';

/// Fetches the validation of an API key.
///
/// Returns `true` if the API key is valid, `false` otherwise.
///
/// `apiKey` is your API key for the WMATA API.
Future<bool> fetchApiKeyValidation(String apiKey) async =>
    await ValidateApiKeyService.fetchApiKeyValidation(apiKey);
