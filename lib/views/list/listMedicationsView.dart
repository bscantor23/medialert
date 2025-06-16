import 'package:flutter/material.dart';
import 'package:medialert/views/list/widgets/medicationContainer.dart';
import 'package:provider/provider.dart';
import 'package:medialert/providers/MedicationsProvider.dart';
import 'package:medialert/widgets/header.dart';

class Constants {
  static const String pageTitle = 'Lista de Medicamentos';
  static const String noResults = 'No hay medicamentos registrados';
}

class ListMedicationsView extends StatefulWidget {
  const ListMedicationsView({super.key});

  @override
  State<ListMedicationsView> createState() => _ListMedicationsView();
}

class _ListMedicationsView extends State<ListMedicationsView> {
  @override
  void initState() {
    super.initState();
    Provider.of<MedicationsProvider>(context, listen: false).loadMedications();
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
              buildHeader(widthView, heightView, Constants.pageTitle, 220),
              Padding(
                padding: EdgeInsets.only(right: 20, left: 20, top: 0),
                child: Consumer<MedicationsProvider>(
                  builder: (context, provider, child) {
                    if (provider.medications.isEmpty) {
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
}
