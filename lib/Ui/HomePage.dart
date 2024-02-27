import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_details.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController start = TextEditingController();
  TextEditingController end = TextEditingController();
   HereMapController? mapController;
  ValueNotifier<List<double>> startTrip = ValueNotifier([0, 0]);
  ValueNotifier<List<double>> endTrip = ValueNotifier([0, 0]);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print("Called build");
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: Stack(
          children: [
            HereMap(onMapCreated: _onMapCreated),
            Expanded(
              child: Container(
                color: Colors.white,
                height: height * 0.20,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      buildAutoCompleteTextField(
                        controller: start,
                        hintText: "Add Pick-Up Location To reach",
                        valueListenable: startTrip,
                        onItemClicked: (Prediction prediction) async {
                          handleAutoCompleteItemClicked(
                              prediction, start, startTrip);
                        },

                  ),

                      SizedBox(height: 10),
                      buildAutoCompleteTextField(
                        controller: end,
                        hintText: "Add Drop-Up Location",
                        valueListenable: endTrip,
                        onItemClicked: (Prediction prediction) async {
                          handleAutoCompleteItemClicked(prediction, end, endTrip);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAutoCompleteTextField({
    required TextEditingController controller,
    required String hintText,
    required ValueNotifier<List<double>> valueListenable,
    required Function(Prediction) onItemClicked,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      color: Colors.white,
      child: GooglePlaceAutoCompleteTextField(

        textEditingController: controller,
        googleAPIKey: "AIzaSyCxkZ5v_JnNHQTpiC7eTwvt6vfVyidUIKY",
        inputDecoration:
            InputDecoration(hintText: hintText, border: InputBorder.none),
        debounceTime: 0,
        countries: const ["in"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (prediction) async {},
        itemClick: onItemClicked,
        itemBuilder: (context, index, prediction) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(prediction.description ?? "",
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                )
              ],
            ),
          );
        },
        seperatedBuilder: const Divider(),
        isCrossBtnShown: true,
      ),
    );
  }

  void _onMapCreated(HereMapController hereMapController) {
    print("Called mapcreate");

    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalNight,
        (MapError? error) {
      if (error != null) {
        print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      }

      const double distanceToEarthInMeters = 80000;
      MapMeasure mapMeasureZoom =
          MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);
      if (startTrip.value[0] != 0 && startTrip.value[1] != 0) {
        hereMapController.camera.lookAtPointWithMeasure(
            GeoCoordinates(startTrip.value[0], startTrip.value[1]), mapMeasureZoom);
      }else{
        hereMapController.camera.lookAtPointWithMeasure(
            GeoCoordinates(28.6196265, 77.0137044), mapMeasureZoom);
      }


     mapController = hereMapController;


      if (endTrip.value[0] != 0 && startTrip.value[0] != 0) {
        addRoute(
            GeoCoordinates(startTrip.value[0], startTrip.value[1]),
            GeoCoordinates(endTrip.value[0], endTrip.value[1]),
            hereMapController);
      }
    });
  }

  void handleAutoCompleteItemClicked(
      Prediction prediction,
      TextEditingController controller,
      ValueNotifier<List<double>> valueListenable) async {
    print(prediction);
    controller.text = prediction.description!;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: prediction.description!.length),
    );

    var url =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=${prediction.placeId}&key=AIzaSyCxkZ5v_JnNHQTpiC7eTwvt6vfVyidUIKY";
    Response response = await Dio().get(url);
    print(response.data);
    print("-=-=-=-=-=-=");
    PlaceDetails placeDetails = PlaceDetails.fromJson(response.data);

    prediction.lat = placeDetails.result!.geometry!.location!.lat.toString();
    prediction.lng = placeDetails.result!.geometry!.location!.lng.toString();

    print(prediction.lat.toString());
    print("objectdddd ${controller.text}");

    print('Latitude: ${prediction.lat}, Longitude: ${prediction.lng}');
    valueListenable.value[0] = double.parse(prediction.lat.toString());
    valueListenable.value[1] = double.parse(prediction.lng.toString());
    print(valueListenable.value);
    print("llllll");
    _onMapCreated(
        mapController!);
  }

  void addRoute(GeoCoordinates startPoint, GeoCoordinates endPoint,
      HereMapController hereMapController) {
    print("Called addroute");

    RoutingEngine routingEngine = RoutingEngine();
    Waypoint startPointWay = Waypoint.withDefaults(startPoint);
    Waypoint endPointWay = Waypoint.withDefaults(endPoint);
    List<Waypoint> wayPoints = [startPointWay, endPointWay];

    routingEngine.calculateCarRoute(wayPoints, CarOptions(), (error, routing) {
      if (error == null) {
        var route = routing!.first;
        GeoPolyline routeGeoPoly = route!.geometry;
        double polywidth = 10.0;
        var mypolyline =
            MapPolyline(routeGeoPoly, polywidth, Colors.blueAccent);
        hereMapController.mapScene.addMapPolyline(mypolyline);
      }
    });
  }
}
