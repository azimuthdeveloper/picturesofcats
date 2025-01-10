import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class AdWidget extends StatelessWidget {
  const AdWidget({
    super.key,
    required this.availableProducts,
  });

  final List<ProductDetails> availableProducts;

  @override
  Widget build(BuildContext context) {
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
            alignment: Alignment.topRight,
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
                                        ?.copyWith(fontStyle: FontStyle.italic),
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
                                    final premium = availableProducts
                                        .firstWhere((x) => x.id == 'premium');
                                    final purchaseParam =
                                        PurchaseParam(productDetails: premium);
                                    InAppPurchase.instance.buyNonConsumable(
                                        purchaseParam: purchaseParam);
                                  },
                                  child: Text('Subscribe for only \$2 a month'),
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                );
              },
              icon: Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
