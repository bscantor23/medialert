import 'package:flutter/material.dart';
import '../../widgets/header.dart';

class RecordView extends StatefulWidget {
  const RecordView({super.key});

  @override
  State<RecordView> createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
  final DateTime hoy = DateTime(2025, 1, 8);

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
        color: const Color.fromRGBO(232, 242, 241, 1),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(widthView, heightView, 'Historial de medicamentos', 220),
              Padding( // Calendario y tarjetas
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Dropdown de mes
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text("Enero 2025", style: TextStyle(fontWeight: FontWeight.w600)),
                            SizedBox(width: 8),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Calendario dentro de tarjeta con bordes redondeados
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: CalendarDatePicker(
                        initialDate: hoy,
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2026),
                        onDateChanged: (_) {},
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Título fecha
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '8 Enero de 2025',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Lista de tarjetas
                    TarjetaMedicamento(nombre: 'Ibuprofeno', hora: '8 AM', tomado: true),
                    TarjetaMedicamento(nombre: 'Ibuprofeno', hora: '9 AM', tomado: false),
                    TarjetaMedicamento(nombre: 'Ibuprofeno', hora: '10 AM', tomado: true),
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

class TarjetaMedicamento extends StatelessWidget {
  final String nombre;
  final String hora;
  final bool tomado;

  const TarjetaMedicamento({
    super.key,
    required this.nombre,
    required this.hora,
    required this.tomado,
  });

  @override
  Widget build(BuildContext context) {
    final colorEstado = tomado ? Colors.teal : Colors.redAccent;
    final textoEstado = tomado ? 'Tomado' : 'Saltado';
    final icono = tomado ? Icons.check_circle : Icons.cancel;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Info medicamento
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(hora, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),

          // Estado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colorEstado.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Icon(icono, color: colorEstado),
                const SizedBox(width: 6),
                Text(
                  textoEstado,
                  style: TextStyle(
                    color: colorEstado,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
