import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../theme/theme_manager.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => ThemeManager()),
];
