import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'ad.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final purchaseUpdated = InAppPurchase.instance.purchaseStream;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final List<ProductDetails> availableProducts = [];

  bool subscribed = false;

  @override
  void initState() {
    _subscription = purchaseUpdated.listen((purchaseDetailsList) async {
      if (!context.mounted) {
        _subscription.cancel();
        return;
      }
      for (final purchase in purchaseDetailsList) {
        switch (purchase.status) {
          case PurchaseStatus.pending:
            await showDialog(
              context: context,
              builder: (builder) => SimpleDialog(
                children: [
                  Text(
                    purchase.productID,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text("The purchase is pending"),
                ],
              ),
            );
          case PurchaseStatus.purchased || PurchaseStatus.restored:
            if (purchase.productID == 'premium') {
              setState(() {
                subscribed = true;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Thanks for subscribing! 😻"),
                ),
              );
            }

          case PurchaseStatus.error:
            await showDialog(
              context: context,
              builder: (builder) => SimpleDialog(
                children: [
                  Text(
                    purchase.productID,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                      "The purchase had a problem: ${purchase.error?.message}"),
                ],
              ),
            );
          case PurchaseStatus.canceled:
            await showDialog(
              context: context,
              builder: (builder) => SimpleDialog(
                children: [
                  Text(
                    purchase.productID,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text("The purchase was cancelled."),
                ],
              ),
            );
        }
        if (purchase.pendingCompletePurchase) {
          print('Completing purchase for ${purchase.productID}');
          await InAppPurchase.instance.completePurchase(purchase);
        }
      }
    }, onDone: () {
      _subscription.cancel();
    });

    const productsForSale = {'premium'};
    InAppPurchase.instance
        .queryProductDetails(productsForSale)
        .then((response) {
      availableProducts.clear();
      availableProducts.addAll(response.productDetails);
    });

    InAppPurchase.instance.restorePurchases();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.teal,
            pinned: true,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Pictures Of Cats 😺"),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.teal,
                      Colors.blue,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250),
            itemBuilder: (context, index) {
              if (index % 5 == 0 && index > 0 && !subscribed) {
                return AdWidget(availableProducts: availableProducts);
              }
              return Card(
                elevation: 5,
                clipBehavior: Clip.antiAlias,
                child: Ink.image(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    getImageFile(index),
                  ),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              getImageFile(index),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  String getImageFile(int number) {
    // List of image file names
    final imageFiles = [
      "bulksplash-ahmadgalal-lhzhDD2eEFw.jpg",
      "bulksplash-ahmadgalal-YzRNk7MULfY.jpg",
      "bulksplash-charliedeets-TKgOIwPVmkg.jpg",
      "bulksplash-dsan_nowsay-ITQwhPIH6rw.jpg",
      "bulksplash-felixlindvik-57HqbvgG4Ww.jpg",
      "bulksplash-geraninmo-7Hi-jXthm1E.jpg",
      "bulksplash-jeanlouisaubert-sgOHDcEmpmg.jpg",
      "bulksplash-kabofoods-sR0cTmQHPug.jpg",
      "bulksplash-karishea-FCwqq2KFVwQ.jpg",
      "bulksplash-karishea-FilM6ng7VGQ.jpg",
      "bulksplash-stocktrader-7WxbAzH8mVY.jpg",
      "bulksplash-thelifeofdev-OSXZtnTyBc8.jpg",
      "bulksplash-theluckyneko-KEQzJXFfmCk.jpg",
      "bulksplash-theluckyneko-Zp-OCg7j2Fg.jpg"
    ];

    // Calculate the index by cycling through the list
    int index = number % imageFiles.length;

    // Return the image file at the calculated index
    return "assets/resized-${imageFiles[index]}";
  }
}
