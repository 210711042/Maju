import 'package:flutter/material.dart';

class MajuBasicTile extends StatelessWidget {
  const MajuBasicTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        width: double.infinity,
        child: Column(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 24.0,
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  Expanded(child: Text(title))
                ],
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
          ],
        ));
  }
}
