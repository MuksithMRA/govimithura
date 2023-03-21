import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:govimithura/utils/utils.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';

class InsectsControlMethodsScreen extends StatefulWidget {
  const InsectsControlMethodsScreen({super.key});

  @override
  State<InsectsControlMethodsScreen> createState() =>
      _InsectsControlMethodsScreenState();
}

class _InsectsControlMethodsScreenState
    extends State<InsectsControlMethodsScreen> {
  bool isBookMarked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cultural Pest Control Methods'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(
                5,
                (index) => ExpansionTile(
                      initiallyExpanded: index == 0,
                      title: const Text(
                        'Garlic and pepper spray',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/images/user.png"),
                                ),
                                title: Row(
                                  children: [
                                    const Text("Written By"),
                                    Flexible(
                                      child: RatingBar.builder(
                                        onRatingUpdate: (value) {},
                                        initialRating: 3,
                                        minRating: 1,
                                        itemSize: 15,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "(20)",
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                                subtitle: const Text("john doe"),
                                trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isBookMarked = !isBookMarked;
                                    });

                                    if (isBookMarked) {
                                      Utils.showSnackBar(context, "Bookmarked");
                                    } else {
                                      Utils.showSnackBar(
                                          context, "Removed from bookmark");
                                    }
                                  },
                                  icon: isBookMarked
                                      ? Icon(Icons.bookmark_rounded,
                                          color: Theme.of(context).primaryColor)
                                      : const Icon(Icons.bookmark_add_rounded),
                                ),
                              ),
                              spacingWidget(10, SpaceDirection.vertical),
                              const Text(
                                  'Garlic and pepper spray: Garlic and pepper spray can be made at home and sprayed on plants to repel flea beetles. Mix garlic and hot peppers in water, let it steep overnight, then strain and spray the mixture on the plants.'),
                              spacingWidget(10, SpaceDirection.vertical),
                            ],
                          ),
                        )
                      ],
                    )),
          ],
        ),
      ),
    );
  }
}
