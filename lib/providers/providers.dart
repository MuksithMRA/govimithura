import 'package:govimithura/providers/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../theme/theme_manager.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<ThemeManager>(
    create: (_) => ThemeManager(),
  ),
  ChangeNotifierProvider<HomeProvider>(
    create: (_) => HomeProvider(),
  ),
];
