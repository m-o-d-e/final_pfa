import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import './bar_chart.dart';
import './line_chart.dart';

class ChartCarousel extends StatefulWidget {
  const ChartCarousel({Key? key})
      : // ignore: deprecated_member_use
        super(key: key);

  @override
  State<ChartCarousel> createState() => _ChartCarouselState();
}

class _ChartCarouselState extends State<ChartCarousel> {
  int activeIndex = 0;
  final controller = CarouselController();
  final charts = [
    BarChartWidget(),
    LineChartWidget(),
    BarChartWidget(),
    LineChartWidget(),
  ];

  Widget buildchart(index) {
    return Container(
      width: 600,
      decoration: BoxDecoration(
        color: Color(0xFFDFF4EB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: charts[index],
    );
  }

  //Go To Page i
  // ElevatedButton(
  //           onPressed: () {
  //             controller.animateToPage(++activeIndex);
  //           },
  //           child: Text("Go To"))

  Widget _buildSwitchButtons(Icon icon, int index, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          color: const Color(0xFF12BA6C),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          IconButton(
            icon: icon,
            onPressed: () {
              controller.animateToPage(index);
            },
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSwitchButtons(
                  const Icon(
                    Icons.thermostat,
                    color: Colors.white,
                  ),
                  0,
                  "°C"),
              _buildSwitchButtons(
                  const Icon(
                    Icons.cloudy_snowing,
                    color: Colors.white,
                  ),
                  1,
                  "mm"),
              _buildSwitchButtons(
                  const Icon(
                    Icons.air,
                    color: Colors.white,
                  ),
                  2,
                  "km/h"),
              _buildSwitchButtons(
                  const Icon(
                    Icons.calculate_sharp,
                    color: Colors.white,
                  ),
                  3,
                  "ET0"),
            ],
          ),
        ),
        CarouselSlider.builder(
          carouselController: controller,
          itemCount: charts.length,
          itemBuilder: (context, index, realIndex) {
            //return buildImage(urlImages[index], index);
            return buildchart(index);
          },
          options: CarouselOptions(
            height: 400,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) =>
                setState(() => activeIndex = index),
          ),
        ),
        const SizedBox(height: 12),
        buildIndicator()
      ],
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        onDotClicked: animateToSlide,
        effect: const ExpandingDotsEffect(
            dotWidth: 15, activeDotColor: Colors.blue),
        activeIndex: activeIndex,
        count: charts.length,
      );

  void animateToSlide(int index) => controller.animateToPage(index);
}
