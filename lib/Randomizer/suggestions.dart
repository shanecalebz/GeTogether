import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:location/location.dart' as UserLocation;

class Suggestions extends StatefulWidget {

  int selectionIndex;

  Suggestions({required this.selectionIndex});

  @override
  _SuggestionsState createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {

  List<bool> dataRetrievedTicked = [];
  UserLocation.Location location = new UserLocation.Location();
  bool dataRetrieved = false;
  bool locationEnabled = false;
  late var result;
  String tempString = "";
  late int count;
  late bool serviceEnabled;
  late UserLocation.PermissionStatus permissionGranted;
  late UserLocation.LocationData locationData;

  Future<void> getUserLocationPermission() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (serviceEnabled) {
        setState(() {
          locationEnabled = true;
        });
      }
    } else {
      setState(() {
        locationEnabled = true;
      });
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == UserLocation.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted == UserLocation.PermissionStatus.granted) {
        setState(() {
          locationEnabled = true;
        });
      }
    } else {
      setState(() {
        locationEnabled = true;
      });
    }

    if (locationEnabled == true) {
      locationData = await location.getLocation();
      var googlePlace = GooglePlace("AIzaSyDlkhl0ZevCCvzpXr_w9xyEvSJQ_gF13CQ");

      if (widget.selectionIndex == 0) {
        // "What to Do" selected
        result = await googlePlace.search.getNearBySearch(
            Location(lat: locationData.latitude, lng: locationData.longitude), 0, rankby: RankBy.Distance,
            type: "tourist_attraction", keyword: "");
      } else {
        // "What to Eat" selected
        result = await googlePlace.search.getNearBySearch(
            Location(lat: locationData.latitude, lng: locationData.longitude), 0, rankby: RankBy.Distance,
            type: "restaurant", keyword: "");
      }

      // DATA RETRIEVED TICK
      dataRetrievedTicked.clear();
      for (int i = 0; i < result.results.length; i++) {
        dataRetrievedTicked.add(false);
      }
    }
    setState(() {
      dataRetrieved = true;
    });
  }

  Widget printRatings(index) {
    if (result.results[index].userRatingsTotal != null) {
      if (result.results[index].rating == null) {
        return Row(
          children: [
            Padding(
                padding: EdgeInsets.only(right: 3.0),
                child: Text(
                  "0.0",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey[700],
                  ),
                )
            ),
            RatingBar.builder(
              itemSize: 15.0,
              ignoreGestures: true,
              initialRating: 0.0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {},
            ),
          ],
        );
      } else {
        return Row(
          children: [
            Padding(
                padding: EdgeInsets.only(right: 3.0),
                child: Text(
                  result.results[index].rating.toString(),
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey[700],
                  ),
                )
            ),
            RatingBar.builder(
              itemSize: 15.0,
              ignoreGestures: true,
              initialRating: result.results[index].rating,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {},
            ),
          ],
        );
      }
    } else {
      return Text(
        "No reviews yet",
        style: TextStyle(
          fontSize: 15.0,
          color: Colors.grey[700],
        ),
      );
    }
  }

  Widget printType(index) {
    if (result.results[index].types.isNotEmpty) {
      if (result.results[index].types.contains("meal_delivery") && result.results[index].types.contains("meal_takeaway")) {
        return Text(
          "Delivery & Takeaway only",
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.grey[700],
          ),
        );
      } else if (result.results[index].types.contains("meal_delivery")){
        return Text(
          "Delivery only",
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.grey[700],
          ),
        );
      } else if (result.results[index].types.contains("meal_takeaway")) {
        return Text(
          "Takeaway only",
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.grey[700],
          ),
        );
      } else {
        return Text(
          result.results[index].types[0][0].toUpperCase() + result.results[index].types[0].substring(1).toLowerCase().replaceAll('_', ' '),
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.grey[700],
          ),
        );
      }
    } else {
      return Container();
    }
  }

  Widget printPriceLevel(index) {
    if (result.results[index].priceLevel != null) {
      return Row(
        children: [
          for (int i = 0; i < result.results[index].priceLevel; i++)
            Text(
              "\$",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.grey[700],
              ),
            )
          ,
          Padding(
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            child: Text(
              "\u2022",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget buildWidget() {
    if (locationEnabled == false && dataRetrieved == false) {
      return Padding(
          padding: EdgeInsets.only(top: 100.0),
          child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: CupertinoActivityIndicator(
                        animating: true,
                        radius: 10.0
                    ),
                  ),
                  Text(
                    "Getting location permissions...",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
          )
      );
    } else if (locationEnabled == false && dataRetrieved == true) {
      return Padding(
          padding: EdgeInsets.only(top: 100.0),
          child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 30.0,
                    ),
                  ),
                  Text(
                    "Location permissions not granted!",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
          )
      );
    } else if (locationEnabled == true && dataRetrieved == false) {
      return Padding(
          padding: EdgeInsets.only(top: 100.0),
          child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: CupertinoActivityIndicator(
                        animating: true,
                        radius: 10.0
                    ),
                  ),
                  Text(
                    "Getting nearby suggestions...",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
          )
      );
    } else {
      return Flexible(
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: result.results.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    if (index == 0)
                      Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
                        child: Container(
                          width: double.infinity,
                          height: 60.0,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.all(Radius.circular(15.0))
                          ),
                          child: Center(
                            child: Text(
                              "Suggestions Near Me",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.all(Radius.circular(15.0))
                                    ),
                                    child: Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              result.results[index].name,
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              result.results[index].vicinity,
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            printRatings(index),
                                            Row(
                                              children: [
                                                printPriceLevel(index),
                                                printType(index),
                                              ],
                                            )
                                          ],
                                        )
                                    )
                                )
                            ),
                            Checkbox(
                              value: dataRetrievedTicked[index],
                              onChanged: (value) {
                                setState(() {
                                  if (dataRetrievedTicked[index] == false) {
                                    dataRetrievedTicked[index] = true;
                                  } else {
                                    dataRetrievedTicked[index] = false;
                                  }
                                });
                              },
                            ),
                          ],
                        )
                    )
                  ],
                );
              }
          )
      );
    }
  }

  Widget buildButton() {
    if (locationEnabled == true && dataRetrieved == true) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              count = 0;
              tempString = "";
              for (int i = 0; i < result.results.length; i++) {
                if (dataRetrievedTicked[i] == true) {
                  if (count == 0) {
                    tempString += result.results[i].name;
                  } else {
                    tempString += "," + result.results[i].name;
                  }
                  count++;
                }
              }
              Navigator.of(context).pop(tempString);
            },
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(15.0))
              ),
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "GO!",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    getUserLocationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 80.0, bottom: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(15.0))
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 24.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            buildWidget(),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: buildButton(),
            ),
          ],
        ),
      ),
    );
  }
}