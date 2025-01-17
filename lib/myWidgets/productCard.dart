import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:store_manager/globals.dart';
import '../myAnimations/fadeAnimation.dart';

class ProductCard extends StatefulWidget {
  final int id;
  final String title;
  final String subtitle;
  final int quantity;
  final int price;
  final image;
  final int lang;

  const ProductCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.quantity,
    Key? key,
    required this.image,
    required this.id,
    required this.lang,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<ProductCard> createState() => ProductCardState(
        id: id,
        title: title,
        subtitle: subtitle,
        price: price,
        quantity: quantity,
        image: image,
        lang: lang,
      );
}

class ProductCardState extends State<ProductCard> {
  final int id;
  final String title;
  final String subtitle;
  int quantity;
  final int price;
  final image;
  final int lang;

  ProductCardState({
    required this.lang,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.quantity,
    required this.image,
    Key? key,
  });

  TextEditingController quantityController = TextEditingController(text: '0');
  @override
  void initState() {
    quantityController.text = quantity.toString();
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
  Global global = Global();
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
                caption: lang == 1 ? 'Delete' : "حذف",
                color: Colors.red,
                icon: Icons.delete,
                onTap: () async {
                  await global.databaseHelper.deleteProduct(productID: id.toString());
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
                        borderRadius: BorderRadius.circular(500),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          height: MediaQuery.of(context).size.height,
                          child: Image.network(
                            'http://vzzoz.pythonanywhere.com$image',
                            fit: BoxFit.fill,
                          ),
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
                            Text(lang == 1 ? 'Quantity' : "الكمية"),
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
                        ? () async {
                            await global.databaseHelper.addProductQuantity(
                                productID: id.toString(),
                                quantity: quantityController.text);
                            setState(() {
                              _ispressed = false;
                            });
                          }
                        : null,
                    child: Text(lang == 1 ? "Finish" : "إنهاء"),
                  ))
              : Container()
        ],
      ),
    );
  }
}
