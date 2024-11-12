import 'package:flutter/material.dart';
import 'package:go_green/screens/home/components/offer_carousel_and_categories.dart';
import 'package:go_green/screens/home/components/popular_products.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: OffersCarouselAndCategories(),
            ),
            const SliverToBoxAdapter(
              child: const PopularProducts(),
            ),
            // const SliverPadding(
            //   padding: EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
            //   sliver: SliverToBoxAdapter(child: FlashSale()),
            // ),
            // SliverToBoxAdapter(
            //   child: Column(
            //     children: [
            //       // While loading use 👇
            //       // const BannerMSkelton(),‚
            //       BannerSStyle1(
            //         title: "New \narrival",
            //         subtitle: "SPECIAL OFFER",
            //         discountParcent: 50,
            //         press: () {
            //           // Navigator.pushNamed(context, onSaleScreenRoute);
            //         },
            //       ),
            //       const SizedBox(height: defaultPadding / 4),
            //       // We have 4 banner styles, all in the pro version
            //     ],
            //   ),
            // ),
            // const SliverToBoxAdapter(
            //   child: BestSellers(),
            // ),
            // const SliverToBoxAdapter(
            //   child: MostPopular(),
            // ),
            // SliverToBoxAdapter(
            //   child: Column(
            //     children: [
            //       const SizedBox(height: defaultPadding * 1.5),
            //
            //       const SizedBox(height: defaultPadding / 4),
            //       // While loading use 👇
            //       // const BannerSSkelton(),
            //       BannerSStyle5(
            //         title: "Black \nfriday",
            //         subtitle: "50% Off",
            //         bottomText: "Collection".toUpperCase(),
            //         press: () {
            //           // Navigator.pushNamed(context, onSaleScreenRoute);
            //         },
            //       ),
            //       const SizedBox(height: defaultPadding / 4),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}