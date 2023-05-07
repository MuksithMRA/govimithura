import 'package:flutter/material.dart';
import 'package:govimithura/providers/crop_provider.dart';
import 'package:govimithura/providers/ml_provider.dart';
import 'package:govimithura/utils/screen_size.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:provider/provider.dart';

import '../../../models/climate_parameter.dart';

class CropDetailsScreen extends StatefulWidget {
  final MLProvider pML;
  const CropDetailsScreen({super.key, required this.pML});

  @override
  State<CropDetailsScreen> createState() => _CropDetailsScreenState();
}

class _CropDetailsScreenState extends State<CropDetailsScreen> {
  bool _isCropLoading = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => initialize());
  }

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
              "Best Crop to cultivate in your home garden",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            spacingWidget(ScreenSize.height * 0.05, SpaceDirection.vertical),
            Consumer<CropProvider>(
              builder: (context, cropProvider, child) {
                return _isCropLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SizedBox(
                        height: ScreenSize.height * 0.25,
                        width: ScreenSize.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        cropProvider.cropEntity.image,
                                      ),
                                      fit: BoxFit.cover)),
                              height: ScreenSize.height * 0.25,
                              width: ScreenSize.width * 0.4,
                            ),
                            spacingWidget(10, SpaceDirection.horizontal),
                            SizedBox(
                              width: ScreenSize.width * 0.46,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cropProvider.cropEntity.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      cropProvider.cropEntity.description,
                                      style: const TextStyle(
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

  loadCrop() async {
    CropProvider pCrop = Provider.of<CropProvider>(context, listen: false);
    pCrop.setCrop(widget.pML.bestCrop);
    setState(() {
      _isCropLoading = !_isCropLoading;
    });

    if (mounted) {
      await pCrop.getCropByName(context);
    }
    setState(() {
      _isCropLoading = !_isCropLoading;
    });
  }

  Future<void> initialize() async {
    return loadCrop();
  }
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

  static List<charts.Series<ClimateParameter, String>> _createSampleData(
      BuildContext context) {
    final data = [
      ClimateParameter('Temperature', 10),
      ClimateParameter('Rainfall', 20),
      ClimateParameter('Humidity', 15),
      ClimateParameter('Evoporation', 8),
    ];

    return [
      charts.Series<ClimateParameter, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ClimateParameter climate, _) => climate.x,
        measureFn: (ClimateParameter climate, _) => climate.y,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (ClimateParameter climate, _) =>
            charts.ColorUtil.fromDartColor(Theme.of(context).primaryColor),
        data: data,
      )
    ];
  }
}
