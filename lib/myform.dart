import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'overpass.dart';

class Myform extends StatefulWidget {
  final statefulMapController;
  const Myform(
      {Key key,
      @required this.statefulMapController})
      : super(key: key);

  @override
  _MyformState createState() =>
      _MyformState(statefulMapController);
}

class _MyformState extends State<Myform> {
  final statefulMapController;
  _MyformState(this.statefulMapController);
  final _formKey = GlobalKey<FormBuilderState>();
  List keyOptions = ["amenity", "highway", "building"];
  List valueOptions = ["Select key first"];
  List amenityOptions = [
    "bar",
    "restaurant",
    "college",
    "library",
    "school",
    "university",
    "atm",
    "bank",
    "clinic",
    "hospital",
    "pharmacy",
    "nursing_home",
    "cinema",
    "embassy",
    "fire_station",
    "police",
    "post_office",
    "toilets"
  ];
  List highwayOptions = [
    "motorway",
    "trunk",
    "primary",
    "secondary",
    "tertiary",
    "unclassified",
    "residential",
    "pedestrian",
    "footway",
    "path",
    "bus_stop"
  ];
  List buildingOptions = [
    "yes",
    "apartments",
    "bungalow",
    "hotel",
    "house",
    "residential",
    "commercial",
    "supermarket",
    "school",
    "religious",
    "hospital",
    "government",
    "college"
  ];

  void handleChange(ctx) {
    _formKey.currentState.fields["Value"].reset();
    if (ctx == "amenity") {
      setState(() {
        valueOptions = amenityOptions;
      });
    } else if (ctx == "building") {
      setState(() {
        valueOptions = buildingOptions;
      });
    } else {
      setState(() {
        valueOptions = highwayOptions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // return object of type Dialog
    return AlertDialog(
      title: new Text("Overpass Query"),
      content: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FormBuilderDropdown(
              name: 'Key',
              decoration: InputDecoration(
                labelText: 'Key',
              ),
              onChanged: handleChange,
              allowClear: true,
              hint: Text('Select Key'),
              items: keyOptions
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text('$gender'),
                      ))
                  .toList(),
            ),
            FormBuilderDropdown(
              name: 'Value',
              decoration: InputDecoration(
                labelText: 'Value',
              ),
              // initialValue: 'Male',
              allowClear: true,
              hint: Text('Select Value'),
              items: valueOptions
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text('$gender'),
                      ))
                  .toList(),
            ),
            FormBuilderFilterChip(
              name: "choice",
              initialValue: ['point'],
              selectedColor: Colors.blueGrey,
              showCheckmark: false,
              decoration: InputDecoration(
                labelText: 'Select options',
              ),
              options: [
                FormBuilderFieldOption(value: 'point', child: Text('Point')),
                FormBuilderFieldOption(
                    value: 'polyline', child: Text('Polyline')),
                FormBuilderFieldOption(
                    value: 'polygon', child: Text('Polygon')),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        new ElevatedButton(
          child: new Text("Query"),
          onPressed: () {
            _formKey.currentState.save();
            var formValue = _formKey.currentState.value;
            overpassquery(statefulMapController,
                formValue["Key"], formValue["Value"], formValue["choice"]);
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
  }
}
