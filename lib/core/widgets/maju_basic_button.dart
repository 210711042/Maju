import 'package:flutter/material.dart';
import 'package:maju/themes/palette.dart';

class MajuBasicButton extends StatelessWidget {
  const MajuBasicButton({
    Key? key,
    required this.textButton,
    required this.onPressed,
    this.icon,
    this.iconGap = 4.0,
    this.btnHeight = 48.0,
    this.btnWidth = double.infinity,
    this.style,
  }) : super(key: key);

  final String textButton;
  final VoidCallback? onPressed;
  final Widget? icon;
  final double iconGap;
  final double btnHeight;
  final double btnWidth;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: btnWidth,
      height: btnHeight,
      child: ElevatedButton(
        style: style ??
            ElevatedButton.styleFrom(
                backgroundColor: Palette.n900,
                foregroundColor: Palette.n50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                textStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              SizedBox(width: iconGap),
            ],
            Text(textButton),
          ],
        ),
      ),
    );
  }
}
