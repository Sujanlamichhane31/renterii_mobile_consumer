import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/shops/business_logic/cubit/cubit/deals_cubit.dart';
import 'package:renterii/shops/data/models/deal.dart';
import 'package:flutter/services.dart';

import '../widgets/deal_box.dart';

class DealsScreen extends StatefulWidget {
  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<DealsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(AppLocalizations.of(context)!.deals!,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(fontWeight: FontWeight.bold)),
        actions: [
          Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              "Tap to Copy",
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ))
        ],
      ),
      body: FadedSlideAnimation(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: BlocBuilder<DealsCubit, DealsState>(
            builder: (context, state) {
              if(state is DealsLoaded) {
                final List<Widget> dealsPaddings = [];
                for(Deal deal in state.deals) {
                  dealsPaddings.add(DealBox(deal: deal,));
                }
                return ListView(
                children: [
                  ...dealsPaddings
                ],
              );
              }else if(state is DealsInitial){
                return ListView(
                children: const [],
              );
              }
              return Container();
            },
          ),
        ),
        beginOffset: Offset(0.0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }

  Padding buildOfferTile(BuildContext context, Deal deal) {
    bool copyClicked = false;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListTile(
          title: Text(
            deal.title,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(deal.description,
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
                        Clipboard.setData(ClipboardData(text: deal.promoCode));
                        
                        setState(() {
                          copyClicked = true;
                        });
                    },
                    child: Text(!copyClicked? deal.promoCode: 'Rent!',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: kMainColor)),
                  ),
                  fadeDuration: Duration(milliseconds: 800),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
