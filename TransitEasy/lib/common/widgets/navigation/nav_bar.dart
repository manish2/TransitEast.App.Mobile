import 'package:TransitEasy/common/widgets/navigation/nav_bar_item.dart';
import 'package:TransitEasy/screens/settings/settings.dart';
import 'package:TransitEasy/screens/stopslocation/stops_locations.dart';
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
              color: Color.fromRGBO(51, 0, 123, .95),
            ),
            padding: EdgeInsets.only(top: getTopPadding(context)),
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              NavbarItem(
                title: 'Stops near me',
                icon: Icons.bus_alert,
                showDivider: true,
                onTapListener: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new StopsLocationsScreen()));
                },
              ),
              NavbarItem(
                  title: 'Buses near me',
                  icon: Icons.location_pin,
                  showDivider: true,
                  onTapListener: () {}),
              NavbarItem(
                  title: 'Enter Stop Number',
                  icon: Icons.search,
                  showDivider: true,
                  onTapListener: () {}),
              NavbarItem(
                  title: 'Bus Schedules',
                  icon: Icons.directions_bus,
                  showDivider: true,
                  onTapListener: () {}),
              NavbarItem(
                  title: 'Skytrain Schedules',
                  icon: Icons.train,
                  showDivider: true,
                  onTapListener: () {}),
              NavbarItem(
                  title: 'Seabus Schedules',
                  icon: Icons.directions_ferry,
                  showDivider: true,
                  onTapListener: () {}),
              NavbarItem(
                  title: 'Traffic Updates',
                  icon: Icons.traffic,
                  showDivider: true,
                  onTapListener: () {}),
              NavbarItem(
                  title: 'Service Alerts',
                  icon: Icons.info,
                  showDivider: true,
                  onTapListener: () {}),
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
