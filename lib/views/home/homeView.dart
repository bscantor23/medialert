import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:medialert/providers/StatusProvider.dart';
import 'package:medialert/views/home/widgets/intakeContainer.dart';
import 'package:medialert/views/home/widgets/nextMedication.dart';
import 'package:medialert/widgets/header.dart';
import 'package:medialert/widgets/textInput.dart';
import 'package:provider/provider.dart';
import 'package:medialert/providers/IntakeProvider.dart';

class Constants {
  static const String welcomeTitle = 'Bienvenido a MediAlert';
  static const String welcomeSubtitle = 'Medicamentos próximos';
  static const String completeState = 'completado';
  static const String loading = 'Cargando...';
  static const String searchPlaceholder = 'Buscar medicamento';
  static const String noResults = 'No hay resultados';
  static const String completed = 'Medicación completada';
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _fecha = Constants.loading;
  late IntakeProvider _intakeProvider;
  late StatusProvider _statusProvider;

  @override
  void initState() {
    super.initState();
    _initDate();

    _statusProvider = Provider.of<StatusProvider>(context, listen: false);
    _intakeProvider = Provider.of<IntakeProvider>(context, listen: false);
    _intakeProvider.loadIntakeLogs();
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
              buildHeader(widthView, heightView, Constants.welcomeTitle, 340, [
                Text(
                  _fecha,
                  style: TextStyle(
                    height: 0.5,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                buildInputText(
                  Constants.searchPlaceholder,
                  _intakeProvider.searchIntakeLogs,
                ),
                Spacer(),
              ]),
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
                child: Consumer<IntakeProvider>(
                  builder: (context, provider, child) {
                    if (provider.intakeLogs.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
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
                        return buildIntakeContainer(
                          intakeLog: intakeLog,
                          statusProvider: _statusProvider,
                          intakeProvider: _intakeProvider,
                          heightView: heightView,
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20, left: 20),
                child: Consumer<IntakeProvider>(
                  builder: (context, provider, child) {
                    return buildCardNextMedication(_intakeProvider);
                  },
                ),
              ),
              SizedBox(height: heightView * 0.15),
            ],
          ),
        ),
      ),
    );
  }
}
