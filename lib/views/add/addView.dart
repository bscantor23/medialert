import 'package:flutter/material.dart';
class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  @override
  Widget build(BuildContext context) {
    double heightView = MediaQuery.of(context).size.height;
    double widthView = MediaQuery.of(context).size.width;
    return Container(
      width: widthView,
      height: heightView,
      color: Color.fromRGBO(232, 242, 241, 1),
    );
  }
}
