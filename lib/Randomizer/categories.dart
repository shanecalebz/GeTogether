import 'package:chat_app/Randomizer/wheel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Categories extends StatefulWidget {

  int selectionIndex;

  Categories({required this.selectionIndex});

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  // FOR EACH CATEGORY, THE CATEGORY NAME WILL BE THE FIRST VARIABLE
  // FOLLOWING ITEMS ARE THE SUB ITEMS FOR THAT CATEGORY
  List<String> eatCategories = [
    "Fast Food,MacDonalds,KFC,Pizza Hut,Long John Silver,Subway,Popeyes,Burger King,Mos Burger,Jollibee,Texas Chicken",
    "Casual Dining,Swensens,Itacho Sushi,Astons,Fish & Co,Din Tai Fung,Crystal Jade Kitchen,Jacks Place,Hai Di Lao / Beauty in a Pot",
    "Contemporary Casual,P.S. Cafe,Pasta Bar,Breadstreet,Birds of a Feather,Le La Vi,Monti,Odette,Candlenutt,Koma,The Summerhouse",
    "Cafes,Starbucks,Coffebean & Tea Leaf,Lady M,Coffee Smith,Dal.komm,La Vie,Arabica",
    "Others"
  ];
  List<String> doCategories = [
    "Sports,Basketball,Soccer,Badminton,Table Tennis,Beach Volleyball,Gym,Spin Class,Running",
    "Gaming,Internet Cafe,Arcade,Playnation,Escape Room,Board Game Cafe,VR Station",
    "Chill,Karaoke,Movie,Picnic,Pottery,Baking,Fishing / Prawning,Visiting & Museum",
    "Recreational,Swimming,Pool / Snooker,Bowling,Darts,Mini-Golf,Night Cycling,Roller Blading,Amusement Park,Paintball,Laser-Tech",
    "Others"
  ];

  Widget buildCategories() {
    if (widget.selectionIndex == 0) {
      // "What to Eat" selected
      return Column(
        children: [
          for (int i = 0; i < eatCategories.length; i++)
            if (i < (eatCategories.length - 1))
              Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, CupertinoPageRoute(builder: (_) => Wheel(selectionIndex: 1, categoryIndex: eatCategories.indexOf(eatCategories[i], 0), categoryList: eatCategories)));
                    },
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    child: Container(
                      width: double.infinity,
                      height: 75.0,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(15.0))
                      ),
                      child: Center(
                        child: Text(
                          eatCategories[i].split(',')[0],
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (_) => Wheel(selectionIndex: 1, categoryIndex: eatCategories.indexOf(eatCategories[i], 0), categoryList: eatCategories)));
                  },
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  child: Container(
                    width: double.infinity,
                    height: 75.0,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(15.0))
                    ),
                    child: Center(
                      child: Text(
                        eatCategories[i].split(',')[0],
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              )
        ],
      );
    } else {
      // "What to Do" selected
      return Column(
        children: [
          for (int i = 0; i < doCategories.length; i++)
            if (i < (doCategories.length - 1))
              Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, CupertinoPageRoute(builder: (_) => Wheel(selectionIndex: 0, categoryIndex: doCategories.indexOf(doCategories[i], 0), categoryList: doCategories)));
                    },
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    child: Container(
                      width: double.infinity,
                      height: 75.0,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(15.0))
                      ),
                      child: Center(
                        child: Text(
                          doCategories[i].split(',')[0],
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (_) => Wheel(selectionIndex: 0, categoryIndex: doCategories.indexOf(doCategories[i], 0), categoryList: doCategories)));
                  },
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  child: Container(
                    width: double.infinity,
                    height: 75.0,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(15.0))
                    ),
                    child: Center(
                      child: Text(
                        doCategories[i].split(',')[0],
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 80.0, bottom: 30.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
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
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: buildCategories(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}