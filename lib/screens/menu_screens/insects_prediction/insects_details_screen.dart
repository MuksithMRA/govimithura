import 'package:flutter/material.dart';
import 'package:govimithura/providers/insect_provider.dart';
import 'package:govimithura/utils/loading_overlay.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:provider/provider.dart';

import '../../../utils/screen_size.dart';
import 'insects_control_methods_screen.dart';

class InsectsDetailsScreen extends StatefulWidget {
  const InsectsDetailsScreen({super.key});

  @override
  State<InsectsDetailsScreen> createState() => _InsectsDetailsScreenState();
}

class _InsectsDetailsScreenState extends State<InsectsDetailsScreen> {
  late InsectProvider pInsect;
  @override
  void initState() {
    super.initState();
    pInsect = Provider.of<InsectProvider>(context, listen: false);
    Future.delayed(Duration.zero, () => initialize());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                SlidePageRoute(
                  page: const InsectsControlMethodsScreen(),
                ),
              );
            },
            label: const Text("Cultural Pest Control Methods")),
        appBar: AppBar(
          title: const Text("Pest Details"),
          centerTitle: true,
        ),
        body: Consumer<InsectProvider>(
          builder: (context, insect, child) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                height: ScreenSize.height,
                width: ScreenSize.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        insect.selectedInsect.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      spacingWidget(20, SpaceDirection.vertical),
                      if (insect.selectedInsect.image.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image:
                                    NetworkImage(insect.selectedInsect.image),
                                fit: BoxFit.cover,
                              )),
                          height: ScreenSize.height * 0.3,
                          width: ScreenSize.width,
                        ),
                      spacingWidget(20, SpaceDirection.vertical),
                      Text(
                        insect.selectedInsect.description,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  Future<void> initialize() async {
    await LoadingOverlay.of(context).during(pInsect.getInsectById(context));
  }
}
