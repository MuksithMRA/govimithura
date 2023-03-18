import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../theme/theme_manager.dart';
import 'home_provider.dart';
import 'img_util_provider.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<ThemeManager>(
    create: (_) => ThemeManager(),
  ),
  ChangeNotifierProvider<HomeProvider>(
    create: (_) => HomeProvider(),
  ),
  ChangeNotifierProvider<ImageUtilProvider>(
    create: (_) => ImageUtilProvider(),
  ),
];
