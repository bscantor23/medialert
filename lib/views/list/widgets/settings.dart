import 'package:flutter/material.dart';
import 'package:medialert/models/medication.dart';
import 'package:medialert/providers/MedicationProvider.dart';

class Constants {
  static const String modalTitle = '¿Alguna modificación pendiente?';
  static const String editAction = 'Editar';
  static const String deleteAction = 'Eliminar';
}

Container buildSettings({
  required BuildContext context,
  required Medication medication,
  required MedicationProvider medicationProvider,
}) {
  return Container(
    height: MediaQuery.of(context).size.height / 3.2,
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
          SizedBox(height: 10),
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: Color.fromRGBO(133, 200, 193, 1),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          SizedBox(height: 10),
          Text(
            Constants.modalTitle,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: constraints.minHeight * 0.2,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromRGBO(251, 192, 45, 1),
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
                        color: Color.fromRGBO(245, 206, 106, 1),
                        child: Center(
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: constraints.maxHeight * 0.12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      Constants.editAction,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text(
                        'Confirmar eliminación',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      content: Text(
                        '¿Estás seguro de que deseas eliminar este medicamento?',
                        style: TextStyle(fontSize: 16),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 54, 50, 50),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            medicationProvider.deleteMedication(medication.id!);
                          },
                          child: Text(
                            'Eliminar',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                height: constraints.minHeight * 0.2,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(254, 105, 96, 1),
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
                        Constants.deleteAction,
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
