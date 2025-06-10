import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:medialert/models/intake_log.dart';
import 'package:provider/provider.dart';
import 'package:medialert/providers/IntakeLogProvider.dart';
import 'package:medialert/widgets/waveClipper.dart';

class Constants {
  static const String welcomeTitle = 'Bienvenido a MediAlert';
  static const String welcomeSubtitle = 'Medicamentos próximos';
  static const String nextIntakeTitle = 'Próxima toma';
  static const String noResults = 'No hay medicaciones pendientes';
  static const String completeState = 'completado';
  static const String takenState = 'tomas realizadas';
  static const String loading = 'Cargando...';
  static const String modalTitle = 'Selecciona el nuevo estado';
  static const String searchPlaceholder = 'Buscar medicamento';
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _fecha = Constants.loading;
  late IntakeLogProvider _intakeLogProvider;

  @override
  void initState() {
    super.initState();
    _initDate();
    _intakeLogProvider = Provider.of<IntakeLogProvider>(context, listen: false);
    _intakeLogProvider.loadIntakeLogs();
  }

  Future<void> _initDate() async {
    await initializeDateFormatting('es', null);
    DateTime ahora = DateTime.now();

    String fecha = DateFormat(" d 'de' MMMM 'de' y", 'es').format(ahora);
    setState(() {
      _fecha = fecha;
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightView = MediaQuery.of(context).size.height;
    double widthView = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        width: widthView,
        height: heightView,
        color: Color.fromRGBO(232, 242, 241, 1),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildHeader(widthView, heightView),
              Padding(
                padding: EdgeInsets.only(right: 20, left: 20),
                child: Text(
                  Constants.welcomeSubtitle,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20, left: 20, top: 0),
                child: Consumer<IntakeLogProvider>(
                  builder: (context, provider, child) {
                    if (provider.intakeLogs.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            Constants.noResults,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: provider.intakeLogs.length,
                      itemBuilder: (context, index) {
                        final intakeLog = provider.intakeLogs[index];
                        return buildContainer(
                          intakeLog: intakeLog,
                          heightView: heightView,
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20, left: 20, top: 0),
                child: buildCardProximaToma(),
              ),
              SizedBox(height: heightView * 0.15),
            ],
          ),
        ),
      ),
    );
  }

  ClipPath buildHeader(double widthView, double heightView) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        width: widthView,
        height: heightView * 0.3,
        padding: EdgeInsets.only(top: 20),
        constraints: BoxConstraints(minHeight: 360),
        color: Color.fromRGBO(7, 170, 151, 1),
        child: Padding(
          padding: EdgeInsets.only(right: 20, left: 20, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SafeArea(
                    child: SizedBox(
                      width: (widthView / 1.5),
                      child: Text(
                        Constants.welcomeTitle,
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          height: 1.05,
                        ),
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Container(
                      color: Colors.white,
                      width: widthView * 0.13,
                      height: widthView * 0.13,
                      child: Center(
                        child: Icon(
                          Icons.notifications_none,
                          color: Colors.black,
                          size: widthView * 0.09,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                _fecha,
                style: TextStyle(
                  height: 0.5,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              buildInputText(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildContainer({
    required IntakeLog intakeLog,
    required double heightView,
  }) {
    return Container(
      width: double.infinity,
      height: heightView * 0.1,
      constraints: BoxConstraints(minHeight: 90),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 18),

      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(
                  width: constraints.maxWidth * 0.6,
                  height: constraints.maxHeight * 0.68,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5, left: 10, bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          intakeLog.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${intakeLog.quantity} ${intakeLog.massUnitSymbol}',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5),
                SizedBox(
                  width: constraints.maxWidth * 0.35,
                  height: constraints.maxHeight * 0.6,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) => buildButtonSheet(
                            context: context,
                            intakeLog: intakeLog,
                          ),
                        );
                      },
                      child: buildStatusButton(constraints, intakeLog),
                    ),
                  ),
                ),
              ],
            ),
            // Second row: Time and dosage
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Text(
                    intakeLog.time,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  SizedBox(width: 10),
                  Text(
                    intakeLog.getDosageText(),
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildStatusButton(BoxConstraints constraints, IntakeLog intakeLog) {
    Color textColor = Colors.white;
    Color circleIconColor = Colors.white;
    Color backgroundColor = Colors.white;
    Color iconColor = Colors.white;
    IconData icon = Icons.access_time;

    switch (intakeLog.statusName) {
      case 'Espera':
        textColor = Colors.black;
        circleIconColor = Color.fromRGBO(97, 97, 97, 1);
        backgroundColor = Color.fromRGBO(255, 195, 86, 1);
        icon = Icons.access_time;
        break;
      case 'Tomado':
        textColor = Colors.white;
        circleIconColor = Color.fromRGBO(7, 170, 151, 1);
        backgroundColor = Color.fromRGBO(133, 200, 193, 1);
        icon = Icons.check_rounded;
        break;
      case 'Saltado':
        textColor = Colors.white;
        circleIconColor = Color.fromRGBO(255, 195, 86, 1);
        iconColor = Color.fromRGBO(220, 38, 38, 1);
        backgroundColor = Color.fromRGBO(254, 105, 96, 1);
        icon = Icons.access_time;
        break;
      default:
        break;
    }

    return Container(
      height: constraints.minHeight * 0.5,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipOval(
              child: Container(
                width: constraints.maxHeight * 0.4,
                height: constraints.maxHeight * 0.4,
                color: circleIconColor,
                child: Center(
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: constraints.maxHeight * 0.4,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            Align(
              child: Text(
                intakeLog.statusName,
                style: TextStyle(fontSize: 15, color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildButtonSheet({
    required BuildContext context,
    required IntakeLog intakeLog,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.7,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            SizedBox(height: 3),
            Container(
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: Color.fromRGBO(133, 200, 193, 1),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            SizedBox(height: 6),
            Text(
              Constants.modalTitle,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 4),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _intakeLogProvider.updateIntakeLog(intakeLog.id!, 'T');
                },
                child: Container(
                  height: constraints.minHeight * 0.2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(7, 170, 151, 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 10),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Container(
                            width: constraints.maxHeight * 0.17,
                            height: constraints.maxHeight * 0.17,
                            color: Color.fromRGBO(133, 200, 193, 1),
                            child: Center(
                              child: Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: constraints.maxHeight * 0.14,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 20),

                        Text(
                          'Tomado',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _intakeLogProvider.updateIntakeLog(intakeLog.id!, 'S');
                },
                child: Container(
                  height: constraints.minHeight * 0.2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.from(
                      alpha: 1,
                      red: 0.996,
                      green: 0.412,
                      blue: 0.376,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 10),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Container(
                            width: constraints.maxHeight * 0.17,
                            height: constraints.maxHeight * 0.17,
                            color: Color.fromRGBO(255, 195, 86, 1),
                            child: Center(
                              child: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: constraints.maxHeight * 0.14,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 20),

                        Text(
                          'Saltado',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),

              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _intakeLogProvider.updateIntakeLog(intakeLog.id!, 'P');
                },
                child: Container(
                  height: constraints.minHeight * 0.2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 195, 86, 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 10),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Container(
                            width: constraints.maxHeight * 0.17,
                            height: constraints.maxHeight * 0.17,
                            color: Color.fromRGBO(97, 97, 97, 1),
                            child: Center(
                              child: Icon(
                                Icons.access_time,
                                color: Colors.white,
                                size: constraints.maxHeight * 0.14,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          'Espera',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //TODO: Pendiente para implementar con base de datos
  TextFormField buildInputText() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: Constants.searchPlaceholder,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        labelStyle: TextStyle(color: Colors.black, fontSize: 15),
        hintStyle: TextStyle(color: Colors.black, fontSize: 15),
        prefixIcon: Icon(Icons.search, color: Colors.black),
      ),
      style: const TextStyle(
        color: Color.fromRGBO(7, 170, 151, 1),
        fontSize: 15,
      ),
    );
  }

  //TODO: Pendiente para implementar con base de datos
  Container buildCardProximaToma() {
    return Container(
      width: double.infinity,
      height: 140,
      constraints: BoxConstraints(minHeight: 140),
      decoration: BoxDecoration(
        color: Color.fromRGBO(7, 170, 151, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                  width: constraints.maxWidth * 0.25,
                  height: constraints.maxHeight - 20,
                  child: Center(
                    child: SvgPicture.asset('assets/icons/add-black.svg'),
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth * 0.70,
                  height: constraints.maxHeight - 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        Constants.nextIntakeTitle,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Ibuprofeno en 2 horas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      LinearProgressIndicator(
                        value: 0.6, // 60% de progreso
                        color: Colors.tealAccent,
                        borderRadius: BorderRadius.circular(10),
                        backgroundColor: Colors.teal.shade100,
                      ),
                      SizedBox(height: 5),
                      Text(
                        '60 % completado - 2/3 tomas realizadas',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
