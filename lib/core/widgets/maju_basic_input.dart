import 'package:flutter/material.dart';
import 'package:maju/themes/palette.dart';

class MajuBasicInput extends StatefulWidget {
  const MajuBasicInput(
      {super.key, required this.hintText, this.labelText, this.controller});
  final String hintText;
  final String? labelText;
  final TextEditingController? controller;
  @override
  State<MajuBasicInput> createState() => _MajuBasicInputState();
}

class _MajuBasicInputState extends State<MajuBasicInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      cursorColor: Palette.n900,
      style: const TextStyle(fontSize: 14.0),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Palette.n900),
            borderRadius: BorderRadius.circular(8.0)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Palette.n600),
            borderRadius: BorderRadius.circular(8.0)),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Palette.n600),
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: Palette.n600),
      ),
    );
  }
}
