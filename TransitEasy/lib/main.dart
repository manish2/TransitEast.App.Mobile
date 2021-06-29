import 'package:TransitEasy/blocs/blocs.dart';
import 'package:TransitEasy/blocs/permissions_bloc.dart';
import 'package:TransitEasy/blocs/stopslocationmap_bloc.dart';
import 'package:TransitEasy/blocs/userlocation_bloc.dart';
import 'package:TransitEasy/blocs/usersettings_bloc.dart';
import 'package:TransitEasy/clients/clients.dart';
import 'package:TransitEasy/repositories/repositories.dart';
import 'package:TransitEasy/repositories/usersettings_repository.dart';
import 'package:TransitEasy/screens/stopslocation/stops_locations.dart';
import 'package:TransitEasy/services/geolocation_service.dart';
import 'package:TransitEasy/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/observers/default_bloc_observer.dart';

void main() {
  Bloc.observer = DefaultBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GeoLocationService _geoLocationService = GeoLocationService();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final UserLocationRepository _userLocationRepository =
        UserLocationRepository(_geoLocationService);
    final TransitEasyRepository _transitEasyRepository =
        TransitEasyRepository(TransitEasyApiClient());
    final UserSettingsRepository _userSettingsRepository =
        UserSettingsRepository(SettingsService());
    final UserLocationBloc _userLocationBloc =
        UserLocationBloc(_userLocationRepository);
    final StopsInfoBloc _stopsInfoBloc = StopsInfoBloc(_transitEasyRepository);
    return MultiBlocProvider(
        providers: [
          BlocProvider<PermissionsBloc>(
              create: (BuildContext context) =>
                  PermissionsBloc(_geoLocationService)),
          BlocProvider<StopsInfoBloc>(
              create: (BuildContext context) => _stopsInfoBloc),
          BlocProvider<StopsLocationsMapBloc>(
              create: (BuildContext context) => StopsLocationsMapBloc(
                  _userLocationRepository,
                  _userSettingsRepository,
                  _transitEasyRepository)),
          BlocProvider<UserLocationBloc>(
              create: (BuildContext context) => _userLocationBloc),
          BlocProvider(
              create: (BuildContext context) =>
                  UserSettingsBloc(_userSettingsRepository))
        ],
        child: MaterialApp(
          title: 'TransitEasy',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity),
          home: StopsLocationsScreen(),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
