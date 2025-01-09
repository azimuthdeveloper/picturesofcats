import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class HomeWidget extends StatefulWidget {
  HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final purchaseUpdated = InAppPurchase.instance.purchaseStream;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final List<ProductDetails> availableProducts = [];

  @override
  void initState() {
    final purchaseUpdated = InAppPurchase.instance.purchaseStream;

    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      print("purchase details");
      print(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    });

    const _productsForSale = {'premium'};
    final response = InAppPurchase.instance
        .queryProductDetails(_productsForSale)
        .then((response) => setState(() {
              availableProducts.clear();
              availableProducts.addAll(response.productDetails);
            }));

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
                maxCrossAxisExtent: 200),
            itemBuilder: (context, index) {
              if (index % 5 == 0 && index > 0) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.teal, Colors.blue],
                          ),
                        ),
                        child: InkWell(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Professional Cat Washers",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontStyle: FontStyle.italic),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Best service, lowest price. Get a quote today!",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (builder) => SizedBox(
                                  height: 300,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Not a fan of ads?",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge,
                                              ),
                                              Text(
                                                "Gosh, we have so much in common.",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                        fontStyle:
                                                            FontStyle.italic),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                final premium =
                                                    availableProducts
                                                        .firstWhere((x) =>
                                                            x.id == 'premium');
                                                final purchaseParam =
                                                    PurchaseParam(
                                                        productDetails:
                                                            premium);
                                                InAppPurchase.instance
                                                    .buyNonConsumable(
                                                        purchaseParam:
                                                            purchaseParam);
                                              },
                                              child: Text(
                                                  'Subscribe for only \$2 a month'),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            );
                            // Scaffold.of(context).showBottomSheet(
                            //   showDragHandle: true,
                            //   (context) => SizedBox(
                            //     child: Column(
                            //       children: [
                            //         Text("Don't like ads? Us either"),
                            //       ],
                            //     ),
                            //     height: 200,
                            //   ),
                            // );
                          },
                          icon: Icon(Icons.close),
                        ),
                        alignment: Alignment.topRight,
                      ),
                    ],
                  ),
                );
              }
              return Card(
                elevation: 5,
                clipBehavior: Clip.antiAlias,
                child: Ink.image(
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
                  fit: BoxFit.cover,
                  image: AssetImage(
                    getImageFile(index),
                  ),
                  // image: Image.asset(
                  //   getImageFile(index),
                  //   fit: BoxFit.cover,
                  // ),
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
