import 'package:animation_wrappers/animations/faded_scale_animation.dart';
import 'package:flutter/material.dart';
import 'package:renterii/shops/data/models/product.dart';

class QuantityToggle extends StatefulWidget {
  QuantityToggle(
      {Key? key,
      required this.quantity,
      this.ref,
      required this.count,
      required this.product})
      : super(key: key);
  int quantity;
  final dynamic ref;
  final Product product;
  ValueSetter<int> count;
  @override
  State<QuantityToggle> createState() => _QuantityToggleState();
}

class _QuantityToggleState extends State<QuantityToggle> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.035,
        width: MediaQuery.of(context).size.width * 0.22,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.grey[400]!)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                if (widget.quantity > 0) {
                  setState(() {
                    widget.quantity--;
                  });
                  widget.count(widget.quantity);
                }
              },
              child: const Icon(Icons.remove),
            ),
            Text("${widget.quantity}"),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.quantity++;
                });
                widget.count(widget.quantity);
              },
              child: const Icon(Icons.add),
            ),
          ],
        ));
  }
}

class ProductWidget extends StatefulWidget {
  ProductWidget({
    Key? key,
    required this.product,
    this.quantity = 0,
    required this.count,
  }) : super(key: key);
  final Product product;
  int quantity;
  ValueSetter<int> count;
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Container(
          height: MediaQuery.of(context).size.width * 0.2,
          width: MediaQuery.of(context).size.width * 0.2,
          child: FadedScaleAnimation(
            child: Image.network(
              widget.product.imageUrl,
              scale: 3,
            ),
            fadeDuration: const Duration(milliseconds: 800),
          ),
        ),
        title: Text(widget.product.title,
            //AppLocalizations.of(context)!.sandwich!,
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(fontSize: 15, fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FadedScaleAnimation(
                    child: Image.asset(
                      'images/ic_pink.png',
                      height: 16.0,
                      width: 16.7,
                    ),
                    fadeDuration: const Duration(milliseconds: 800),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(widget.product.rentalDuration,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontSize: 14)),
                ],
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text('\$ ${widget.product.price}',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 14)),
            ],
          ),
        ),
        trailing: QuantityToggle(
            quantity: widget.quantity,
            count: widget.count,
            product: widget.product));
  }
}
