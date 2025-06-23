import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medialert/models/Historic.dart';
import 'package:medialert/providers/HistoricProvider.dart';
import 'package:medialert/views/record/widgets/historicCard.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../widgets/header.dart';

class Constants {
  static const String pageTitle = 'Historial de Medicamentos';
  static const String noResults = 'No hay medicamentos registrados';
}

class RecordView extends StatefulWidget {
  const RecordView({super.key});

  @override
  State<RecordView> createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  late HistoricProvider _historicProvider;

  @override
  void initState() {
    super.initState();

    _historicProvider = Provider.of<HistoricProvider>(context, listen: false);
    _historicProvider.loadHistorics(_selectedDay);
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
            children: [
              buildHeader(widthView, heightView, Constants.pageTitle, 220),
              Padding(
                // Calendario y tarjetas
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Calendario dentro de tarjeta con bordes redondeados
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: TableCalendar(
                        locale: 'es_ES',
                        firstDay: DateTime.utc(_focusedDay.year - 2),
                        lastDay: DateTime.utc(_focusedDay.year + 2),
                        calendarFormat: _calendarFormat,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        rowHeight: 40,
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                          _historicProvider.loadHistorics(_selectedDay);
                        },

                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                        calendarStyle: const CalendarStyle(
                          selectedDecoration: BoxDecoration(
                            color: Color.fromRGBO(7, 170, 151, 1),
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: Color.fromRGBO(133, 200, 193, 1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Título fecha
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        DateFormat.yMMMMEEEEd('es_ES').format(_selectedDay),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Consumer<HistoricProvider>(
                      builder: (context, provider, child) {
                        if (provider.historics.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                Constants.noResults,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: provider.historics.length,
                          itemBuilder: (context, index) {
                            final historic = provider.historics[index];
                            return HistoricCard(historic: historic);
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
