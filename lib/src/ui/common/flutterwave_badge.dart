import 'package:flutter/material.dart';
import 'package:rave_flutter/src/common/my_colors.dart';

class FlutterwaveBadge extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(3))
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 6, right: 10, top: 12, bottom: 12),
                child: Icon(Icons.lock, color: MyColors.buttercup, size: 10,)
              )
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 6, top: 12, bottom: 12),
                child: Text(
                  'SECURED BY FLUTTERWAVE',
                  style: Theme.of(context).textTheme.button!.copyWith(
                    fontSize: 10,
                    color: MyColors.buttercup
                  ),
                )
              )
            )
          ],
        ),
      ),
    );
  }
  
}