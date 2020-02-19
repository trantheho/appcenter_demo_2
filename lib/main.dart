import 'package:appcenter_analytics/appcenter_analytics.dart';
import 'package:appcenter_crashes/appcenter_crashes.dart';
import 'package:flutter/material.dart';
import 'package:appcenter/appcenter.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/foundation.dart' show TargetPlatform;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final ios = defaultTargetPlatform == TargetPlatform.iOS;
  String appSecret = ios
      ? "4af58ac7-a735-4d00-87c1-59c884131ae6"
      : "4f45857b-fe61-47c3-936c-108ae6312b31";

  await AppCenter.start(appSecret, [AppCenterAnalytics.id, AppCenterCrashes.id]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _installId = 'Unknown';
  bool _areAnalyticsEnabled = false, _areCrashesEnabled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    if(!mounted) return;

    var installId = await AppCenter.installId;
    var areAnalyticsEnabled = await AppCenterAnalytics.isEnabled;
    var areCrashesEnabled = await AppCenterCrashes.isEnabled;

    setState(() {
      _installId = installId;
      _areAnalyticsEnabled = areAnalyticsEnabled;
      _areCrashesEnabled = areCrashesEnabled;
    });
  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('AppCenter demo'),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('Install identifier \n $_installId'),
          Text('Analytics: $_areAnalyticsEnabled'),
          Text('Crashes: $_areCrashesEnabled'),

          RaisedButton(
            child: Text('Generate test crash'),
            onPressed: (){
              AppCenterCrashes.generateTestCrash();
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Send events'),
                IconButton(
                  icon: Icon(Icons.map),
                  tooltip: 'map',
                  onPressed: (){
                    AppCenterAnalytics.trackEvent("map");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.casino),
                  tooltip: 'casino',
                  onPressed: (){
                    AppCenterAnalytics.trackEvent("casino", {"dolar":"10"});
                  },
                )
              ],
          )
        ],
      ),
    );
  }
}
