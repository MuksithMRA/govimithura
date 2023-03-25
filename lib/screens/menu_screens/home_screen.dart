import 'package:flutter/material.dart';
import 'package:govimithura/providers/home_provider.dart';
import 'package:govimithura/utils/screen_size.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:govimithura/widgets/utils/image_util.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<ComponentMenuTile> componentMenuTiles = [
      ComponentMenuTile(
        title: "Crops",
        description:
            "What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing ",
        image: "crops_home.png",
        routeIndex: 1,
      ),
      ComponentMenuTile(
        title: "Insects",
        description:
            "What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing ",
        image: "insects_home.png",
        routeIndex: 3,
      ),
      ComponentMenuTile(
        title: "Diseases",
        description:
            "What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing ",
        image: "diseases_home.png",
        routeIndex: 2,
      ),
      ComponentMenuTile(
        title: "Chat Bot",
        description:
            "What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing ",
        image: "chat_bots_home.png",
        routeIndex: 4,
      ),
    ];
    return Stack(
      children: [
        Container(
          height: ScreenSize.height,
          width: ScreenSize.width,
          color: Theme.of(context).primaryColor,
          child: Column(
            children: [
              const Text(
                "Current Temperature",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              spacingWidget(10, SpaceDirection.vertical),
              const Text(
                "29 C",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: ScreenSize.height * 0.12,
          height: ScreenSize.height * 0.725,
          width: ScreenSize.width,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSize.width * 0.05,
              vertical: ScreenSize.height * 0.02,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const CustomAssetImage(
                    assetName: 'home_thumbnail.png',
                  ),
                  spacingWidget(10, SpaceDirection.vertical),
                  ...List.generate(
                    4,
                    (index) {
                      return Column(
                        children: [
                          _buildComponentCard(componentMenuTiles[index],
                              context: context),
                          spacingWidget(5, SpaceDirection.vertical),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComponentCard(ComponentMenuTile componentMenuTile,
      {required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        Provider.of<HomeProvider>(context, listen: false)
            .onNavigationChange(componentMenuTile.routeIndex);
      },
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenSize.width * 0.05,
            vertical: ScreenSize.height * 0.02,
          ),
          width: ScreenSize.width,
          child: Row(
            children: [
              Flexible(
                child: CustomAssetImage(
                  assetName: componentMenuTile.image,
                  fit: BoxFit.fill,
                ),
              ),
              spacingWidget(10, SpaceDirection.horizontal),
              Flexible(
                flex: 2,
                child: SizedBox(
                  width: ScreenSize.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        componentMenuTile.title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      spacingWidget(5, SpaceDirection.vertical),
                      Text(
                        componentMenuTile.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ComponentMenuTile {
  final String title;
  final String description;
  final String image;
  final int routeIndex;

  ComponentMenuTile({
    required this.title,
    required this.description,
    required this.image,
    required this.routeIndex,
  });
}
