import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../myAnimations/fadeAnimation.dart';

class ProductCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final int quantity;
  final int price;

  const ProductCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.quantity,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<ProductCard> createState() => ProductCardState(
      title: title, subtitle: subtitle, price: price, quantity: quantity);
}

class ProductCardState extends State<ProductCard> {
  final String title;
  final String subtitle;
  int quantity;
  final int price;

  ProductCardState({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.quantity,
    Key? key,
  });

  TextEditingController quantityController = TextEditingController(text: '0');
  @override
  void initState() {
    quantityController.text = quantity.toString();
    // TODO: implement initState
    super.initState();
  }

  bool _isEnabled = false;
  bool _ispressed = false;

  buttonState(bool val) => {setState(() => _isEnabled = val)};
  void _handleTap(String tap) {
    if (quantityController.text == "") {
      quantityController.text = "0";
    } else if (tap == "+") {
      setState(() {
        quantityController.text =
            (int.parse(quantityController.text) + 1).toString();
      });
    } else if (tap == "-" && int.parse(quantityController.text) > 0) {
      setState(() {
        quantityController.text =
            (int.parse(quantityController.text) - 1).toString();
      });
    }

    if (int.parse(quantityController.text) == quantity) {
      buttonState(false);
    } else {
      buttonState(true);
    }
  }

  final dishImage =
      "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/malika%2FRectangle%2013.png?alt=media&token=6a5f056c-417c-48d3-b737-f448e4f13321";

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      2,
      Column(
        children: [
          Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  print('4');
                },
              ),
            ],
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      setState(() {
                        _ispressed = !_ispressed;
                      });
                    },
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          dishImage,
                        )),
                    title: Text(title),
                    subtitle: Text('$subtitle\n$quantity'),
                    trailing: Text('$price\nSDG'),
                    isThreeLine: true,
                  ),
                  _ispressed == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Quantity'),
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () => _handleTap('-'),
                                    child: Text(
                                      "-",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              12),
                                    )),
                                SizedBox(
                                  width: 30,
                                  child: TextField(
                                    controller: quantityController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^[1-9][0-9]*'))
                                    ],
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TextButton(
                                    onPressed: () => _handleTap('+'),
                                    child: Text(
                                      "+",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              18),
                                    )),
                              ],
                            ),
                          ],
                        )
                      : Container()
                ],
              ),
            ),
          ),
          _ispressed == true
              ? Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: TextButton(
                    onPressed: _isEnabled
                        ? () {
                            setState(() {
                              quantity = int.parse(quantityController.text);
                              buttonState(false);
                              _ispressed = false;
                            });
                          }
                        : null,
                    child: Text("Finish"),
                  ))
              : Container()
        ],
      ),
    );
  }
}
