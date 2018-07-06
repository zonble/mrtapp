import 'package:flutter/material.dart';
import 'package:mrtlib/mrtlib.dart' as mrt;
import 'dart:async';

class StationListPage extends StatefulWidget {
  StationListPage({Key key, this.stations, this.title}) : super(key: key);
  String title;
  Map<String, mrt.MRTExit> stations;
  StreamController _didSelectController = new StreamController.broadcast();

  Stream get didSelect => _didSelectController.stream;

  @override
  _StationListPageState createState() => new _StationListPageState();
}

class _StationListPageState extends State<StationListPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(this.widget.title),
        ),
        body: ListView.builder(
            itemCount: this.widget.stations.keys.length,
            itemBuilder: (BuildContext context, int index) {
              var station = this.widget.stations.keys.toList()[index];
              return new ListTile(
                title: new Text(station),
                onTap: () {
                  // print('test');
                  this.widget._didSelectController.add(station);
                  Navigator.pop(context);
                },
              );
            }));
  }
}
