import 'package:flutter/material.dart';
class listView extends StatefulWidget {
  const listView({super.key});

  @override
  State<listView> createState() => _listViewState();
}

class _listViewState extends State<listView> {
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
