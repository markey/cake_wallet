import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';

class TemplateTile extends StatelessWidget {
  TemplateTile({
    @required this.name,
    @required this.amount,
    @required this.cryptoCurrency,
    @required this.onTap
  });

  final String name;
  final String amount;
  final String cryptoCurrency;
  final VoidCallback onTap;

  final toIcon = Image.asset('assets/images/to_icon.png');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          padding: EdgeInsets.only(left: 24, right: 24),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: PaletteDark.menuList
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                amount,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  cryptoCurrency,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: toIcon,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}