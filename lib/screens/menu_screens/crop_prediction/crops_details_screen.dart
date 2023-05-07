import 'package:flutter/material.dart';
import 'package:govimithura/providers/crop_provider.dart';
import 'package:govimithura/providers/ml_provider.dart';
import 'package:govimithura/utils/screen_size.dart';
import 'package:govimithura/widgets/utils/buttons/custom_elevated_button.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:govimithura/widgets/utils/text_fields/primary_textfield.dart';
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
  ClimateParameter climateParameter = ClimateParameter('', 0);
  double ph = 0;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => initialize());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.pML.setPHValue(0);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Crop Details"),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Best crop to cultivate in your home garden",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              spacingWidget(ScreenSize.height * 0.05, SpaceDirection.vertical),
              Consumer<CropProvider>(
                builder: (context, cropProvider, child) {
                  return Column(
                    children: [
                      if (widget.pML.ph > 0)
                        if (_isCropLoading)
                          SizedBox(
                            height: ScreenSize.height * 0.3,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else
                          SizedBox(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cropProvider.cropEntity.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Text(
                                            cropProvider.cropEntity.description,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                      else
                        SizedBox(
                          height: ScreenSize.height * 0.25,
                          child: Column(
                            children: [
                              PrimaryTextField(
                                label: 'Enter PH value of your area',
                                onChanged: (value) {
                                  double val = double.tryParse(value) ?? 0;
                                  setState(() {
                                    ph = val;
                                  });
                                },
                              ),
                              spacingWidget(10, SpaceDirection.vertical),
                              CustomElevatedButton(
                                  text: 'Predict Best Crop',
                                  onPressed: () async {
                                    widget.pML.setPHValue(ph);
                                    await loadCrop();
                                  })
                            ],
                          ),
                        )
                    ],
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ClimateChart.withSampleData(
                      context, widget.pML.climateParameters, (p0) {
                    setState(() {
                      climateParameter = p0;
                    });
                  }),
                ),
              ),
              if (climateParameter.x.isNotEmpty && climateParameter.y > 0)
                Text(
                  "${climateParameter.x[0].toUpperCase() + climateParameter.x.substring(1)}  :  ${climateParameter.y}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                )
              else
                const Text("Click on bar to see value")
            ],
          ),
        ),
      ),
    );
  }

  loadCrop() async {
    CropProvider pCrop = Provider.of<CropProvider>(context, listen: false);
    setState(() {
      _isCropLoading = !_isCropLoading;
    });
    await widget.pML.predictCrop(context);
    pCrop.setCrop(widget.pML.bestCrop);
    if (mounted) {
      await pCrop.getCropByName(context);
    }
    setState(() {
      _isCropLoading = !_isCropLoading;
    });
  }

  Future<void> initialize() async {}
}

class ClimateChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;
  final ClimateParametedCallBack onClimateParameterChange;

  const ClimateChart(
      {super.key,
      required this.seriesList,
      this.animate = true,
      required this.onClimateParameterChange});

  factory ClimateChart.withSampleData(
      BuildContext context,
      List<ClimateParameter> list,
      ClimateParametedCallBack onClimateParameterChange) {
    return ClimateChart(
      seriesList: _createSampleData(context, list),
      animate: false,
      onClimateParameterChange: onClimateParameterChange,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: _onSelectionChanged,
        ),
      ],
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          zeroBound: false,
          dataIsInWholeNumbers: false,
          desiredTickCount: 10,
        ),
      ),
    );
  }

  void _onSelectionChanged(charts.SelectionModel model) {
    if (model.hasDatumSelection) {
      final selectedDatum = model.selectedDatum.first;
      onClimateParameterChange(selectedDatum.datum);
    }
  }

  static List<charts.Series<ClimateParameter, String>> _createSampleData(
      BuildContext context, List<ClimateParameter> list) {
    return [
      charts.Series<ClimateParameter, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ClimateParameter climate, _) => climate.x,
        measureFn: (ClimateParameter climate, _) => climate.y,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (ClimateParameter climate, _) =>
            charts.ColorUtil.fromDartColor(Theme.of(context).primaryColor),
        data: list,
      )
    ];
  }
}

typedef ClimateParametedCallBack = void Function(ClimateParameter);
