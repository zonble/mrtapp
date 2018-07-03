import 'package:flutter/material.dart';
import 'package:mrtlib/mrtlib.dart' as mrt;
import 'station_list.dart';
import 'route_list_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '捷運轉乘',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(title: '捷運轉乘'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String from;
  String to;
  String errorMessage;
  mrt.MRTRoute shortestRoute;
  mrt.MRTRoute longestRoute;
  mrt.MRTMap map = new mrt.MRTMap();

  @override
  void initState() {
    this.buildRoutes();
  }

  buildRoutes() {
    this.errorMessage = null;
    this.shortestRoute = null;
    this.longestRoute = null;

    if (this.from == null && this.to == null) {
      this.errorMessage = '尚未選擇起點與終點';
      return;
    }
    if (this.from == null) {
      this.errorMessage = '尚未選擇起點';
      return;
    }
    if (this.to == null) {
      this.errorMessage = '尚未選擇終點';
      return;
    }
    if (this.from == this.to) {
      this.errorMessage = '起點與終點不可相同';
      return;
    }
    final routes = this.map.findRoutes(this.from, this.to);
    this.shortestRoute = routes.first;
    this.longestRoute = routes.last;
  }

  selectFrom(BuildContext context) {
    final widget = new StationListPage(
      title: '請選擇起點站',
      stations: this.map.exits,
    );
    widget.didSelect.listen((station) {
      this.setState(() {
        this.from = station;
        buildRoutes();
      });
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  selectTo(BuildContext context) {
    final widget = new StationListPage(
      title: '請選擇終點站',
      stations: this.map.exits,
    );
    widget.didSelect.listen((station) {
      this.setState(() {
        this.to = station;
        buildRoutes();
      });
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  pushShortest(BuildContext context) {
    final widget = new RouteListPage(
      title: '最短路徑',
      route: this.shortestRoute,
    );
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  pushLongest(BuildContext context) {
    final widget = new RouteListPage(
      title: '最長路徑',
      route: this.longestRoute,
    );
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> body = <Widget>[
      new Padding(
        child: new Text(
          '請選擇起點',
          style: Theme.of(context).textTheme.title,
        ),
        padding: new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
      ),
      new RaisedButton(
        onPressed: () {
          selectFrom(context);
        },
        color: Theme.of(context).backgroundColor,
        child: new Text(this.from ?? '尚未選定'),
      ),
      new Padding(
        child: new Text(
          '請選擇終點',
          style: Theme.of(context).textTheme.title,
        ),
        padding: new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
      ),
      new RaisedButton(
        onPressed: () {
          selectTo(context);
        },
        color: Theme.of(context).backgroundColor,
        child: new Text(this.to ?? '尚未選定'),
      )
    ];
    if (this.errorMessage != null) {
      body.add(new Padding(
        child: new Text(
          this.errorMessage,
          style: Theme.of(context).textTheme.body1,
        ),
        padding: new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
      ));
    } else if (this.shortestRoute != null && this.longestRoute != null) {
      body.add(new Padding(
          padding: new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
          child: new RaisedButton(
            onPressed: () {
              this.pushShortest(context);
            },
            color: Theme.of(context).backgroundColor,
            child: new Text('顯示最短路徑'),
          )));
      body.add(new RaisedButton(
        onPressed: () {
          this.pushLongest(context);
        },
        color: Theme.of(context).backgroundColor,
        child: new Text('顯示最長路徑'),
      ));
    }

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.start, children: body),
        ));
  }
}
