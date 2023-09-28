import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() {
  final String apiKey = ApiRepo.getApiKey();

  group(
    'fetchBusIncidents',
    () {
      test(
        'without routeId',
        () async {
          // ignore: unused_local_variable
          final List<BusIncident> result = await fetchBusIncidents(apiKey);

          // Can't use [expect] here because the API is dynamic.
        },
      );

      test(
        'with routeId',
        () async {
          final List<Route> routes = await fetchRoutes(apiKey);

          final String routeId = routes.first.routeId;

          // ignore: unused_local_variable
          final List<BusIncident> result = await fetchBusIncidents(
            apiKey,
            routeId: routeId,
          );

          // Can't use [expect] here because the API is dynamic.
        },
      );
    },
  );
}
