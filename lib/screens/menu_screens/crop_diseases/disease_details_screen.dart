import 'package:flutter/material.dart';
import 'package:govimithura/providers/disease_provider.dart';
import 'package:govimithura/providers/img_util_provider.dart';
import 'package:govimithura/utils/loading_overlay.dart';
import 'package:govimithura/utils/screen_size.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:provider/provider.dart';

import '../../../utils/utils.dart';

class DiseaseDetailsScreen extends StatefulWidget {
  final int leafId;
  final int diseaseId;
  const DiseaseDetailsScreen(
      {super.key, required this.leafId, required this.diseaseId});

  @override
  State<DiseaseDetailsScreen> createState() => _DiseaseDetailsScreenState();
}

class _DiseaseDetailsScreenState extends State<DiseaseDetailsScreen>
    with SingleTickerProviderStateMixin {
  late DiseaseProvider pDisease;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    final curvedAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    _controller.forward();
    pDisease = Provider.of<DiseaseProvider>(context, listen: false);
    Future.delayed(Duration.zero, () => initialize());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Disease Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Consumer<DiseaseProvider>(
              builder: (context, disease, child) {
                return Column(
                  children: [
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(70),
                      child: SizedBox(
                        height: 150,
                        child: Row(
                          children: [
                            spacingWidget(20, SpaceDirection.horizontal),
                            CircleAvatar(
                              onBackgroundImageError: (exception, stackTrace) =>
                                  Utils.showSnackBar(
                                      context, 'Error loading image'),
                              backgroundColor: Theme.of(context).primaryColor,
                              radius: 50,
                              backgroundImage: Provider.of<ImageUtilProvider>(
                                      context,
                                      listen: false)
                                  .image,
                            ),
                            spacingWidget(20, SpaceDirection.horizontal),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    disease.leafEntity.description,
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    "Leaf Name",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!disease.diseaseEntity.name
                        .toLowerCase()
                        .startsWith("healthy"))
                      Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            disease.diseaseEntity.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          spacingWidget(20, SpaceDirection.vertical),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                  image: AssetImage(
                                      "assets/images/disease_inner.png"),
                                  fit: BoxFit.cover),
                            ),
                            height: ScreenSize.height * 0.3,
                            width: ScreenSize.width,
                          ),
                          spacingWidget(20, SpaceDirection.vertical),
                          Text(
                            disease.diseaseEntity.description,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    else
                      _successIntro()
                  ],
                );
              },
            )),
      ),
    );
  }

  Widget _successIntro() {
    return ScaleTransition(
      scale: _animation,
      child: SizedBox(
        height: ScreenSize.height * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 120,
                color: Colors.white,
              ),
            ),
            spacingWidget(20, SpaceDirection.vertical),
            const Text(
              "This leaf is Healthy",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initialize() async {
    await LoadingOverlay.of(context).during(
      pDisease.getLeafsById(widget.leafId, widget.diseaseId, context),
    );
    // await LoadingOverlay.of(context)
    //     .during(pDisease.getLeafsById(2, 2, context));
  }
}
