import 'package:flutter/material.dart' hide ListView;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medialert/views/add/addView.dart';
import 'package:medialert/views/home/HomeView.dart';
import 'package:medialert/views/record/recordView.dart';
import 'package:medialert/views/list/listMedicationsView.dart';
import 'package:provider/provider.dart';

import '../providers/BaseScreenProvider.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {


  @override
  Widget build(BuildContext context) {
    double widthView = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(children: [
        Consumer<BaseScreenProvider>(
          builder: (context, provider, child) {
            return provider.vista; // Rebuilds when notifyListeners is called
          },
        ),

        buildBottomNavigationBar(widthView)]),
    );
  }

  /// Metodo para construir el panel de navegación
  Positioned buildBottomNavigationBar(double widthView) {
    return Positioned(
      bottom: 30,
      left: 20,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(7, 170, 151, 1),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        width: widthView,
        height: 70,
        child: LayoutBuilder(
          builder: (context, constraints) => Padding(
            padding: const EdgeInsets.only(
              left: 6,
              top: 5,
              bottom: 5,
              right: 6,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                itemNavigation(
                  constraints: constraints,
                  iconPath: 'assets/icons/home-black.svg',
                  iconPathActive: 'assets/icons/home-green.svg',
                  name: 'Home',
                ),
                itemNavigation(
                  iconPathActive: 'assets/icons/add-green.svg',
                  constraints: constraints,
                  iconPath: 'assets/icons/add-black.svg',
                  name: 'Agregar',
                ),
                itemNavigation(
                  iconPathActive: 'assets/icons/list-green.svg',
                  constraints: constraints,
                  iconPath: 'assets/icons/list-black.svg',
                  name: 'Lista',
                ),
                itemNavigation(
                  constraints: constraints,
                  iconPathActive: 'assets/icons/calendar-green.svg',
                  iconPath: 'assets/icons/calendar-black.svg',
                  name: 'Historial',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Metodo para construir los items de navegación
  GestureDetector itemNavigation({
    required BoxConstraints constraints,
    required String iconPath,
    required String iconPathActive,
    required String name,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          context.read<BaseScreenProvider>().updateNameItem(name);
        });
      },
      child:
        Consumer<BaseScreenProvider>(
          builder: (context, provider, child) {
            bool isActive = provider.name == name; // Reactivo a cambios en provider.name

            return AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
              width: isActive ? constraints.maxWidth * 0.4 : constraints.maxWidth * 0.15,
              height: double.infinity,
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    isActive ? iconPathActive : iconPath,
                    height: name == 'Lista' ? 25 : 35,
                  ),
                  if (isActive) ...[
                    TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 400),
                      tween: Tween(end: 1.0, begin: 0.0),
                      builder: (context, value, child) => Row(
                        children: [
                          SizedBox(width: 10 * value),
                          Text(
                            name,
                            style: TextStyle(
                              color: Color.fromRGBO(7, 170, 151, 1),
                              fontSize: 15 * value,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
    );
  }
}
