import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CalculateTotalPrice extends StatefulWidget {

  String menu;

  CalculateTotalPrice({required this.menu});

  @override
  _CalculateTotalPriceState createState() => _CalculateTotalPriceState();
}

class _CalculateTotalPriceState extends State<CalculateTotalPrice> {

  double price = 0.0;
  double gst = 0.0;
  double serviceCharge = 0.0;
  double totalPrice = 0.0;
  late int amount;
  late bool itemSelected;
  List<String> amountPerItem = [];
  PanelController panelController = new PanelController();

  @override
  void initState() {
    super.initState();
    for (int i = 1; i < widget.menu.split('-').length; i++) {
      for (int j = 0; j < widget.menu.split('-')[i].split('+').length; j++) {
        amountPerItem.add(i.toString() + "," + j.toString() + "," + widget.menu.split('-')[i].split('+')[j].split('\$')[1] + ",0," + widget.menu.split('-')[i].split('+')[j].split('\$')[0]); // INDEX FOR I, INDEX FOR J, PRICE FOR INDEX, AMOUNT FOR INDEX, ITEM NAME
      }
    }
  }

  void calculatePrice() {
    price = 0.0;
    gst = 0.0;
    serviceCharge = 0.0;
    totalPrice = 0.0;

    for (int i = 0; i < amountPerItem.length; i++) {
      price += double.parse(amountPerItem[i].split(',')[2]) * int.parse(amountPerItem[i].split(',')[3]);
    }

    gst = price * 0.07;
    serviceCharge = price * 0.20;
    totalPrice = price + gst + serviceCharge;
  }

  void removeSelected(indexI, indexJ) {
    for (int i = 0; i < amountPerItem.length; i++) {
      if ((int.parse(amountPerItem[i].split(',')[0]) == indexI) && (int.parse(amountPerItem[i].split(',')[1]) == indexJ)) {
        if (int.parse(amountPerItem[i].split(',')[3]) != 0) {
          setState(() {
            amountPerItem[i] = amountPerItem[i].split(',')[0] + "," + amountPerItem[i].split(',')[1] + "," + amountPerItem[i].split(',')[2] + "," + (int.parse(amountPerItem[i].split(',')[3]) - 1).toString() + "," + amountPerItem[i].split(',')[4];
            calculatePrice();
          });
        }
      }
    }
  }

  void addSelected(indexI, indexJ) {
    for (int i = 0; i < amountPerItem.length; i++) {
      if ((int.parse(amountPerItem[i].split(',')[0]) == indexI) && (int.parse(amountPerItem[i].split(',')[1]) == indexJ)) {
        setState(() {
          amountPerItem[i] = amountPerItem[i].split(',')[0] + "," + amountPerItem[i].split(',')[1] + "," + amountPerItem[i].split(',')[2] + "," + (int.parse(amountPerItem[i].split(',')[3]) + 1).toString() + "," + amountPerItem[i].split(',')[4];
          calculatePrice();
        });
      }
    }
  }

  Widget buildAmount(int i, int j) {

    amount = 0;
    for (String item in amountPerItem) {
      if ((int.parse(item.split(',')[0]) == i) && (int.parse(item.split(',')[1]) == j)) {
        amount = int.parse(item.split(',')[3]);
      }
    }

    return Container(
      padding: EdgeInsets.only(top: 1.5, bottom: 1.5, left: 5.0, right: 5.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(),
          bottom: BorderSide(),
        ),
      ),
      child: Text(
          amount.toString(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.0,
          )
      ),
    );
  }

  Widget buildOrdered() {

    itemSelected = false;
    for (String item in amountPerItem) {
      if (int.parse(item.split(',')[3]) > 0) {
        itemSelected = true;
        break;
      }
    }

    if (itemSelected == true) {
      return Column(
        children: [
          for (String item in amountPerItem)
            if (int.parse(item.split(',')[3]) > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(
                            item.split(',')[3],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            )
                        ),
                      ),
                      Text(
                          item.split(',')[4].substring(item.split(',')[4].indexOf(":") + 1),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          )
                      ),
                    ],
                  ),
                  Text(
                      "\$" + (double.parse(item.split(',')[2]) * int.parse(item.split(',')[3])).toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      )
                  ),
                ],
              )
            else
              Container()
        ],
      );
    } else {
      return Center(
        child: Text(
            "No items selected yet",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
            )
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: panelController,
        isDraggable: false,
        minHeight: 75.0,
        backdropEnabled: true,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        collapsed: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                panelController.open();
              },
              child: SizedBox(
                height: 75.0,
                width: double.infinity,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: Container(
                          height: 4.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius: BorderRadius.all(Radius.circular(24.0)),
                          ),
                          child: Container(),
                        ),
                      ),
                      Text(
                          "Total: \$" + totalPrice.toStringAsFixed(2),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        panel: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 10.0),
                  child: Text(
                      "You Ordered",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: buildOrdered(),
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 8.0),
                  child: Text(
                      "Bill",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                      )
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(Radius.circular(24.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "Price",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                )
                            ),
                            Text(
                                "\$" + price.toStringAsFixed(2),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                )
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "GST (7%)",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                )
                            ),
                            Text(
                                "\$" + gst.toStringAsFixed(2),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                )
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "Service Charge (20%)",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                )
                            ),
                            Text(
                                "\$" + serviceCharge.toStringAsFixed(2),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                )
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 0.5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "Total",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                            Text(
                                "\$" + totalPrice.toStringAsFixed(2),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 80.0, bottom: 30.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Center(
                    child: Text(
                        widget.menu.split('-')[0],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Divider(
                    thickness: 2.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Item",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            )
                        ),
                        Text(
                            "Qty",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            )
                        ),
                      ]
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Column(
                        children: [
                          for (int i = 1; i < widget.menu.split('-').length; i++)
                            for (int j = 0; j < widget.menu.split('-')[i].split('+').length; j++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        widget.menu.split('-')[i].split('+')[j].split('\$')[0].substring(widget.menu.split('-')[i].split('+')[j].split('\$')[0].indexOf(":") + 1),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                        )
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            removeSelected(i, j);
                                          },
                                          child: Container(
                                              padding: EdgeInsets.all(2.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), bottomLeft: Radius.circular(24.0)),
                                              ),
                                              child: Icon(
                                                Icons.remove,
                                                size: 15.0,
                                              )
                                          ),
                                        ),
                                        buildAmount(i, j),
                                        InkWell(
                                          onTap: () {
                                            addSelected(i, j);
                                          },
                                          child: Container(
                                              padding: EdgeInsets.all(2.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(24.0), bottomRight: Radius.circular(24.0)),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 15.0,
                                              )
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45.0,
                ),
              ]
          ),
        ),
      ),
    );
  }
}