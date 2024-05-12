import 'dart:async';
import 'package:bottom_sheet_with_map/pages/weather.dart';
import 'package:bottom_sheet_with_map/widgets/blur_widget.dart';
import 'package:bottom_sheet_with_map/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Weather()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(44, 66, 99, 1),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/initial_bcg.png"),
            fit: BoxFit.cover
          )
        ),
        child: BlurWidget(
          radius: 30,
          blur: 5,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            color: Colors.white.withOpacity(0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               const MyText("Mr_Karimov",fontSize: 24,textColor: Colors.black,fontWeight: FontWeight.w800,),
               SizedBox( height: MediaQuery.of(context).size.height * 0.2),
               const MyText("Flutter Developer",fontSize: 24,textColor: Colors.black,fontWeight: FontWeight.w800,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
