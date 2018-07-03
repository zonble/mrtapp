import 'package:flutter/material.dart';
import 'package:mrtlib/mrtlib.dart' as mrt;

class RouteListPage extends StatefulWidget {
  RouteListPage({Key key, this.route, this.title}) : super(key: key);
  String title;
  mrt.MRTRoute route;

  @override
  _RouteListPageState createState() => new _RouteListPageState();
}

class _RouteListPageState extends State<RouteListPage> {
  @override
  Widget build(BuildContext context) {
    var displayName = {
      "1": "文湖線",
      "2": "淡水信義線",
      "3": "松山新店線",
      "4": "中和新蘆線",
      "5": "板南線",
    };

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(this.widget.title ?? ''),
        ),
        body: ListView.builder(
            itemCount: this.widget.route.links.length,
            itemBuilder: (BuildContext context, int index) {
              final links = this.widget.route.links;
              final link = links[index];
              return new Padding(
                  padding: EdgeInsets.all(20.0),
                  child: new Text(
                      '${link.to.name} (${displayName[link.routeID]})'));
            }));
  }
}
