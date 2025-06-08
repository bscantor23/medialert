import 'package:flutter/material.dart';

class RecordView extends StatefulWidget {
  const RecordView({super.key});

  @override
  State<RecordView> createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
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
