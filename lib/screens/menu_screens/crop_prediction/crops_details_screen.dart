import 'package:flutter/material.dart';
import 'package:govimithura/utils/screen_size.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

class CropDetailsScreen extends StatelessWidget {
  const CropDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Details"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Best Crops to cultivate in your home garden",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            spacingWidget(ScreenSize.height * 0.05, SpaceDirection.vertical),
            SizedBox(
              height: ScreenSize.height * 0.2,
              width: ScreenSize.width * 0.9,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: ScreenSize.height * 0.2,
                    width: ScreenSize.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/tomato.png",
                                  ),
                                  fit: BoxFit.fill)),
                          height: ScreenSize.height * 0.2,
                          width: ScreenSize.width * 0.4,
                        ),
                        spacingWidget(10, SpaceDirection.horizontal),
                        SizedBox(
                          width: ScreenSize.width * 0.46,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Tomato",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ClimateChart.withSampleData(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ClimateParameters {
  final String x;
  final int y;

  ClimateParameters(this.x, this.y);
}

class ClimateChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  const ClimateChart(
      {super.key, required this.seriesList, this.animate = true});

  factory ClimateChart.withSampleData(BuildContext context) {
    return ClimateChart(
      seriesList: _createSampleData(context),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
    );
  }

  static List<charts.Series<ClimateParameters, String>> _createSampleData(
      BuildContext context) {
    final data = [
      ClimateParameters('Temperature', 10),
      ClimateParameters('Rainfall', 20),
      ClimateParameters('Humidity', 15),
      ClimateParameters('Evoporation', 8),
    ];

    return [
      charts.Series<ClimateParameters, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ClimateParameters climate, _) => climate.x,
        measureFn: (ClimateParameters climate, _) => climate.y,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (ClimateParameters climate, _) =>
            charts.ColorUtil.fromDartColor(Theme.of(context).primaryColor),
        data: data,
      )
    ];
  }
}
