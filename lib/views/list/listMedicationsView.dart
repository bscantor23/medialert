import 'package:flutter/material.dart';
import 'package:medialert/models/medication.dart';
import 'package:provider/provider.dart';
import 'package:medialert/providers/ListMedications.dart';
import 'package:medialert/widgets/header.dart';

class Constants {
  static const String pageTitle = 'Lista de Medicamentos';
  static const String modalTitle = '¿Alguna modificación pendiente?';
  static const String editAction = 'Editar';
  static const String deleteAction = 'Eliminar';
}

class ListMedicationsView extends StatefulWidget {
  const ListMedicationsView({super.key});

  @override
  State<ListMedicationsView> createState() => _ListMedicationsView();
}

class _ListMedicationsView extends State<ListMedicationsView> {
  @override
  Widget build(BuildContext context) {
    double heightView = MediaQuery.of(context).size.height;
    double widthView = MediaQuery.of(context).size.width;

    Provider.of<ListMedicationsProvider>(context, listen: false).loadMedications();

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
              buildHeader(widthView, heightView, Constants.pageTitle, 200),
              Padding(
                padding: EdgeInsets.only(right: 20, left: 20, top: 0),
                child: Consumer<ListMedicationsProvider>(
                  builder: (context, provider, child) {
                    print('Provider state: ${provider.medications}');
                    if (provider.medications.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                          'No hay medicamentos registrados',
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: provider.medications.length,
                      itemBuilder: (context, index) {
                        final medication = provider.medications[index];
                        return buildContainer(
                          medication: medication,
                          heightView: heightView,
                        );
                      },
                    );
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

  Container buildBottonSheet({
    required BuildContext context,
    required String id,
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
                              size: constraints.maxHeight * 0.14,
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
          ],
        ),
      ),
    );
  }

  Container buildContainer({
    required Medication medication,
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
        builder: (context, constraints) => Row(
          children: [
            SizedBox(
              width: constraints.maxWidth * 0.85,
              height: constraints.maxHeight,

              child: Padding(
                padding: EdgeInsets.only(top: 5, left: 10, bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${medication.quantity} ${medication.massUnitSymbol}',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    Row(
                      children: [
                        Text(
                          medication.time,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        SizedBox(width: 10),

                        Text(
                          medication.getDosageText(),
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 5),

            SizedBox(
              width: constraints.maxWidth * 0.1,
              height: constraints.maxHeight,
              child: Center(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        isScrollControlled:
                            true, // Opcional, si quieres usar más altura
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => buildBottonSheet(
                          context: context,
                          id: medication.id.toString(),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: constraints.minHeight * 0.5,
                      width: 40,
                      child: Center(
                        child: Icon(
                          Icons.more_vert,
                          color: Color.fromRGBO(133, 200, 193, 1),
                          size: constraints.maxHeight * 0.4,
                        ),
                      ),
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
}
