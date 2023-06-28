import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'chart_carousel.dart';
import '../../widgets/nav_bar.dart';

const Color primaryColor = Color(0xFF12BA6C);
const Color secondaryColor = Color(0xFFDFF4EB);
const Color tertiaryColor = Color(0xFFF9FAFA);

const Color primaryColorDark = Color(0xFF11BA6C);
const Color secondaryColorDark = Color(0xFF1F3630);
const Color tertiaryColorDark = Color(0xFF232429);

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key, required this.isDark}) : super(key: key);

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 32),
                dayPicker(isDark),
                SizedBox(
                  height: 16,
                ),
                weatherCard(isDark),
                ChartCarousel(),
                SizedBox(height: 64),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget weatherCard(bool isDark) {
  Color textColor = Color(0xFF0D0D0D);
  Color backgroundColor = Color(0XFFDFF4EB);

  const String srsssvg =
      '<?xml version="1.0" standalone="no"?> <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 20010904//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"> <svg version="1.0" xmlns="http://www.w3.org/2000/svg" width="721.000000pt" height="283.000000pt" viewBox="0 0 721.000000 283.000000" preserveAspectRatio="xMidYMid meet"> <g transform="translate(0.000000,283.000000) scale(0.100000,-0.100000)" fill="#000000" stroke="none"> <path d="M5610 2105 l0 -65 30 0 c27 0 30 3 30 30 0 17 -4 30 -10 30 -5 0 -10 9 -10 20 0 11 5 20 10 20 6 0 10 7 10 15 0 10 -10 15 -30 15 l-30 0 0 -65z"/> <path d="M3550 2096 l0 -44 133 3 c72 2 138 3 145 4 7 1 12 16 12 41 l0 40 -145 0 -145 0 0 -44z"/> <path d="M3143 2123 c-78 -4 -83 -5 -89 -28 -3 -14 -3 -36 0 -50 6 -23 11 -25 66 -25 33 0 60 4 60 10 0 6 33 10 80 10 l80 0 0 39 c0 45 -11 52 -73 49 -23 -1 -79 -4 -124 -5z"/> <path d="M4052 2121 c-8 -5 -12 -22 -10 -42 l3 -34 73 -3 c39 -2 72 -7 72 -12 0 -6 32 -10 70 -10 l70 0 0 48 0 49 -97 6 c-128 9 -165 8 -181 -2z"/> <path d="M2715 2070 c-3 -5 -33 -10 -65 -10 -67 0 -90 -7 -90 -25 0 -7 -6 -16 -12 -19 -10 -5 -10 -7 0 -12 6 -3 12 -14 12 -25 0 -17 8 -19 70 -19 40 0 70 4 70 10 0 6 26 10 59 10 65 0 71 6 71 66 l0 34 -54 0 c-30 0 -58 -4 -61 -10z"/> <path d="M4546 2064 c-13 -34 -7 -64 14 -64 11 0 20 -4 20 -10 0 -5 23 -10 50 -10 28 0 50 -4 50 -10 0 -6 30 -10 69 -10 l69 0 6 34 c11 59 3 66 -79 66 -41 0 -77 5 -80 10 -3 6 -30 10 -60 10 -39 0 -54 -4 -59 -16z"/> <path d="M5852 2055 c-22 -47 -16 -55 37 -55 68 0 82 40 24 68 -38 17 -48 15 -61 -13z"/> <path d="M5340 2015 c0 -14 11 -37 25 -51 l25 -25 25 25 c14 14 25 30 25 36 0 22 -29 40 -64 40 -32 0 -36 -3 -36 -25z m60 -25 c0 -5 -4 -10 -10 -10 -5 0 -10 5 -10 10 0 6 5 10 10 10 6 0 10 -4 10 -10z"/> <path d="M5590 2010 c0 -5 -16 -10 -35 -10 -19 0 -35 -4 -35 -10 0 -5 -6 -10 -12 -10 -7 0 -24 -14 -38 -32 -14 -17 -31 -37 -37 -44 -7 -7 -13 -20 -13 -28 0 -9 -4 -16 -10 -16 -5 0 -10 -13 -10 -30 0 -16 -5 -41 -12 -55 -8 -18 -8 -31 0 -48 6 -12 13 -34 16 -48 3 -14 13 -35 23 -47 10 -11 25 -30 33 -41 19 -24 117 -77 171 -91 35 -10 55 -30 29 -30 -5 0 -10 -25 -10 -55 0 -52 2 -55 24 -55 13 0 31 3 40 6 17 7 22 34 6 34 -5 0 -10 11 -10 25 0 14 -4 25 -10 25 -14 0 -12 29 3 43 6 7 34 23 60 36 64 33 98 67 121 121 10 25 22 53 27 62 12 24 11 91 -2 125 -21 51 -34 78 -44 89 -5 6 -17 21 -25 33 -8 11 -20 21 -27 21 -7 0 -13 5 -13 10 0 6 -11 10 -25 10 -14 0 -25 5 -25 10 0 6 -33 10 -80 10 -47 0 -80 -4 -80 -10z m120 -60 c0 -5 11 -10 24 -10 28 0 68 -38 91 -87 13 -27 16 -53 13 -103 -5 -64 -8 -70 -49 -111 -51 -51 -115 -77 -147 -60 -11 6 -31 11 -44 11 -13 0 -30 9 -38 20 -8 11 -22 20 -30 20 -23 0 -60 83 -60 134 0 81 51 161 111 173 16 3 29 9 29 14 0 5 23 9 50 9 28 0 50 -4 50 -10z"/> <path d="M2240 1990 c0 -5 -16 -10 -35 -10 -19 0 -35 -4 -35 -9 0 -6 -21 -11 -47 -13 l-48 -3 -3 -52 c-3 -52 -3 -53 25 -53 15 1 46 7 68 15 22 8 51 15 65 15 14 0 42 5 62 10 29 8 38 17 43 40 12 53 -1 70 -51 70 -24 0 -44 -4 -44 -10z"/> <path d="M5030 1960 c0 -48 24 -67 96 -76 27 -3 66 -12 86 -20 34 -12 42 -12 73 3 28 13 35 23 35 45 0 21 -5 28 -20 28 -11 0 -20 5 -20 10 0 6 -22 10 -50 10 -27 0 -50 5 -50 10 0 6 -11 10 -25 10 -14 0 -25 5 -25 10 0 6 -22 10 -50 10 l-50 0 0 -40z"/> <path d="M1740 1845 c-7 -8 -21 -15 -31 -15 -11 0 -28 -4 -39 -10 -11 -5 -29 -14 -40 -20 -11 -5 -29 -10 -40 -10 -23 0 -25 -17 -8 -55 9 -19 19 -25 45 -25 18 0 41 4 51 9 9 5 37 15 62 22 25 7 49 16 55 21 5 4 22 8 37 8 27 0 28 2 28 45 l0 45 -54 0 c-35 0 -58 -5 -66 -15z"/> <path d="M5980 1825 c0 -8 -4 -15 -10 -15 -5 0 -10 -13 -10 -30 0 -29 1 -30 50 -30 l50 0 0 39 c0 35 -3 39 -31 45 -45 9 -49 8 -49 -9z"/> <path d="M5280 1781 c0 -11 -4 -23 -10 -26 -5 -3 -10 -19 -10 -36 0 -25 4 -29 26 -29 14 0 32 6 40 14 19 20 18 82 -2 90 -29 11 -44 6 -44 -13z"/> <path d="M1318 1692 c-10 -2 -18 -8 -18 -13 0 -5 -17 -9 -38 -9 -26 0 -42 -6 -52 -20 -8 -11 -26 -20 -40 -20 -36 0 -50 -18 -50 -63 l0 -39 43 7 c60 9 77 15 77 26 0 5 13 9 28 9 16 0 37 9 49 19 11 11 31 21 44 23 20 2 25 10 27 39 3 33 1 37 -25 41 -15 2 -36 2 -45 0z"/> <path d="M5980 1650 c0 -33 3 -40 20 -40 11 0 20 -4 20 -8 0 -4 21 -14 47 -21 25 -8 59 -20 74 -28 14 -7 44 -14 65 -16 38 -2 39 -1 42 33 3 33 0 37 -33 50 -19 7 -35 17 -35 22 0 4 -9 8 -20 8 -11 0 -20 5 -20 10 0 6 -11 10 -25 10 -14 0 -25 5 -25 10 0 6 -25 10 -55 10 l-55 0 0 -40z"/> <path d="M5403 1542 c-24 -29 -30 -52 -13 -52 6 0 10 -11 10 -25 0 -31 34 -35 50 -6 14 27 13 84 -2 99 -17 17 -20 15 -45 -16z"/> <path d="M5880 1549 c0 -36 19 -59 49 -59 19 0 31 7 38 23 16 34 -5 57 -51 57 -30 0 -36 -4 -36 -21z"/> <path d="M778 1449 c-72 -38 -99 -58 -108 -79 -17 -42 -5 -70 31 -70 16 0 29 5 29 10 0 6 9 10 20 10 11 0 20 5 20 10 0 6 9 10 20 10 11 0 20 5 20 10 0 6 7 10 16 10 9 0 29 14 44 30 15 17 35 30 45 30 13 0 16 8 13 38 -4 54 -33 52 -150 -9z"/> <path d="M6433 1488 c-13 -6 -23 -16 -23 -23 0 -14 64 -85 77 -85 15 0 63 -25 63 -32 0 -5 9 -8 20 -8 11 0 20 -4 20 -10 0 -5 9 -10 20 -10 11 0 20 -4 20 -10 0 -5 9 -10 20 -10 11 0 20 5 20 10 0 6 7 10 15 10 24 0 18 48 -10 75 -13 14 -31 25 -40 25 -8 0 -15 5 -15 10 0 6 -8 10 -17 10 -9 0 -33 11 -53 25 -43 30 -87 38 -117 23z"/> <path d="M420 1250 c0 -5 -5 -10 -11 -10 -17 0 -122 -75 -152 -109 -34 -38 -33 -74 1 -79 23 -3 82 18 82 29 0 3 18 14 40 24 22 10 40 22 40 26 0 4 8 10 19 14 28 9 61 40 61 59 0 9 -4 16 -10 16 -5 0 -10 9 -10 20 0 16 -7 20 -30 20 -16 0 -30 -4 -30 -10z"/> <path d="M6872 1240 c-12 -12 -22 -24 -22 -29 0 -15 35 -47 90 -84 30 -20 60 -41 66 -46 23 -19 54 -31 78 -31 24 0 26 4 26 40 0 32 -5 43 -27 57 -16 10 -34 23 -41 30 -7 7 -17 13 -22 13 -5 0 -20 11 -34 25 -14 14 -34 25 -45 25 -11 0 -23 5 -26 10 -9 15 -19 12 -43 -10z"/> </g> </svg> ';

  return Container(
    width: 336.51,
    height: 257,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(13.02),
      color: backgroundColor,
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weather',
                style: TextStyle(
                  fontSize: 17.25,
                  color: textColor,
                ),
              ),
              Row(
                children: [
                  Iconify(
                    Mdi.weather_partly_cloudy,
                    size: 64.69,
                    color: textColor,
                  ),
                  Text(
                    '+25°C',
                    style: TextStyle(
                      fontSize: 25.88,
                      color: textColor,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Iconify(
                  Mdi.thermometer_lines,
                  size: 30,
                  color: textColor,
                ),
                SizedBox(height: 4.31),
                Text(
                  '+22°C',
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 4.31),
                Text(
                  'Soil temp',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Iconify(
                  Mdi.water_outline,
                  size: 30,
                  color: textColor,
                ),
                SizedBox(height: 4.31),
                Text(
                  '59%',
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 4.31),
                Text(
                  'Humidity',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Iconify(
                  Ph.wind_fill,
                  size: 30,
                  color: textColor,
                ),
                SizedBox(height: 4.31),
                Text(
                  '6 m/s',
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 4.31),
                Text(
                  'Wind',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Iconify(
                  Mdi.weather_pouring,
                  size: 30,
                  color: textColor,
                ),
                SizedBox(height: 4.31),
                Text(
                  '0 mm',
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 4.31),
                Text(
                  'Precipitation',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 19,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  '5:25 am',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: textColor,
                  ),
                ),
                Text(
                  'Sunrise',
                  style: TextStyle(
                      fontSize: 13.5,
                      color: textColor,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
            Iconify(
              srsssvg,
              size: 50,
            ),
            Column(
              children: [
                Text(
                  '8:04 pm',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: textColor,
                  ),
                ),
                Text(
                  'Sunset',
                  style: TextStyle(
                      fontSize: 13.5,
                      color: textColor,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ],
        )
      ],
    ),
  );
}

Widget dayPicker(bool isDark) {
  const Map daysoftheweek = {
    'Mon': '27',
    'Tue': '28',
    'Wed': '29',
    'Thr': '30',
    'Fri': '31',
    'Sat': '1',
    'Sun': '2',
  };

  List<bool> states = List.generate(8, (_) => false);

  List<Widget> elements = [];

  daysoftheweek.forEach((key, value) =>
      elements.add(DayElement(weekday: key, date: value, isDark: isDark)));

  return Container(
    height: 47,
    width: 352,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.36),
      color: tertiaryColor,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: elements,
    ),
  );
}

class DayElement extends StatelessWidget {
  DayElement(
      {Key? key,
      required this.isDark,
      required this.weekday,
      required this.date})
      : super(key: key);

  bool clicked = false;
  final bool isDark;
  final String weekday;
  final String date;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 23,
      width: 35.72,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          backgroundColor: clicked ? secondaryColor : tertiaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
              //to set border radius to button
              borderRadius: BorderRadius.circular(12.54)),
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                weekday,
                style: TextStyle(
                  fontSize: 9.41,
                  color: primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 10.45,
                  color: tertiaryColorDark,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
