import 'package:animation_wrappers/animations/faded_scale_animation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../../../Themes/colors.dart';
import '../../data/models/deal.dart';

class DealBox extends StatefulWidget {
  final Deal deal;
  const DealBox({Key? key, required this.deal}) : super(key: key);

  @override
  State<DealBox> createState() => _DealBoxState();
}

class _DealBoxState extends State<DealBox> {
  bool copyClicked = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListTile(
          title: Text(
            widget.deal.title,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(widget.deal.description,
              style: Theme.of(context).textTheme.caption!.copyWith(
                  fontSize: 10.0, color: Theme.of(context).hintColor)),
          trailing: FittedBox(
            child: Row(
              children: [
                RotatedBox(
                    quarterTurns: 1,
                    child: Text('---------',
                        style: TextStyle(color: Colors.grey[200]))),
                const SizedBox(
                  width: 5.0,
                ),
                FadedScaleAnimation(
                  child: InkWell(
                    onTap: () {
                        Clipboard.setData(ClipboardData(text: widget.deal.promoCode));
                        const snackBar = SnackBar(
                            content: Text('Promocode copied!'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        // setState(() {
                        //   copyClicked = true;
                        // });
                    },
                    child: Text(widget.deal.promoCode,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: kMainColor)),
                  ),
                  fadeDuration: const Duration(milliseconds: 800),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}