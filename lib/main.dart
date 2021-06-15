import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_controller/map_controller.dart';
import 'package:overpass/download.dart';
import 'package:overpass/setting.dart';
import 'dart:async';

import 'myform.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  MapController mapController;
  StatefulMapController statefulMapController;
  // ignore: cancel_subscriptions
  StreamSubscription<StatefulMapControllerStateChange> sub;
  @override
  void initState() {
    super.initState();
    mapController = MapController();
    statefulMapController = StatefulMapController(mapController: mapController);
    sub = statefulMapController.changeFeed.listen((change) => setState(() {}));
  }

  List<LayerOptions> listLayer = [];

  Future queryForm(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Myform(statefulMapController: statefulMapController);
      },
    );
  }

  void removeData() {
    List<String> markers = [];
    List<String> polylines = [];
    List<String> polygons = [];
    statefulMapController.namedMarkers.forEach((key, value) {
      markers.add(key);
    });
    statefulMapController.namedLines.forEach((key, value) {
      polylines.add(key);
    });
    statefulMapController.namedPolygons.forEach((key, value) {
      polygons.add(key);
    });
    statefulMapController.removeMarkers(names: markers);
    polylines.forEach((element) {
      statefulMapController.removeLine(element);
    });
    polygons.forEach((element) {
      statefulMapController.removePolygon(element);
    });
  }

  Future _downloadFile(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Download Geojson File"),
          content: SingleChildScrollView(
            child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FormBuilderTextField(
                    name: "fileName",
                    decoration: InputDecoration(
                        labelText: "File Name",
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            new ElevatedButton(
              child: new Text("Download"),
              onPressed: () {
                _formKey.currentState.save();
                var formValue = _formKey.currentState.value;
                downloadFile(context, statefulMapController, formValue["fileName"]);
                Navigator.of(context).pop();
              },
            ),
            new ElevatedButton(
              child: new Text("Close"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      marginBottom: 16,
      animatedIconTheme: IconThemeData(size: 22.0),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      icon: Icons.add,
      activeIcon: Icons.close,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () {
            queryForm(context);
          },
          label: "Add data",
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          // labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: Icon(Icons.settings, color: Colors.white),
          backgroundColor: Colors.grey,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => QuerySetting()));
          },
          label: "Setting",
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          // labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: Icon(Icons.delete, color: Colors.white),
          backgroundColor: Colors.red,
          onTap: () {
            removeData();
          },
          label: "Clear Map",
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          // labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: Icon(Icons.file_download, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: () {
            _downloadFile(context);
          },
          label: "Download Geojson",
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          // labelBackgroundColor: Colors.green,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          new FlutterMap(
            mapController: mapController,
            options: new MapOptions(
              center: LatLng(27.682159, 85.326797),
              zoom: 15.0,
            ),
            layers: [
              statefulMapController.tileLayer,
              MarkerLayerOptions(markers: statefulMapController.markers),
              PolylineLayerOptions(polylines: statefulMapController.lines),
              PolygonLayerOptions(polygons: statefulMapController.polygons)
            ],
          ),
        ],
      ),
      floatingActionButton: buildSpeedDial(),
    );
  }
}
