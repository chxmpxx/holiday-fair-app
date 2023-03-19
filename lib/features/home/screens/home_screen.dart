import 'package:holiday_fair/constants/data/data_constants.dart';
import 'package:holiday_fair/constants/themes/colors.dart';
import 'package:holiday_fair/features/home/widgets/menu_btn_widget.dart';
import 'package:holiday_fair/features/home/widgets/zone_btn_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorsWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 60,
        title: Text('Holiday Fair', style: Theme.of(context).textTheme.headline1),
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: kColorsBlue,
      ),
      body: ListView(
        children: [
          // section 1
          Container(
            width: MediaQuery.of(context).size.width,
            color: kColorsGrey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  menuBtnWidget(context, 'Shop', 'menu_shop.svg', (){
                    Navigator.pushNamed(context, '/shop');
                  }),
                  menuBtnWidget(context, 'Map', 'menu_map.svg', (){
                    Navigator.pushNamed(context, '/map', arguments: '/home');
                  }),
                ],
              ),
            ),
          ),
      
          // section 2
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 26),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Zone', style: Theme.of(context).textTheme.headline2)
            ),
          ),
          const SizedBox(height: 26),
          Center(
            child: Wrap(
              runSpacing: MediaQuery.of(context).size.width * 0.05,
              spacing: MediaQuery.of(context).size.width * 0.1,
              children: [
                ...List.generate(zoneList.length, (index) {
                    return InkWell(
                      onTap: () {},
                      child: zoneBtnWidget(context, zoneList[index], zoneIconList[index])
                    );
                  }
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}