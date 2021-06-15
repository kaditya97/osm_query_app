import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void overpassquery(statefulMapController, key, value, choice) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var typeDict = {};
  typeDict['node'] = {};
  typeDict['way'] = {};
  LatLngBounds bounds = statefulMapController.mapController.bounds;
  var lat1 = bounds.southWest.latitude;
  var lng1 = bounds.southWest.longitude;
  var lat2 = bounds.northEast.latitude;
  var lng2 = bounds.northEast.longitude;
  var querybound = '($lat1,$lng1,$lat2,$lng2)';
  for (var i = 0; i < choice.length; i++) {
    if (choice[i] == "polyline") {
      var uri = Uri.parse(
          "https://overpass-api.de/api/interpreter?data=[out:json];(way[$key='$value']$querybound;>;);out;");
      var responseData = await http.get(uri);
      var data = jsonDecode(responseData.body);
      for (var i = 0; i < data['elements'].length; i++) {
        var e = data["elements"][i];
        var type = e['type'];
        if (type != "way" && type != "node") {
          continue;
        }
        typeDict[e['type']][e['id']] = e;
      }
      for (var wayId in typeDict['way'].keys) {
        var way = typeDict['way'][wayId];
        List<LatLng> latLngs = [];
        for (var n in way['nodes']) {
          var node = typeDict['node'][n];
          latLngs.add(LatLng(node["lat"], node["lon"]));
        }
        statefulMapController.addLine(
          name: wayId.toString(),
          points: latLngs,
          width: prefs.getDouble("polylineWidth") ?? 2.0,
          color: Color(prefs.getInt("polylineColor") ?? 0xFFFFFF00),
        );
      }
    } else if (choice[i] == "polygon") {
      var uri = Uri.parse(
          "https://overpass-api.de/api/interpreter?data=[out:json];(way[$key='$value']$querybound;>;);out;");
      var responseData = await http.get(uri);
      var data = jsonDecode(responseData.body);
      for (var i = 0; i < data['elements'].length; i++) {
        var e = data["elements"][i];
        var type = e['type'];
        if (type != "way" && type != "node") {
          continue;
        }
        typeDict[e['type']][e['id']] = e;
      }
      for (var wayId in typeDict['way'].keys) {
        var way = typeDict['way'][wayId];
        List<LatLng> latLngs = [];
        for (var n in way['nodes']) {
          var node = typeDict['node'][n];
          latLngs.add(LatLng(node["lat"], node["lon"]));
        }
        statefulMapController.addPolygon(
          name: wayId.toString(),
          points: latLngs,
          borderWidth: prefs.getDouble("polygonWidth") ?? 1.0,
          color: Color(prefs.getInt("polyfillColor") ?? 0xFFFFFF00),
          borderColor: Color(prefs.getInt("polyborderColor") ?? 0xFFFFFF00),
        );
      }
    } else if (choice[i] == "point") {
      var uri = Uri.parse(
          "https://overpass-api.de/api/interpreter?data=[out:json];node$querybound['$key'='$value'];out;");
      var responseData = await http.get(uri);
      var data = jsonDecode(responseData.body);
      data['elements'].forEach((e) => {
            if (e["type"] == "node")
              {
                statefulMapController.addMarker(
                  name: e["lat"].toString(),
                  marker: Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(e["lat"], e["lon"]),
                    builder: (ctx) => Container(
                      child: Icon(
                        Icons.location_on,
                        color: Color(prefs.getInt("markerColor") ?? 0xFFFFFF00),
                      ),
                    ),
                  ),
                ),
              }
          });
    }
  }
}
