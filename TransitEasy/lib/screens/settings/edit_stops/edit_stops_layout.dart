import 'dart:async';
import 'package:TransitEasy/common/services/locations_services.dart';
import 'package:TransitEasy/common/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../constants.dart';

class EditStopsLayout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EditStopsLayoutState();
}

class EditStopsLayoutState extends State<EditStopsLayout> {
  Completer<GoogleMapController> _controller = Completer();
  final LocationService _locationService = LocationService();
  final SettingsService _settingsService = SettingsService();
  final FToast _fToast = FToast();
  final Widget _successToast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.greenAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check),
        SizedBox(
          width: 12.0,
        ),
        Text("Setting updated succesfully!"),
      ],
    ),
  );
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  double _sliderValue;
  LatLng _latLng;
  bool _isFirstRun = true;
  bool _isSaveEnabled = false;
  double _savedSearchRadius;

  Future<CameraPosition> getCurrentPosition() => _locationService
          .getCurrentUserPosition()
          .then<CameraPosition>((value) async {
        if (_isFirstRun == null || _isFirstRun) {
          _latLng = LatLng(value.latitude, value.longitude);
          var settings = await _settingsService.getUserSettingsAsync();
          _savedSearchRadius = settings.searchRadiusKm.toDouble();
          _sliderValue = _savedSearchRadius;
          _circles.add(Circle(
              center: _latLng,
              strokeWidth: 2,
              fillColor: Color.fromRGBO(221, 160, 221, .6),
              strokeColor: appPageColor,
              radius: settings.searchRadiusKm.toDouble(),
              circleId: CircleId("test")));
          _markers.add(Marker(
              markerId: MarkerId("a"),
              position: _latLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              draggable: false));
          _isFirstRun = false;
        }
        return CameraPosition(target: _latLng, zoom: 16.0);
      });

  void updateValues(double newSliderValue) {
    setState(() {
      _isSaveEnabled = _savedSearchRadius != newSliderValue;
      _sliderValue = newSliderValue;
      _circles.clear();
      _circles.add(Circle(
          center: _latLng,
          strokeWidth: 2,
          fillColor: Color.fromRGBO(221, 160, 221, .6),
          strokeColor: appPageColor,
          radius: newSliderValue,
          circleId: CircleId("test")));
    });
  }

  void handleOnSavePress() {
    _settingsService
        .setStopsSearchRadiusMetersSetting(_sliderValue.toInt())
        .then((result) => {
              if (result)
                {
                  _fToast.showToast(
                      child: _successToast,
                      gravity: ToastGravity.BOTTOM,
                      toastDuration: Duration(seconds: 2)),
                  Navigator.pop(context)
                }
            });
  }

  @override
  void initState() {
    _fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CameraPosition>(
        future: getCurrentPosition(),
        builder:
            (BuildContext context, AsyncSnapshot<CameraPosition> snapshot) {
          Widget result;
          if (snapshot.hasData) {
            result = Column(
              children: <Widget>[
                Container(
                    child: SizedBox(
                        height: 300,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          zoomControlsEnabled: true,
                          initialCameraPosition: snapshot.data,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          markers: _markers,
                          circles: _circles,
                        )),
                    alignment: Alignment.center,
                    color: appPageColor),
                Slider(
                  value: _sliderValue,
                  onChanged: (val) => updateValues(val),
                  min: 100,
                  max: 500,
                  divisions: 8,
                  label: "$_sliderValue",
                  inactiveColor: Color.fromRGBO(221, 160, 221, .6),
                ),
                ElevatedButton(
                    onPressed:
                        _isSaveEnabled ? () => handleOnSavePress() : null,
                    child: Text("Save"))
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            );
          } else if (snapshot.hasError) {
            result = Text("SOMETHING WENT WRONG", textAlign: TextAlign.center);
          } else {
            result = Container(
                child: SizedBox(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(221, 160, 221, .6)),
                  ),
                  width: 60,
                  height: 60,
                ),
                alignment: Alignment.center,
                color: appPageColor);
          }
          return result;
        });
  }
}