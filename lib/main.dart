import 'package:holiday_fair/constants/themes/styles.dart';
import 'package:holiday_fair/features/map/controllers/map_controller.dart';
import 'package:holiday_fair/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MapController()),
      ],
      child: MaterialApp(
        theme: appTheme(),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}