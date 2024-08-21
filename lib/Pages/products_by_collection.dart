import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/Model/products_model.dart';
// ignore: library_prefixes
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;
import '../Model/constant.dart';
import '../Model/sub_collections_model.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import '../Widgets/product_widget_main.dart';

class ProductByCollectionPage extends StatefulWidget {
  final String category;
  const ProductByCollectionPage({super.key, required this.category});

  @override
  State<ProductByCollectionPage> createState() =>
      _ProductByCollectionPageState();
}

class _ProductByCollectionPageState extends State<ProductByCollectionPage> {
  String imageUrl = '';
  String category = '';
  getCate() {
    context.loaderOverlay.show();
    FirebaseFirestore.instance
        .collection('Collections')
        .where('collection', isEqualTo: widget.category)
        .get()
        .then((value) {
      setState(() {
        context.loaderOverlay.hide();
        for (var element in value.docs) {
          setState(() {
            category = element['category'];
            imageUrl = element['image'];
          });
          // ignore: avoid_print
          print('Image URL is $imageUrl');
          // ignore: avoid_print
          print('Category is ${widget.category}');
        }
      });
    });
  }

  List<ProductsModel> products = [];
  List<ProductsModel> initProducts = [];
  // List<ProductsModel> productsFilter = [];
  bool isLoaded = true;

  getProducts() async {
    setState(() {
      isLoaded = true;
    });
    context.loaderOverlay.show();
    FirebaseFirestore.instance
        .collection('Products')
        // .limit(10)
        .where('collection', isEqualTo: widget.category)
        .snapshots()
        .listen((event) {
      setState(() {
        isLoaded = false;
      });
      context.loaderOverlay.hide();
      products.clear();
      for (var element in event.docs) {
        var prods = ProductsModel.fromMap(element, element.id);
        setState(() {
          products.add(prods);
          initProducts = products;
        });
      }
    });
  }

  List<SubCollectionsModel> retails = [];
  getSubCollections() {
    return FirebaseFirestore.instance
        .collection('Sub Collections')
        // .orderBy('index')
        .where('collection', isEqualTo: widget.category)
        .snapshots()
        .listen((value) {
      retails.clear();
      for (var element in value.docs) {
        setState(() {
          var fetchServices =
              SubCollectionsModel.fromMap(element.data(), element.id);
          retails.add(fetchServices);
        });
      }
    });
  }

  @override
  void initState() {
    getCate();
    getSubCollections();
    getProducts();
    getCurrency();
    super.initState();
  }

  void resetToInitialList() {
    setState(() {
      products = List.from(initProducts);
    });
  }

  @override
  void didUpdateWidget(covariant ProductByCollectionPage oldWidget) {
    getCate();
    getSubCollections();
    getProducts();
    getCurrency();

    super.didUpdateWidget(oldWidget);
  }

  String? sortBy;
  int? selectedValue;
  int? selectedCollection;
  int? rateValue;
  String currency = '';
  getCurrency() {
    FirebaseFirestore.instance
        .collection('Currency Settings')
        .doc('Currency Settings')
        .get()
        .then((value) {
      setState(() {
        currency = value['Currency symbol'];
      });
    });
  }

  void sortProductsFromLowToHigh() {
    setState(() {
      products.sort((a, b) => a.unitPrice1.compareTo(b.unitPrice1));
    });
  }

  void sortProductsFromHighToLow() {
    setState(() {
      products.sort((a, b) => b.unitPrice1.compareTo(a.unitPrice1));
    });
  }

  void sortProductsRatingFromHighToLow() {
    setState(() {
      products.sort((a, b) =>
          b.totalNumberOfUserRating.compareTo(a.totalNumberOfUserRating));
    });
  }

  void sortProductsByPriceRange(int minPrice, int maxPrice) {
    setState(() {
      products = products
          .where((user) =>
              user.unitPrice1 >= minPrice && user.unitPrice1 <= maxPrice)
          .toList();
      products.sort((a, b) => a.unitPrice1.compareTo(b.unitPrice1));
    });
  }

  void sortAndFilterProductsByRating4() {
    setState(() {
      // Sort the products based on the ratio of totalRating to totalUserRating
      products.sort((a, b) {
        double ratioA = a.totalRating / a.totalNumberOfUserRating;
        double ratioB = b.totalRating / b.totalNumberOfUserRating;
        return ratioB.compareTo(ratioA); // Sort in descending order
      });

      // Filter products with a ratio of 4 and above
      products = products.where((product) {
        double ratio = product.totalRating / product.totalNumberOfUserRating;
        return ratio >= 4.0;
      }).toList();
    });
  }

  void sortAndFilterProductsByRating3() {
    setState(() {
      // Sort the products based on the ratio of totalRating to totalUserRating
      products.sort((a, b) {
        double ratioA = a.totalRating / a.totalNumberOfUserRating;
        double ratioB = b.totalRating / b.totalNumberOfUserRating;
        return ratioB.compareTo(ratioA); // Sort in descending order
      });

      // Filter products with a ratio of 4 and above
      products = products.where((product) {
        double ratio = product.totalRating / product.totalNumberOfUserRating;
        return ratio >= 3.0;
      }).toList();
    });
  }

  void sortAndFilterProductsByRating2() {
    setState(() {
      // Sort the products based on the ratio of totalRating to totalUserRating
      products.sort((a, b) {
        double ratioA = a.totalRating / a.totalNumberOfUserRating;
        double ratioB = b.totalRating / b.totalNumberOfUserRating;
        return ratioB.compareTo(ratioA); // Sort in descending order
      });

      // Filter products with a ratio of 4 and above
      products = products.where((product) {
        double ratio = product.totalRating / product.totalNumberOfUserRating;
        return ratio >= 2.0;
      }).toList();
    });
  }

  void sortAndFilterProductsByRating1() {
    setState(() {
      // Sort the products based on the ratio of totalRating to totalUserRating
      products.sort((a, b) {
        double ratioA = a.totalRating / a.totalNumberOfUserRating;
        double ratioB = b.totalRating / b.totalNumberOfUserRating;
        return ratioB.compareTo(ratioA); // Sort in descending order
      });

      // Filter products with a ratio of 4 and above
      products = products.where((product) {
        double ratio = product.totalRating / product.totalNumberOfUserRating;
        return ratio >= 1.0;
      }).toList();
    });
  }

  void _sortBySubCollections(String subCollection) {
    setState(() {
      // Filter and sort male users.
      products = initProducts
          .where((user) => user.subCollection == subCollection)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
            ? null
            : const Color.fromARGB(255, 247, 240, 240),
        body: SingleChildScrollView(
          child: Column(children: [
            const Gap(20),
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Row(
                children: [
                  if (MediaQuery.of(context).size.width >= 1100) const Gap(20),
                  Expanded(
                      flex: 5,
                      child: Container(
                        height: MediaQuery.of(context).size.width >= 1100
                            ? 230
                            : null,
                        decoration: BoxDecoration(color: appColor),
                        child: Center(
                          child: Text(
                            widget.category,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width >= 1100
                                        ? 30
                                        : 15,
                                fontFamily: 'Rubi'),
                          ),
                        ),
                      )),
                  if (MediaQuery.of(context).size.width >= 1100) const Gap(20),
                  Expanded(
                      flex: 6,
                      child: ExtendedImage.network(
                        imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        // width: ScreenUtil.instance.setWidth(400),
                        // height: ScreenUtil.instance.setWidth(400),
                        fit: MediaQuery.of(context).size.width >= 1100
                            ? BoxFit.cover
                            : BoxFit.cover,
                        cache: true,
                        //border: Border.all(color: Colors.red, width: 1.0),
                        // shape: boxShape,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30.0)),
                        //cancelToken: cancellationToken,
                      )),
                  if (MediaQuery.of(context).size.width >= 1100) const Gap(20),
                ],
              ),
            ),
            const Gap(20),
            if (MediaQuery.of(context).size.width >= 1100)
              Align(
                alignment: MediaQuery.of(context).size.width >= 1100
                    ? Alignment.centerLeft
                    : Alignment.center,
                child: Padding(
                  padding: MediaQuery.of(context).size.width >= 1100
                      ? const EdgeInsets.only(left: 60, right: 120)
                      : const EdgeInsets.all(0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          context.push('/');
                        },
                        child: const Text(
                          'Home',
                          style: TextStyle(fontSize: 12),
                        ).tr(),
                      ),
                      InkWell(
                        onTap: () {
                          context.push('/products/$category');
                        },
                        child: Text(
                          '/ $category ',
                          style: const TextStyle(fontSize: 12),
                        ).tr(),
                      ),
                      Text(
                        '/ ${widget.category}',
                        style: const TextStyle(fontSize: 12),
                      ).tr(),
                    ],
                  ),
                ),
              ),
            if (MediaQuery.of(context).size.width >= 1100) const Gap(10),
            MediaQuery.of(context).size.width >= 1100
                ? Padding(
                    padding: MediaQuery.of(context).size.width >= 1100
                        ? const EdgeInsets.only(left: 50, right: 50)
                        : const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Card(
                              shape: const BeveledRectangleBorder(),
                              surfaceTintColor: Colors.white,
                              //r  shadowColor: Colors.white,
                              //  elevation: 1,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: const Text(
                                          'Sub Collections',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11),
                                        ).tr(),
                                        trailing: selectedCollection == null
                                            ? null
                                            : TextButton(
                                                child: const Text(
                                                  'Clear',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedCollection = null;
                                                    resetToInitialList();
                                                  });
                                                },
                                              ),
                                      ),
                                      isLoaded == true
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: 10,
                                              itemBuilder: (context, index) {
                                                return Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: ListTile(
                                                    title: Container(
                                                      height: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemExtent: 35.0,
                                              itemCount: retails.length,
                                              itemBuilder: (context, index) {
                                                SubCollectionsModel
                                                    subCategoriesCollectionsModel =
                                                    retails[index];
                                                return RadioListTile(
                                                  title: Text(
                                                    subCategoriesCollectionsModel
                                                        .subCollection,
                                                    style: const TextStyle(
                                                        fontSize: 11),
                                                  ),
                                                  value: index,
                                                  groupValue:
                                                      selectedCollection,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedCollection =
                                                          value;
                                                    });
                                                    resetToInitialList();
                                                    _sortBySubCollections(
                                                        subCategoriesCollectionsModel
                                                            .subCollection);
                                                    // resetToInitialList();
                                                    // sortProductsByPriceRange(1, 2000);
                                                  },
                                                );
                                              }),
                                      const Gap(10),
                                      const Divider(
                                        color: Colors.grey,
                                        thickness: 1,
                                      ),
                                      ListTile(
                                        title: const Text(
                                          'Price',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11),
                                        ).tr(),
                                        trailing: selectedValue == null
                                            ? null
                                            : TextButton(
                                                child: const Text(
                                                  'Clear',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedValue = null;
                                                    resetToInitialList();
                                                  });
                                                },
                                              ),
                                      ),
                                      ListView(
                                        shrinkWrap: true,
                                        itemExtent: 35.0,
                                        //padding: EdgeInsets.symmetric(vertical:20),
                                        children: [
                                          RadioListTile(
                                            title: Text(
                                              'Under ${currency}2,000',
                                              style:
                                                  const TextStyle(fontSize: 11),
                                            ),
                                            value: 1,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              resetToInitialList();
                                              sortProductsByPriceRange(1, 2000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                '${currency}2,000 - ${currency}5,000',
                                                style: const TextStyle(
                                                    fontSize: 11)),
                                            value: 2,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              resetToInitialList();
                                              sortProductsByPriceRange(
                                                  2000, 5000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                '${currency}5,000 - ${currency}10,000',
                                                style: const TextStyle(
                                                    fontSize: 11)),
                                            value: 3,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              resetToInitialList();
                                              sortProductsByPriceRange(
                                                  5000, 10000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                '${currency}10,000 - ${currency}20,000',
                                                style: const TextStyle(
                                                    fontSize: 11)),
                                            value: 4,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              resetToInitialList();
                                              sortProductsByPriceRange(
                                                  10000, 20000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                '${currency}20,000 - ${currency}40,000',
                                                style: const TextStyle(
                                                    fontSize: 11)),
                                            value: 5,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              resetToInitialList();
                                              sortProductsByPriceRange(
                                                  20000, 40000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                'Above ${currency}40,000',
                                                style: const TextStyle(
                                                    fontSize: 11)),
                                            value: 6,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              resetToInitialList();
                                              sortProductsByPriceRange(
                                                  40000, 100000000000);
                                            },
                                          ),
                                        ],
                                      ),
                                      const Gap(10),
                                      const Divider(
                                        color: Colors.grey,
                                        thickness: 1,
                                      ),
                                      ListTile(
                                        title: const Text(
                                          'Rating',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11),
                                        ).tr(),
                                        trailing: rateValue == null
                                            ? null
                                            : TextButton(
                                                child: const Text(
                                                  'Clear',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    rateValue = null;
                                                    resetToInitialList();
                                                  });
                                                },
                                              ),
                                      ),
                                      ListView(
                                        itemExtent: 35.0,
                                        shrinkWrap: true,
                                        //padding: EdgeInsets.symmetric(vertical:20),
                                        children: [
                                          RadioListTile(
                                            title: Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Text(
                                                  '& Up',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )
                                              ],
                                            ),
                                            value: 1,
                                            groupValue: rateValue,
                                            onChanged: (value) {
                                              setState(() {
                                                rateValue = value;
                                              });
                                              resetToInitialList();
                                              sortAndFilterProductsByRating4();
                                            },
                                          ),
                                          RadioListTile(
                                            title: Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Text(
                                                  '& Up',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )
                                              ],
                                            ),
                                            value: 2,
                                            groupValue: rateValue,
                                            onChanged: (value) {
                                              setState(() {
                                                rateValue = value;
                                              });
                                              resetToInitialList();
                                              sortAndFilterProductsByRating3();
                                            },
                                          ),
                                          RadioListTile(
                                            title: Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Text(
                                                  '& Up',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )
                                              ],
                                            ),
                                            value: 3,
                                            groupValue: rateValue,
                                            onChanged: (value) {
                                              setState(() {
                                                rateValue = value;
                                              });
                                              resetToInitialList();
                                              sortAndFilterProductsByRating2();
                                            },
                                          ),
                                          RadioListTile(
                                            title: Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Text(
                                                  '& Up',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )
                                              ],
                                            ),
                                            value: 4,
                                            groupValue: rateValue,
                                            onChanged: (value) {
                                              setState(() {
                                                rateValue = value;
                                              });
                                              resetToInitialList();
                                              sortAndFilterProductsByRating1();
                                            },
                                          ),
                                          const Gap(10)
                                          // Add more RadioListTile widgets as needed
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        const Gap(10),
                        Expanded(
                          flex: 7,
                          child: isLoaded == true
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        MediaQuery.of(context).size.width >=
                                                1100
                                            ? 4
                                            : 2,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                  ),
                                  itemCount: 20,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: Container(
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 16,
                                                  width: 120,
                                                  color: Colors.grey[300],
                                                ),
                                                const SizedBox(height: 8),
                                                Container(
                                                  height: 16,
                                                  width: 80,
                                                  color: Colors.grey[300],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const Gap(10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${products.length} Products Found',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            DropdownButtonHideUnderline(
                                                child: DropdownButton2(
                                                    isExpanded: true,
                                                    dropdownStyleData:
                                                        const DropdownStyleData(
                                                            width: 150),
                                                    customButton: const Row(
                                                      children: [
                                                        Icon(
                                                          Icons.sort,
                                                        ),
                                                        SizedBox(
                                                          width: 7,
                                                        ),
                                                        Text(
                                                          'Sort By',
                                                          style: TextStyle(
                                                              //fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_drop_down_outlined,
                                                          //  color: Color.fromRGBO(48, 30, 2, 1),
                                                        ),
                                                      ],
                                                    ),
                                                    items: [
                                                      'Price:Low to High'.tr(),
                                                      'Price:High to Low'.tr(),
                                                      'Product Rating'.tr(),
                                                      // 'Favorites'.tr(),
                                                      // 'Signup'.tr(),
                                                    ]
                                                        .map((item) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: item,
                                                              child: Text(
                                                                item,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 11,
                                                                  // fontWeight: FontWeight.bold,
                                                                  // color: Colors
                                                                  //     .black,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value: sortBy,
                                                    onChanged: (value) {
                                                      setState(
                                                        () {
                                                          if (value ==
                                                              'Price:Low to High') {
                                                            sortProductsFromLowToHigh();
                                                          } else if (value ==
                                                              'Price:High to Low') {
                                                            sortProductsFromHighToLow();
                                                          } else {
                                                            sortProductsRatingFromHighToLow();
                                                          }
                                                        },
                                                      );
                                                    })),
                                          ],
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                        ),
                                        products.isEmpty
                                            ? Center(
                                                child: Column(children: [
                                                  Icon(
                                                    Icons.remove_shopping_cart,
                                                    color: appColor,
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        3,
                                                  ),
                                                  const Gap(10),
                                                  const Text(
                                                      'No Product Was Found')
                                                ]),
                                              )
                                            : GridView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: products.length,
                                                itemBuilder: (context, index) {
                                                  ProductsModel productsModel =
                                                      products[index];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ProductWidgetMain(
                                                        productsModel:
                                                            productsModel),
                                                  );
                                                },
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        childAspectRatio: 0.7,
                                                        crossAxisCount:
                                                            MediaQuery.of(context)
                                                                        .size
                                                                        .width >=
                                                                    1100
                                                                ? 4
                                                                : 2,
                                                        mainAxisSpacing: 5,
                                                        crossAxisSpacing: 5),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        const Gap(8)
                      ],
                    ),
                  )
                ///////////////////////////////////////////// Mobile View ////////////////////////////////////////////////////
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        isLoaded == true
                            ? GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      MediaQuery.of(context).size.width >= 1100
                                          ? 4
                                          : 2,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                ),
                                itemCount: 20,
                                itemBuilder: (BuildContext context, int index) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: Container(
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 16,
                                                width: 120,
                                                color: Colors.grey[300],
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                height: 16,
                                                width: 80,
                                                color: Colors.grey[300],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    // const Gap(10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton.icon(
                                            onPressed: () {
                                              modalSheet
                                                  .showBarModalBottomSheet(
                                                      expand: true,
                                                      bounce: true,
                                                      context: context,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      builder: (context) {
                                                        int?
                                                            selectedValueMobile;
                                                        int? rateValueMobile;
                                                        int?
                                                            selectedCollectionMobile;
                                                        return StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                          return Scaffold(
                                                            body: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  children: [
                                                                    ListTile(
                                                                      title:
                                                                          const Text(
                                                                        'Sub Collections',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ).tr(),
                                                                      trailing: selectedCollection ==
                                                                              null
                                                                          ? null
                                                                          : TextButton(
                                                                              child: const Text(
                                                                                'Clear',
                                                                                style: TextStyle(color: Colors.grey),
                                                                              ),
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  selectedCollectionMobile = null;
                                                                                  selectedCollection = null;
                                                                                  selectedValue = null;
                                                                                  selectedValueMobile = null;
                                                                                  rateValue = null;
                                                                                  rateValueMobile = null;
                                                                                  resetToInitialList();
                                                                                  context.pop();
                                                                                });
                                                                              },
                                                                            ),
                                                                    ),
                                                                    isLoaded ==
                                                                            true
                                                                        ? ListView
                                                                            .builder(
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemCount:
                                                                                10,
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              return Shimmer.fromColors(
                                                                                baseColor: Colors.grey[300]!,
                                                                                highlightColor: Colors.grey[100]!,
                                                                                child: ListTile(
                                                                                  title: Container(
                                                                                    height: 16,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          )
                                                                        : ListView.builder(
                                                                            physics: const BouncingScrollPhysics(),
                                                                            shrinkWrap: true,
                                                                            //  itemExtent: 35.0,
                                                                            itemCount: retails.length,
                                                                            itemBuilder: (context, index) {
                                                                              SubCollectionsModel subCategoriesCollectionsModel = retails[index];
                                                                              return RadioListTile(
                                                                                title: Text(
                                                                                  subCategoriesCollectionsModel.subCollection,
                                                                                  style: const TextStyle(),
                                                                                ),
                                                                                value: index,
                                                                                groupValue: selectedCollection ?? selectedCollectionMobile,
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    selectedCollection = value;
                                                                                    selectedCollectionMobile = value;
                                                                                  });

                                                                                  resetToInitialList();
                                                                                  _sortBySubCollections(subCategoriesCollectionsModel.subCollection);
                                                                                  context.pop();
                                                                                  // resetToInitialList();
                                                                                  // sortProductsByPriceRange(1, 2000);
                                                                                },
                                                                              );
                                                                            }),
                                                                    const Gap(
                                                                        10),
                                                                    const Divider(
                                                                      color: Colors
                                                                          .grey,
                                                                      thickness:
                                                                          1,
                                                                    ),
                                                                    ListTile(
                                                                      title:
                                                                          const Text(
                                                                        'Price',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ).tr(),
                                                                      trailing: selectedValue ==
                                                                              null
                                                                          ? null
                                                                          : TextButton(
                                                                              child: const Text(
                                                                                'Clear',
                                                                                style: TextStyle(color: Colors.grey),
                                                                              ),
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  selectedCollectionMobile = null;
                                                                                  selectedCollection = null;
                                                                                  selectedValue = null;
                                                                                  selectedValueMobile = null;
                                                                                  rateValue = null;
                                                                                  rateValueMobile = null;
                                                                                  // selectedValueMobile = null;
                                                                                  // selectedValue = null;
                                                                                  resetToInitialList();
                                                                                  context.pop();
                                                                                });
                                                                              },
                                                                            ),
                                                                    ),
                                                                    ListView(
                                                                      physics:
                                                                          const BouncingScrollPhysics(),
                                                                      shrinkWrap:
                                                                          true,

                                                                      //padding: EdgeInsets.symmetric(vertical:20),
                                                                      children: [
                                                                        RadioListTile(
                                                                          title:
                                                                              Text(
                                                                            'Under ${currency}2,000',
                                                                            style:
                                                                                const TextStyle(),
                                                                          ),
                                                                          value:
                                                                              1,
                                                                          groupValue:
                                                                              selectedValueMobile ?? selectedValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              selectedValueMobile = value;
                                                                              selectedValue = value;
                                                                            });
                                                                            resetToInitialList();
                                                                            sortProductsByPriceRange(1,
                                                                                2000);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title: Text(
                                                                              '${currency}2,000 - ${currency}5,000',
                                                                              style: const TextStyle()),
                                                                          value:
                                                                              2,
                                                                          groupValue:
                                                                              selectedValueMobile ?? selectedValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              selectedValueMobile = value;
                                                                              selectedValue = value;
                                                                            });
                                                                            resetToInitialList();
                                                                            sortProductsByPriceRange(2000,
                                                                                5000);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title: Text(
                                                                              '${currency}5,000 - ${currency}10,000',
                                                                              style: const TextStyle()),
                                                                          value:
                                                                              3,
                                                                          groupValue:
                                                                              selectedValueMobile ?? selectedValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              selectedValueMobile = value;
                                                                              selectedValue = value;
                                                                            });
                                                                            resetToInitialList();
                                                                            sortProductsByPriceRange(5000,
                                                                                10000);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title: Text(
                                                                              '${currency}10,000 - ${currency}20,000',
                                                                              style: const TextStyle()),
                                                                          value:
                                                                              4,
                                                                          groupValue:
                                                                              selectedValueMobile ?? selectedValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              selectedValueMobile = value;
                                                                              selectedValue = value;
                                                                            });
                                                                            resetToInitialList();
                                                                            sortProductsByPriceRange(10000,
                                                                                20000);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title: Text(
                                                                              '${currency}20,000 - ${currency}40,000',
                                                                              style: const TextStyle()),
                                                                          value:
                                                                              5,
                                                                          groupValue:
                                                                              selectedValueMobile ?? selectedValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              selectedValueMobile = value;
                                                                              selectedValue = value;
                                                                            });
                                                                            resetToInitialList();
                                                                            sortProductsByPriceRange(20000,
                                                                                40000);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title: Text(
                                                                              'Above ${currency}40,000',
                                                                              style: const TextStyle()),
                                                                          value:
                                                                              6,
                                                                          groupValue:
                                                                              selectedValueMobile ?? selectedValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              selectedValueMobile = value;
                                                                              selectedValue = value;
                                                                            });
                                                                            resetToInitialList();
                                                                            sortProductsByPriceRange(40000,
                                                                                100000000000);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const Gap(
                                                                        10),
                                                                    const Divider(
                                                                      color: Colors
                                                                          .grey,
                                                                      thickness:
                                                                          1,
                                                                    ),
                                                                    ListTile(
                                                                      title:
                                                                          const Text(
                                                                        'Rating',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ).tr(),
                                                                      trailing: rateValue ==
                                                                              null
                                                                          ? null
                                                                          : TextButton(
                                                                              child: const Text(
                                                                                'Clear',
                                                                                style: TextStyle(color: Colors.grey),
                                                                              ),
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  selectedCollectionMobile = null;
                                                                                  selectedCollection = null;
                                                                                  selectedValue = null;
                                                                                  selectedValueMobile = null;
                                                                                  rateValue = null;
                                                                                  rateValueMobile = null;
                                                                                  resetToInitialList();
                                                                                  context.pop();
                                                                                });
                                                                              },
                                                                            ),
                                                                    ),
                                                                    ListView(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          const BouncingScrollPhysics(),
                                                                      //padding: EdgeInsets.symmetric(vertical:20),
                                                                      children: [
                                                                        RadioListTile(
                                                                          title:
                                                                              const Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Text(
                                                                                '& Up',
                                                                                style: TextStyle(),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          value:
                                                                              1,
                                                                          groupValue:
                                                                              rateValueMobile ?? rateValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              rateValueMobile = value;
                                                                              rateValue = value;
                                                                            });
                                                                            resetToInitialList();
                                                                            sortAndFilterProductsByRating4();
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title:
                                                                              const Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Text(
                                                                                '& Up',
                                                                                style: TextStyle(),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          value:
                                                                              2,
                                                                          groupValue:
                                                                              rateValueMobile ?? rateValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              rateValueMobile = value;
                                                                              rateValue = value;
                                                                            });
                                                                            resetToInitialList();
                                                                            sortAndFilterProductsByRating3();
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title:
                                                                              const Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Text(
                                                                                '& Up',
                                                                                style: TextStyle(),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          value:
                                                                              3,
                                                                          groupValue:
                                                                              rateValueMobile ?? rateValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              rateValueMobile = value;
                                                                              rateValue = value;
                                                                            });
                                                                            resetToInitialList();
                                                                            sortAndFilterProductsByRating2();
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title:
                                                                              const Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Text(
                                                                                '& Up',
                                                                                style: TextStyle(),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          value:
                                                                              4,
                                                                          groupValue:
                                                                              rateValueMobile ?? rateValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              rateValueMobile = value;
                                                                              rateValue = value;
                                                                            });
                                                                            resetToInitialList();
                                                                            sortAndFilterProductsByRating1();
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        const Gap(
                                                                            10)
                                                                        // Add more RadioListTile widgets as needed
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                      });
                                            },
                                            icon: Icon(Icons.filter,
                                                color: AdaptiveTheme.of(context)
                                                            .mode
                                                            .isDark ==
                                                        true
                                                    ? Colors.white
                                                    : Colors.black),
                                            label: Text(
                                              'Filter',
                                              style: TextStyle(
                                                  color:
                                                      AdaptiveTheme.of(context)
                                                                  .mode
                                                                  .isDark ==
                                                              true
                                                          ? Colors.white
                                                          : Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ).tr()),
                                        const Gap(10),
                                        const SizedBox(
                                          height: 20,
                                          child: VerticalDivider(
                                            color: Colors.black,
                                            thickness: 1,
                                            width: 1,
                                            endIndent: 2,
                                            indent: 2,
                                          ),
                                        ),
                                        const Gap(10),
                                        DropdownButtonHideUnderline(
                                            child: DropdownButton2(
                                                isExpanded: true,
                                                dropdownStyleData:
                                                    const DropdownStyleData(
                                                        width: 150),
                                                customButton: const Row(
                                                  children: [
                                                    Icon(
                                                      Icons.sort,
                                                    ),
                                                    SizedBox(
                                                      width: 7,
                                                    ),
                                                    Text(
                                                      'Sort By',
                                                      style: TextStyle(
                                                          //fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_drop_down_outlined,
                                                      //  color: Color.fromRGBO(48, 30, 2, 1),
                                                    ),
                                                  ],
                                                ),
                                                items: [
                                                  'Price:Low to High'.tr(),
                                                  'Price:High to Low'.tr(),
                                                  'Product Rating'.tr(),
                                                  // 'Favorites'.tr(),
                                                  // 'Signup'.tr(),
                                                ]
                                                    .map((item) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                          value: item,
                                                          child: Text(
                                                            item,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 11,
                                                              // fontWeight: FontWeight.bold,
                                                              // color:
                                                              //     Colors.black,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ))
                                                    .toList(),
                                                value: sortBy,
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      if (value ==
                                                          'Price:Low to High') {
                                                        sortProductsFromLowToHigh();
                                                      } else if (value ==
                                                          'Price:High to Low') {
                                                        sortProductsFromHighToLow();
                                                      } else {
                                                        sortProductsRatingFromHighToLow();
                                                      }
                                                    },
                                                  );
                                                })),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                    products.isEmpty
                                        ? Center(
                                            child: Column(children: [
                                              Icon(
                                                Icons.remove_shopping_cart,
                                                color: appColor,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3,
                                              ),
                                              const Gap(10),
                                              const Text('No Product Was Found')
                                            ]),
                                          )
                                        : GridView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: products.length,
                                            itemBuilder: (context, index) {
                                              ProductsModel productsModel =
                                                  products[index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: InkWell(
                                                    onTap: () {
                                                      context.push(
                                                          '/product-detail/${productsModel.uid}');
                                                    },
                                                    child: ProductWidgetMain(
                                                        productsModel:
                                                            productsModel)),
                                              );
                                            },
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    childAspectRatio: 0.6,
                                                    crossAxisCount:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width >=
                                                                1100
                                                            ? 4
                                                            : 2,
                                                    mainAxisSpacing: 10,
                                                    crossAxisSpacing: 10),
                                          ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
            const Gap(20),
          
          ]),
        ));
  }
}