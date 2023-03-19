import 'package:holiday_fair/features/home/screens/home_screen.dart';
import 'package:holiday_fair/features/map/screens/map_screen.dart';
import 'package:holiday_fair/features/shop/screens/shop_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';

const routeHome = '/home';
const routeMap = '/map';
const routeShop = '/shop';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeHome:
        return PageTransition(
          child: const HomeScreen(), 
          type: PageTransitionType.leftToRight
        );
      case routeMap:
        return PageTransition(
          child: const MapScreen(), 
          type: PageTransitionType.rightToLeft,
          settings: settings
        );
      case routeShop:
        return PageTransition(
          child: const ShopScreen(), 
          type: PageTransitionType.rightToLeft,
          settings: settings
        );

      default:
        return PageTransition(
          child: const HomeScreen(),
          type: PageTransitionType.rightToLeft
        );
    }
  }
}