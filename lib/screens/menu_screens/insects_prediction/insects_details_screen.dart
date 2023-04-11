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
          title: const Text("Insect Details"),
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
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage("assets/images/insect_inner.png"),
                        )),
                        height: ScreenSize.height * 0.3,
                        width: ScreenSize.width,
                      ),
                      Text(insect.selectedInsect.description)
                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   itemCount: 2,
                      //   itemBuilder: (BuildContext context, int index) {
                      //     return const ListTile(
                      //       minLeadingWidth: 10,
                      //       leading: Text(
                      //         '\u2022',
                      //         style: TextStyle(fontSize: 30),
                      //       ),
                      //       title: Text(
                      //           "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."),
                      //     );
                      //   },
                      // ),
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
