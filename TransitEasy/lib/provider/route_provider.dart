import 'package:TransitEasy/blocs/busrouteslist_bloc.dart';
import 'package:TransitEasy/blocs/permissions_bloc.dart';
import 'package:TransitEasy/blocs/schedulednotifications_bloc.dart';
import 'package:TransitEasy/blocs/servicealerts_bloc.dart';
import 'package:TransitEasy/blocs/stopnumbersearch_bloc.dart';
import 'package:TransitEasy/clients/clients.dart';
import 'package:TransitEasy/clients/transiteasy_scheduler_api_client.dart';
import 'package:TransitEasy/common/widgets/error/error_page.dart';
import 'package:TransitEasy/repositories/usersettings_repository.dart';
import 'package:TransitEasy/screens/schedules/seabus_schedules.dart';
import 'package:TransitEasy/screens/schedules/skytrain_schedules.dart';
import 'package:TransitEasy/screens/servicealerts/service_alerts.dart';
import 'package:TransitEasy/screens/settings/settings.dart';
import 'package:TransitEasy/screens/stopnumbersearch/pinnedstopsearch.dart';
import 'package:TransitEasy/screens/stopnumbersearch/stopnumbersearch.dart';
import 'package:TransitEasy/screens/stopslocation/stop_info_stream_model.dart';
import 'package:TransitEasy/screens/stopslocation/stops_locations.dart';
import 'package:TransitEasy/screens/trackmybus/track_my_bus.dart';
import 'package:TransitEasy/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteProvider {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (BuildContext context) => new StopsLocationsScreen());
      case '/trackmybus':
        return MaterialPageRoute(builder: (BuildContext context) {
          final BusRoutesListBloc _busRoutesListBloc =
              BlocProvider.of<BusRoutesListBloc>(context);
          final PermissionsBloc _permissionBloc =
              BlocProvider.of<PermissionsBloc>(context);
          return TrackMyBusScreen(_busRoutesListBloc, _permissionBloc);
        });
      case '/servicealerts':
        return MaterialPageRoute(builder: (BuildContext context) {
          final ServiceAlertsBloc _serviceAlertsBloc =
              BlocProvider.of<ServiceAlertsBloc>(context);
          return ServiceAlertsScreen(_serviceAlertsBloc);
        });
      case '/stopnumber':
        return MaterialPageRoute(builder: (BuildContext context) {
          final StopNumberSearchBloc _stopNumberSearchBloc =
              BlocProvider.of<StopNumberSearchBloc>(context);
          return StopNumberSearchScreen(_stopNumberSearchBloc);
        });
      case '/seabusschedule':
        return MaterialPageRoute(builder: (BuildContext context) {
          return SeabusSchedulesScreen();
        });
      case '/skytrainschedule':
        return MaterialPageRoute(builder: (BuildContext context) {
          return SkytrainSchedulesScreen();
        });
      case '/settings':
        return MaterialPageRoute(builder: (BuildContext context) {
          return SettingsScreen();
        });
      case '/pinnedstop':
        return MaterialPageRoute(builder: (BuildContext context) {
          if (args is StopInfoStreamModel) {
            TransitEasySchedulerApiClient apiClient =
                new TransitEasySchedulerApiClient();
            SettingsService service = new SettingsService();
            UserSettingsRepository repository =
                new UserSettingsRepository(service);
            final ScheduledNotificationsBloc _scheduledNotificationBloc =
                new ScheduledNotificationsBloc(apiClient, repository);
            final StopNumberSearchBloc _stopNumberSearchBloc =
                BlocProvider.of<StopNumberSearchBloc>(context);
            return PinnedStopSearchScreen(
                args, _stopNumberSearchBloc, _scheduledNotificationBloc);
          }
          return ErrorPage();
        });
    }
    return MaterialPageRoute(
        builder: (BuildContext context) => new StopsLocationsScreen());
  }
}
