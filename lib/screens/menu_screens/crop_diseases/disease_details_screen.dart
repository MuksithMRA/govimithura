import 'package:flutter/material.dart';
import 'package:govimithura/providers/disease_provider.dart';
import 'package:govimithura/providers/img_util_provider.dart';
import 'package:govimithura/utils/loading_overlay.dart';
import 'package:govimithura/utils/screen_size.dart';
import 'package:provider/provider.dart';

class DiseaseDetailsScreen extends StatefulWidget {
  const DiseaseDetailsScreen({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    Provider.of<ImageUtilProvider>(context, listen: false)
                        .image,
              ),
              title: Text(Provider.of<DiseaseProvider>(context, listen: true)
                  .entityModel
                  .description),
              subtitle: const Text("Crop Name"),
            ),
            const Text(
              "Bacterial Spot",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/images/disease_inner.png"),
              )),
              height: ScreenSize.height * 0.3,
              width: ScreenSize.width,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return const ListTile(
                    minLeadingWidth: 10,
                    leading: Text(
                      '\u2022',
                      style: TextStyle(fontSize: 30),
                    ),
                    title: Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initialize() async {
    await LoadingOverlay.of(context).during(pDisease.getLeafsById(1));
  }
}
