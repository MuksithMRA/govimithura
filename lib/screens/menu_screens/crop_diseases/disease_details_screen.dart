import 'package:flutter/material.dart';
import 'package:govimithura/providers/disease_provider.dart';
import 'package:govimithura/providers/img_util_provider.dart';
import 'package:govimithura/utils/loading_overlay.dart';
import 'package:govimithura/utils/screen_size.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:provider/provider.dart';

class DiseaseDetailsScreen extends StatefulWidget {
  final int leafId;
  final int diseaseId;
  const DiseaseDetailsScreen(
      {super.key, required this.leafId, required this.diseaseId});

  @override
  State<DiseaseDetailsScreen> createState() => _DiseaseDetailsScreenState();
}

class _DiseaseDetailsScreenState extends State<DiseaseDetailsScreen> {
  late DiseaseProvider pDisease;

  @override
  void initState() {
    super.initState();
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
                            image:
                                AssetImage("assets/images/disease_inner.png"),
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
                    )
                    // Expanded(
                    //   child: ListView.builder(
                    //     shrinkWrap: true,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     itemCount: 3,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       return const ListTile(
                    //         minLeadingWidth: 10,
                    //         leading: Text(
                    //           '\u2022',
                    //           style: TextStyle(fontSize: 30),
                    //         ),
                    //         title: Text(
                    //             "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                );
              },
            )),
      ),
    );
  }

  Future<void> initialize() async {
    await LoadingOverlay.of(context).during(
        pDisease.getLeafsById(widget.leafId, widget.diseaseId, context));
  }
}
