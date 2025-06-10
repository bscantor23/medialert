import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:medialert/widgets/waveClipper.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _fecha = "Cargando...";

  @override
  void initState() {
    super.initState();
    _inicializarFecha();
  }

  Future<void> _inicializarFecha() async {
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
                  'Medicamentos próximos',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20, left: 20, top: 0),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index) => buildContainer(
                    heightView: heightView,
                    hora: '10:00 AM',
                    cantidad: '800 mg',
                    frecuencia: 'Diario',
                    nombre: 'Ibuprofeno',
                    estado: 'Tomado',
                  ),
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
                Container(
                  width: constraints.maxWidth * 0.25,
                  height: constraints.maxHeight - 20,
                  child: Center(
                    child: SvgPicture.asset('assets/icons/add-black.svg'),
                  ),
                ),
                Container(
                  width: constraints.maxWidth * 0.70,
                  height: constraints.maxHeight - 20,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Próxima toma',
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

  Container buildContainer({
    required double heightView,
    required String nombre,
    required String frecuencia,
    required String cantidad,
    required String hora,
    required String estado,
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
              width: constraints.maxWidth * 0.6,
              height: constraints.maxHeight,

              child: Padding(
                padding: EdgeInsets.only(top: 5, left: 10, bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      cantidad,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    Row(
                      children: [
                        Text(
                          hora,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        SizedBox(width: 10),

                        Text(
                          frecuencia,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 5),

            Container(
              width: constraints.maxWidth * 0.35,
              height: constraints.maxHeight,

              child: Center(
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
                      builder: (context) => buildButtonSheet(
                        context: context,
                        nombre: nombre,
                        estado: estado,
                      ),
                    );
                  },
                  child: Container(
                    height: constraints.minHeight * 0.5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(133, 200, 193, 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipOval(
                            child: Container(
                              width: constraints.maxHeight * 0.4,
                              height: constraints.maxHeight * 0.4,
                              color: Color.fromRGBO(7, 170, 151, 1),
                              child: Center(
                                child: Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: constraints.maxHeight * 0.4,
                                ),
                              ),
                            ),
                          ),

                          Text(
                            estado,
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
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

  Container buildButtonSheet({
    required BuildContext context,
    required String nombre,
    required String estado,
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
              'Seleccionar estado para ${nombre}',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 4),

            Padding(
              padding: const EdgeInsets.all(8.0),
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
                        'Cancelar',
                        style: TextStyle(fontSize: 15, color: Colors.black),
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

            /*


            ListTile(
              leading: Icon(Icons.cancel, color: Colors.red),
              title: Text('Cancelado'),
              onTap: () {
                // acción
                Navigator.pop(context, 'cancelado');
              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Tomado'),
              onTap: () {
                Navigator.pop(context, 'tomado');
              },
            ),
            ListTile(
              leading: Icon(Icons.access_time, color: Colors.orange),
              title: Text('Espera'),
              onTap: () {
                Navigator.pop(context, 'espera');
              },
            ),*/
          ],
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
        constraints: BoxConstraints(minHeight: 320),
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
                        '¡Bienvenido a  MediAlert!',
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

  TextFormField buildInputText() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Buscar medicamento',
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
}
