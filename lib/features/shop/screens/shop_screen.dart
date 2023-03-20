import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holiday_fair/constants/themes/colors.dart';
import 'package:holiday_fair/features/map/controllers/map_controller.dart';
import 'package:holiday_fair/features/shop/controllers/shop_controller.dart';
import 'package:holiday_fair/features/shop/models/shop_model.dart';
import 'package:holiday_fair/utils/get_current_location.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mapProvider = Provider.of<MapController>(context, listen: false);
    var zone = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      backgroundColor: kColorsWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 60,
        title: Text('Shop', style: Theme.of(context).textTheme.headline1),
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: kColorsBlue,
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/btn_back.svg', color: kColorsWhite),
          onPressed: (){
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: FutureBuilder(
        future: ShopController().getAllShops(context, zone),
        builder: (BuildContext context, AsyncSnapshot<List<ShopModel>> snapshot) {
          if(snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          else if(snapshot.connectionState == ConnectionState.done) {
            List<ShopModel> shopList = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: shopBody(shopList, mapProvider),
            );
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget shopBody(List<ShopModel> shopList, MapController mapProvider) {
    final Completer<GoogleMapController> controller = Completer();

    return ListView.builder(
      itemCount: shopList.length,
      itemBuilder: (BuildContext context, int index) {
        ShopModel shop = shopList[index];

        return InkWell(
          onTap: (){
            getCurrentLocation(controller, mapProvider);
            mapProvider.setSelectedShop(shop);
            Navigator.pushNamed(context, '/map', arguments: '/shop');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                          image: AssetImage(shop.image),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(shop.name, style: Theme.of(context).textTheme.subtitle1),
                        const SizedBox(height: 5),
                        Text('${shop.zone} zone', style: Theme.of(context).textTheme.bodyText1),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: kColorsRed, size: 16),
                            Text('${shop.distance.toStringAsFixed(2)} km', style: Theme.of(context).textTheme.bodyText2),
                            const SizedBox(width: 10),
                            const Icon(Icons.star, color: kColorsYellow, size: 16),
                            Text(shop.rating.toString(), style: Theme.of(context).textTheme.bodyText2),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: kColorsGrey,
                )
              ],
            ),
          ),
        );
      }
    );
  }
}