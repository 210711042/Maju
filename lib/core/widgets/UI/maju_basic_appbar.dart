import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maju/themes/palette.dart';

class MajuBasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MajuBasicAppBar(
      {super.key,
      this.title = "Maju",
      this.actions,
      this.backSupport = true,
      this.leadingSupport = false});

  final String title;
  final List<Widget>? actions;
  final bool backSupport;
  final bool leadingSupport;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: leadingSupport,
      iconTheme: const IconThemeData(color: Palette.n900),
      shadowColor: Palette.n0.withOpacity(0.5),
      elevation: 0,
      leading: leadingSupport
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Palette.n600,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : null,
      leadingWidth: 24.0,
      title: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                width: 200,
                height: 32,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 0.5, color: Palette.n600)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search,
                        size: 16.0,
                        color: Palette.n600,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: TextField(
                          style: const TextStyle(fontSize: 12.0),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none, // Remove the border
                            ),
                            contentPadding: const EdgeInsets.all(0),
                            hintText: title,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none, // Remove the border
                            ),
                            focusColor: Colors.black,
                          ),
                          cursorColor: Palette.n900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 16.0,
            ),
            SvgPicture.asset("assets/icons/shopping_cart.svg"),
            const SizedBox(
              width: 16.0,
            ),
            SvgPicture.asset("assets/icons/menu.svg"),
            const SizedBox(
              width: 16.0,
            )
          ],
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

class MajuProductAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MajuProductAppBar(
      {super.key,
      this.title = "Maju",
      this.actions,
      this.backSupport = true,
      this.leadingSupport = false});

  final String title;
  final List<Widget>? actions;
  final bool backSupport;
  final bool leadingSupport;

  @override
  _MajuProductAppBarState createState() => _MajuProductAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

class _MajuProductAppBarState extends State<MajuProductAppBar> {
  bool isSearchVisible = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-0.00, -1.00),
            end: const Alignment(0, 1),
            colors: [
              Colors.black.withOpacity(1),
              Colors.black.withOpacity(0.25),
              Colors.black.withOpacity(0.15),
              Colors.white.withOpacity(0),
            ],
          ),
        ),
      ),
      automaticallyImplyLeading: widget.leadingSupport,
      iconTheme: const IconThemeData(color: Palette.n900),
      shadowColor: Palette.n0.withOpacity(0.5),
      elevation: 5,
      leading: widget.backSupport
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : null,
      leadingWidth: 24.0,
      title: isSearchVisible
          ? Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: 200,
                    height: 32,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(width: 0.5, color: Palette.n0)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search,
                            size: 16.0,
                            color: Palette.n0,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: TextField(
                              style: const TextStyle(fontSize: 12.0),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide.none, // Remove the border
                                ),
                                contentPadding: const EdgeInsets.all(0),
                                hintText: widget.title,
                                hintStyle: const TextStyle(color: Colors.white),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide.none, // Remove the border
                                ),
                                focusColor: Colors.black,
                              ),
                              cursorColor: Palette.n900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                SvgPicture.asset(
                  "assets/icons/shopping_cart.svg",
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 16.0,
                ),
                SvgPicture.asset(
                  "assets/icons/menu.svg",
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 16.0,
                )
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSearchVisible = true;
                    });
                  },
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16.0),
                SvgPicture.asset(
                  "assets/icons/shopping_cart.svg",
                  color: Colors.white,
                ),
                const SizedBox(width: 16.0),
                SvgPicture.asset(
                  "assets/icons/menu.svg",
                  color: Colors.white,
                ),
                const SizedBox(width: 16.0),
              ],
            ),
      actions: widget.actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
