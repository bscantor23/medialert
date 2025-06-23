import 'package:flutter/material.dart';
import 'package:medialert/models/Historic.dart';

class HistoricCard extends StatelessWidget {
  final Historic historic;

  const HistoricCard({super.key, required this.historic});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
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
                  historic.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  historic.time,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Estado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Color(historic.medicationStatus!.backgroundColor),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Icon(
                  IconData(
                    historic.medicationStatus!.icon,
                    fontFamily: 'MaterialIcons',
                  ),
                  color: Color(historic.medicationStatus!.iconColor),
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  historic.medicationStatus!.name,
                  style: TextStyle(
                    color: Color(historic.medicationStatus!.textColor),
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
