import 'package:TransitEasy/constants.dart';
import 'package:TransitEasy/screens/navigation/nav_bar_item.dart';
import 'package:TransitEasy/screens/settings.dart';
import 'package:TransitEasy/screens/stops_location.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  //creates padding at top of sidenav for different viewports
  double getTopPadding(BuildContext ctx) {
    return (MediaQuery.of(ctx).size.height * 0.08).roundToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [gradientStartColor, gradientEndColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.3, 0.7])),
            padding: EdgeInsets.only(top: getTopPadding(context)),
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              NavbarItem(
                title: 'Stops near me',
                icon: Icons.stop_sharp,
                showDivider: true,
                onTapListener: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new StopsLocationScreen()));
                },
              ),
              NavbarItem(
                title: 'Buses near me',
                icon: Icons.location_pin,
                showDivider: true,
              ),
              NavbarItem(
                title: 'Enter Stop Number',
                icon: Icons.search,
                showDivider: true,
              ),
              NavbarItem(
                title: 'Bus Schedules',
                icon: Icons.directions_bus,
                showDivider: true,
              ),
              NavbarItem(
                title: 'Skytrain Schedules',
                icon: Icons.train,
                showDivider: true,
              ),
              NavbarItem(
                title: 'Seabus Schedules',
                icon: Icons.directions_ferry,
                showDivider: true,
              ),
              NavbarItem(
                title: 'Traffic Updates',
                icon: Icons.traffic,
                showDivider: true,
              ),
              NavbarItem(
                title: 'Service Alerts',
                icon: Icons.info,
                showDivider: true,
              ),
              NavbarItem(
                title: 'Settings',
                icon: Icons.settings,
                showDivider: false,
                onTapListener: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new SettingsScreen()));
                },
              ),
            ])));
  }
}
