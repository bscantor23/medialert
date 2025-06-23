import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:medialert/providers/MedicationProvider.dart';
import 'dart:math';
import 'package:medialert/widgets/header.dart';
import 'package:medialert/models/medication.dart';
import 'package:medialert/dao/medication.dart';
import 'package:provider/provider.dart';

import '../../providers/BaseScreenProvider.dart';

class AddView extends StatefulWidget {
  final Medication? medication;

  const AddView({super.key, this.medication});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  TextEditingController _medController = TextEditingController();
  TextEditingController _doseController = TextEditingController();
  TextEditingController _notesController = TextEditingController();

  TimeOfDay selectedTime = TimeOfDay(hour: 20, minute: 0);
  bool todosLosDias = false;
  bool diasEspecificos = false;
  List<bool> diasSeleccionados = [
    false,
    true,
    true,
    false,
    false,
    false,
    false,
  ];
  final dias = ['LU', 'MA', 'MI', 'JU', 'VI', 'SA', 'DO'];
  final List<String> unidades = ['mg', 'ml', 'g', 'mcg'];
  String unidadSeleccionada = 'mg';
  bool showSuccessCard = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final medication = widget.medication;
    if (medication != null) {
      print('debug');
      _medController = TextEditingController(text: medication.name);
      print(_medController.text);
      _doseController = TextEditingController(
        text: medication.quantity.toString(),
      );
      _notesController = TextEditingController(text: medication.instructions);
      unidadSeleccionada = medication.massUnitSymbol;
      selectedTime = parseTimeOfDay(medication.time);

      String dias = medication.dosage;
      List<int> listaDias = List<int>.from(jsonDecode(dias));

      for (int dia in listaDias) {
        int index = dia - 1;
        if (index >= 0 && index < diasSeleccionados.length) {
          diasSeleccionados[index] = true;
        }
      }
    }
  }

  TimeOfDay parseTimeOfDay(String timeStr) {
    // Eliminar caracteres invisibles y espacios raros
    String cleaned = timeStr.replaceAll(RegExp(r'\s+'), ' ').trim();

    final format = DateFormat('hh:mm a');
    final dateTime = format.parse(cleaned);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void toggleTodosLosDias(bool value) {
    setState(() {
      todosLosDias = value;
      diasEspecificos = !value;
      for (int i = 0; i < diasSeleccionados.length; i++) {
        diasSeleccionados[i] = value;
      }
    });
  }

  void toggleDia(int index) {
    setState(() {
      diasSeleccionados[index] = !diasSeleccionados[index];
    });
  }

  Future<void> _guardarMedicamento() async {
    if (_medController.text.trim().isEmpty ||
        _doseController.text.trim().isEmpty ||
        (!todosLosDias && !diasSeleccionados.contains(true))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos obligatorios'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final dosage = todosLosDias
          ? [1, 2, 3, 4, 5, 6, 7]
          : diasSeleccionados
                .asMap()
                .entries
                .where((entry) => entry.value)
                .map((entry) => entry.key + 1)
                .toList();

      final medication = Medication(
        id: widget
            .medication
            ?.id, // Asegurar que el id se mantenga para actualizaciones
        massUnitId: unidades.indexOf(unidadSeleccionada) + 1,
        quantity: double.parse(_doseController.text),
        name: _medController.text.trim(),
        instructions: _notesController.text.trim(),
        dosage: dosage.toString(),
        time: selectedTime.format(context),
      );

      final medicationProvider = context.read<MedicationProvider>();

      if (widget.medication != null && widget.medication!.id != null) {
        await medicationProvider.updateMedication(medication);
      } else {
        await MedicationDao().insertMedication(
          medication,
        ); // Usar provider en lugar de DAO directamente
      }

      // Mostrar tarjeta flotante de éxito
      setState(() {
        showSuccessCard = true;
      });

      // Ocultarla después de 4 segundos
      Future.delayed(Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            showSuccessCard = false;
          });
        }
      });

      // Limpiar campos
      _medController.clear();
      _doseController.clear();
      _notesController.clear();
      setState(() {
        diasSeleccionados = List<bool>.filled(7, false);
        todosLosDias = false;
        diasEspecificos = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightView = MediaQuery.of(context).size.height;
    double widthView = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              width: widthView,
              height: heightView,
              color: const Color.fromRGBO(232, 242, 241, 1),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(
                      widthView,
                      heightView,
                      widget.medication != null?'Actualizar medicamento':
                      'Agregar medicamento',
                      220,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 20,
                        left: 20,
                        top: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nombre del medicamento',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Material(
                            child: TextField(
                              controller: _medController,
                              decoration: InputDecoration(
                                hintText: 'Paracetamol',
                                prefixIcon: const Icon(
                                  Icons.medication_outlined,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          const Text(
                            'Dosis',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Material(
                                            child: TextField(
                                              controller: _doseController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: '500',
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: unidadSeleccionada,
                                                icon: const Icon(
                                                  Icons.arrow_drop_down,
                                                ),
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    unidadSeleccionada =
                                                        newValue!;
                                                  });
                                                },
                                                items: unidades.map((
                                                  String value,
                                                ) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    const Row(
                                      children: [
                                        Text(
                                          'Frecuencia',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    CheckboxListTile(
                                      visualDensity: const VisualDensity(
                                        horizontal: 0,
                                        vertical: -4,
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: todosLosDias,
                                      onChanged: (value) =>
                                          toggleTodosLosDias(value!),
                                      title: const Text('Todos los días'),
                                    ),
                                    CheckboxListTile(
                                      visualDensity: const VisualDensity(
                                        horizontal: 0,
                                        vertical: -4,
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: diasEspecificos,
                                      onChanged: (value) =>
                                          toggleTodosLosDias(!value!),
                                      title: const Text('Días especificos'),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: List.generate(dias.length, (
                                        index,
                                      ) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 2.0,
                                          ),
                                          child: DiaCheckbox(
                                            label: dias[index],
                                            selected: diasSeleccionados[index],
                                            onTap: () => toggleDia(index),
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [buildHorarioCard(context)],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 36),
                          const Text(
                            'Notas',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Material(
                            child: TextField(
                              controller: _notesController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    _guardarMedicamento();
                                  },
                                  child: Text(   widget.medication != null?'Actualizar':
                                    'Guardar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade400,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(height: heightView * 0.15),
                  ],
                ),
              ),
            ),
          ),
          // Tarjeta flotante de éxito
          if (showSuccessCard)
            Positioned.fill(
              child: Container(
                color: Colors.black54, // Fondo semitransparente
                child: Center(
                  child: AnimatedOpacity(
                    opacity: showSuccessCard ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 300),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.transparent,
                      child: Container(
                        width: widthView * 0.85,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.teal, width: 2),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.teal,
                              size: 40,
                            ),
                            SizedBox(height: 10),
                            Text(
                              widget.medication != null
                                  ? 'El medicamento se actualizo de forma exitosa'
                                  : "El medicamento se agregó de forma exitosa, puedes visualizarlo en la pestaña ",
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<BaseScreenProvider>()
                                    .updateNameItem('Lista');
                              },
                              child: Text(
                                "Lista de medicamentos",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildHorarioCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Horario',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Tooltip(
              message: "Toca para cambiar la hora",
              child: GestureDetector(
                onTap: () => _selectTime(context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedTime.format(context),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnalogClockDisplay(time: selectedTime, size: 120),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}

class DiaCheckbox extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const DiaCheckbox({
    required this.label,
    required this.selected,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25,
        height: 25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.teal : Colors.white,
          border: Border.all(color: Colors.teal),
          borderRadius: BorderRadius.circular(8),
        ),
        child: selected
            ? const Icon(Icons.check, color: Colors.white, size: 24)
            : Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
      ),
    );
  }
}

class AnalogClockDisplay extends StatelessWidget {
  final TimeOfDay time;
  final double size;

  const AnalogClockDisplay({super.key, required this.time, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _AnalogClockPainter(time),
    );
  }
}

class _AnalogClockPainter extends CustomPainter {
  final TimeOfDay time;
  _AnalogClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 1.5;

    final paintHourHand = Paint()
      ..color = Colors.teal
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final paintMinuteHand = Paint()
      ..color = Colors.teal.shade800
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 1; i <= 12; i++) {
      final angle = (pi / 6) * i - pi / 2;
      final position = Offset(
        center.dx + cos(angle) * (radius - 20),
        center.dy + sin(angle) * (radius - 20),
      );

      textPainter.text = TextSpan(
        text: '$i',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      );

      textPainter.layout();
      final offset =
          position - Offset(textPainter.width / 2, textPainter.height / 2);
      textPainter.paint(canvas, offset);
    }

    final hourAngle = (pi / 6) * (time.hour % 12 + time.minute / 60);
    final minuteAngle = (pi / 30) * time.minute;

    final hourHandLength = radius * 0.45;
    final minuteHandLength = radius * 0.65;

    final hourHandEnd =
        center +
        Offset(cos(hourAngle - pi / 2), sin(hourAngle - pi / 2)) *
            hourHandLength;
    final minuteHandEnd =
        center +
        Offset(cos(minuteAngle - pi / 2), sin(minuteAngle - pi / 2)) *
            minuteHandLength;

    canvas.drawLine(center, hourHandEnd, paintHourHand);
    canvas.drawLine(center, minuteHandEnd, paintMinuteHand);
    canvas.drawCircle(center, 5, paintHourHand);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
