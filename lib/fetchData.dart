import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// class FetchData {
  // // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   // Configure BackgroundFetch.
  //   BackgroundFetch.configure(BackgroundFetchConfig(
  //       minimumFetchInterval: 15,
  //       stopOnTerminate: false,
  //       enableHeadless: true
  //   ), () async {
  //     // This is the fetch-event callback.
  //     print('[BackgroundFetch] Event received');
  //     // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
  //     // for taking too long in the background.
  //     BackgroundFetch.finish();
  //   }).then((int status) {
  //     print('[BackgroundFetch] SUCCESS: $status');

  //   }).catchError((e) {
  //     print('[BackgroundFetch] ERROR: $e');
  //   });

  //   // Optionally query the current BackgroundFetch status.
  //   // int status = await BackgroundFetch.status;
  // }
// }

Future<Contests> liveContests = fetchContests("start", DateTime.now().toString(), "start");
Future<Contests> completedContests = fetchContests("start__lt", DateTime.now().toString(), "end");
Future<Contests> upcomingContests = fetchContests("start__gt", DateTime.now().toString(), "start");

Future<Contests> fetchContests(String param, String today, String orderBy) async {
  var uri;
  if(orderBy == "end"){
    uri = Uri.https("clist.by", "/api/v1/contest/",{"username":"vikasgola2015","api_key":"6c30bec036ad99b28c94e98fb584ab880efb04b6", param: today, "order_by":orderBy, "limit":"1000", 'start__gt':DateTime(DateTime.now().year, DateTime.now().month-1, DateTime.now().day).toString()});
  }else{
    uri = Uri.https("clist.by", "/api/v1/contest/",{"username":"vikasgola2015","api_key":"6c30bec036ad99b28c94e98fb584ab880efb04b6", param: today, "order_by":orderBy, "limit":"1000"});
  }

  final response =
      await http.get(uri);

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    return Contests.fromJSON(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

class Contests {
  List<Contest> contests = [];

  Contests.fromJSON(Map<String, dynamic> json) {
    for (var contestjson in json['objects']) {
      var contest = Contest.fromJSON(contestjson);
        this.contests.add(contest);
    }
  }
}

class Contest {
  int id;
  String resource;
  String event;
  DateTime start;
  DateTime end;
  int duration;
  String href;

  Contest({
    this.id,
    this.resource,
    this.event,
    this.start,
    this.end,
    this.duration,
    this.href,
  });

  String a = "!@";

  factory Contest.fromJSON(Map<String, dynamic> json) {
    return Contest(
      id: json['id'],
      event: json['event'],
      resource: json['resource']['name'],
      start: DateTime.parse(json['start'].replaceAll(new RegExp('-'), '').replaceAll(new RegExp(':'), '')),
      end: DateTime.parse(json['end'].replaceAll(new RegExp('-'), '').replaceAll(new RegExp(':'), '')),
      duration: json['duration'],
      href: json['href'],
    );
  }
}
