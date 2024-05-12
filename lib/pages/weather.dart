import 'dart:async';
import 'dart:developer';
import 'package:bottom_sheet_with_map/constants/api_constants.dart';
import 'package:bottom_sheet_with_map/models/weather_model.dart';
import 'package:bottom_sheet_with_map/service/http_service.dart';
import 'package:bottom_sheet_with_map/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/blur_widget.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  bool isLoading = false;
  late double lat;
  late double lon;
  WeatherModel? weatherModel;
  Address address = Address();

  Future<void> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position userPosition = await Geolocator.getCurrentPosition();
    lat = userPosition.latitude;
    lon = userPosition.longitude;
    log(lat.toString());
    log(lon.toString());
  }

  Future<String?> readInfo() async {
    log("readInfo");
    isLoading = false;
    String? result = await HttpClientService.getData(
        baseUrl: ApiConstants.baseUrl,
        api: ApiConstants.baseApi,
        param: {
          "lat": lat.toString(),
          "lon": lon.toString(),
        });
    log(lat.toString());
    log(lon.toString());

    log("readInfo2");
    log(result.toString());
    if (result != null) {
      weatherModel = weatherModelFromJson(result);
      log(weatherModel!.cloudPct.toString());
      setState(() {
        isLoading = true;
      });
      return result;
    } else {
      log("${weatherModel!.cloudPct} Something Went Wrong");
      return "Something Went Wrong";
    }
  }

  Future<void> reverse() async {
    address = await GeoCode().reverseGeocoding(latitude: lat, longitude: lon);
    log(address.countryName.toString());
    log("address.countryName.toString()");
  }

  @override
  void initState() {
    readInfo();
    checkPermission().then((value) async {
      await reverse();
      await readInfo().then((value)async{
        await reverse();
        setState(() {

        });
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/image_bcg.png"),
            fit: BoxFit.cover),
      ),
      child: isLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                BlurWidget(
                  radius: 1,
                  blur: 2,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: (weatherModel!.cloudPct <= 40 &&
                                    weatherModel!.maxTemp >= 20)
                                ? Image.asset("assets/images/sun.png")
                                : (weatherModel!.cloudPct >= 40 &&
                                        weatherModel!.cloudPct <= 65)
                                    ? Image.asset(
                                        "assets/images/only_cloud.png")
                                    : Image.asset(
                                        "assets/images/cloud_rainiy.png"),
                          ),

                          const SizedBox(height: 10),

                          Center(
                            child: MyText("${weatherModel!.maxTemp}° ☀️",
                                fontSize: 24, fontWeight: FontWeight.w600),
                          ),

                          Center(
                            child: (weatherModel!.maxTemp >= 20 &&
                                    weatherModel!.maxTemp <= 40)
                                ? const MyText(
                                    "Qouyoshli kun",
                                    fontWeight: FontWeight.w500,
                                  )
                                : const MyText(
                                    "Havo sovuq",
                                    fontWeight: FontWeight.w500,
                                  ),
                          ),

                          const SizedBox(height: 10),

                          MyText(
                            "Namlik  ${weatherModel!.humidity}% 💦",
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w500,
                          ),
                          MyText(
                            "Shamol Tezligi  ${weatherModel!.windSpeed} km/h    🌪🌬",
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w500,
                          ),
                          //"wind_speed": 2.06 "humidity": 49
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlurWidget(
                    radius: 1,
                    blur: 2,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25)),
                      child:  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const MyText("Mr_Karimov"),
                            const MyText("Your Location"),
                            MyText("${address.city}"),
                            MyText("${address.streetAddress}"),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withOpacity(0.2),
        onPressed: ()async{
          isLoading = false;
          setState(() {

          });
        Timer(Duration(seconds: 2), ()async {
          await reverse().then((value)async{
            await readInfo();
            setState(() {
              isLoading = true;
            });
          });
         });
        },
        
        child: const Icon(Icons.refresh_sharp),
      ),
    );
    
  }
}
