import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class QuerySetting extends StatefulWidget {
  const QuerySetting({Key key}) : super(key: key);

  @override
  _QuerySettingState createState() => _QuerySettingState();
}

class _QuerySettingState extends State<QuerySetting> {
  final formKeySetting = GlobalKey<FormBuilderState>();
  Color currentMarkerColor = Colors.limeAccent;
  Color currentPolylineColor = Colors.lightBlue;
  Color currentPolyfillColor = Colors.amber;
  Color currentPolyborderColor = Colors.black;
  double polylineWidth = 2.0;
  double polygonWidth = 1.0;
  @override
  void initState() {
    super.initState();
    setValue();
  }

  setValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentMarkerColor = Color(prefs.getInt("markerColor") ?? 0xFFFFFF00);
      currentPolylineColor = Color(prefs.getInt("polylineColor") ?? 0xFFFFFF00);
      currentPolyfillColor = Color(prefs.getInt("polyfillColor") ?? 0xFFFFFF00);
      currentPolyborderColor =
          Color(prefs.getInt("polyborderColor") ?? 0xFFFFFF00);
      polylineWidth = prefs.getDouble("polylineWidth") ?? 5.0;
      polygonWidth = prefs.getDouble("polygonWidth") ?? 1.0;
    });
  }

  void changeMarkerColor(Color color) async {
    setState(() => currentMarkerColor = color);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("markerColor", color.value);
  }

  void changePolylineColor(Color color) async {
    setState(() => currentPolylineColor = color);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("polylineColor", color.value);
  }

  void changePolyfillColor(Color color) async {
    setState(() => currentPolyfillColor = color);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("polyfillColor", color.value);
  }

  void changePolyborderColor(Color color) async {
    setState(() => currentPolyborderColor = color);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("polyborderColor", color.value);
  }

  void changePolylineWidth(double width) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("polylineWidth", width);
  }

  void changePolygonWidth(double width) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("polygonWidth", width);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: formKeySetting,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                      child: Text(
                        'Point',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Marker Color"),
                    ColorPicker(
                      pickerColor: currentMarkerColor,
                      onColorChanged: changeMarkerColor,
                      pickerAreaHeightPercent: 0.7,
                      paletteType: PaletteType.hsv,
                      pickerAreaBorderRadius: const BorderRadius.only(
                        topLeft: const Radius.circular(2.0),
                        topRight: const Radius.circular(2.0),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                      child: Text(
                        'Polyline',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    FormBuilderSlider(
                      name: "PolylineWidth",
                      initialValue: polylineWidth,
                      onChangeEnd: changePolylineWidth,
                      decoration: InputDecoration(
                        labelText: 'Polyline Width',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      min: 1.0,
                      max: 10.0,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Polyline Color"),
                    ColorPicker(
                      pickerColor: currentPolylineColor,
                      onColorChanged: changePolylineColor,
                      colorPickerWidth: 300.0,
                      pickerAreaHeightPercent: 0.7,
                      enableAlpha: true,
                      displayThumbColor: true,
                      showLabel: true,
                      paletteType: PaletteType.hsv,
                      pickerAreaBorderRadius: const BorderRadius.only(
                        topLeft: const Radius.circular(2.0),
                        topRight: const Radius.circular(2.0),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                      child: Text(
                        'Polygon',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FormBuilderSlider(
                      name: "PolygonBorderWidth",
                      initialValue: polygonWidth,
                      onChangeEnd: changePolygonWidth,
                      decoration: InputDecoration(
                        labelText: 'Polygon BorderWidth',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      min: 1.0,
                      max: 10.0,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Polygon Fill Color"),
                    ColorPicker(
                      pickerColor: currentPolyfillColor,
                      onColorChanged: changePolyfillColor,
                      colorPickerWidth: 300.0,
                      pickerAreaHeightPercent: 0.7,
                      enableAlpha: true,
                      displayThumbColor: true,
                      showLabel: true,
                      paletteType: PaletteType.hsv,
                      pickerAreaBorderRadius: const BorderRadius.only(
                        topLeft: const Radius.circular(2.0),
                        topRight: const Radius.circular(2.0),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Polygon Border Color"),
                    ColorPicker(
                      pickerColor: currentPolyborderColor,
                      onColorChanged: changePolyborderColor,
                      colorPickerWidth: 300.0,
                      pickerAreaHeightPercent: 0.7,
                      enableAlpha: true,
                      displayThumbColor: true,
                      showLabel: true,
                      paletteType: PaletteType.hsv,
                      pickerAreaBorderRadius: const BorderRadius.only(
                        topLeft: const Radius.circular(2.0),
                        topRight: const Radius.circular(2.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
