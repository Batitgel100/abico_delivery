import 'dart:convert';

import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/globals.dart';
import 'package:abico_delivery_start/model/product_entity.dart';
import 'package:abico_delivery_start/service/product/product_list_repo.dart';
import 'package:abico_delivery_start/service/sales/sales_order_api.dart';
import 'package:abico_delivery_start/ui/components/custom_indicator.dart';
import 'package:abico_delivery_start/ui/screen/sales/sales_product_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SalesProductScreen extends StatefulWidget {
  const SalesProductScreen({super.key});

  @override
  State<SalesProductScreen> createState() => _SalesProductScreenState();
}

class _SalesProductScreenState extends State<SalesProductScreen> {
  ProductListApiClient getProductList = ProductListApiClient();
  SalesOrderApiClient post = SalesOrderApiClient();
  bool isLoading = true;
  List<ProductEntity> productList = [];
  List<ProductEntity> filteredList = [];
  String searchQuery = '';
  int productCount = 0;
  List<CartItem> cartList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final data = await getProductList.fetchData();
    if (mounted) {
      setState(() {
        productList = data;
        isLoading = false;
      });
    }
  }

  postSalesOrder() async {
    post.fetchsales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: isLoading
          ? const Center(child: CustomProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(5),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: productList.length,
              itemBuilder: (_, index) {
                final item = productList[index];
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        int enteredQuantity = 1;

                        return AlertDialog(
                          title: Text('Тоо ширхэг оруулна уу. ${item.name}'),
                          content: Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    enteredQuantity = int.tryParse(value) ?? 1;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Тоо/ширхэг",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            width: 1,
                                            color: AppColors.mainColor)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Буцах'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Нэмэх'),
                              onPressed: () {
                                setState(() {
                                  productCount += 1;
                                  cartList.add(CartItem(
                                    id: item.id,
                                    name: item.name ?? '',
                                    price: item.listPrice ?? 0,
                                    quantity: enteredQuantity,
                                  ));
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 5, right: 5),
                    child: Container(
                      decoration:
                          const BoxDecoration(boxShadow: [BoxShadows.shadow2]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GridTile(
                          footer: Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(194, 0, 0, 0)),
                            child: SizedBox(
                              // height: 80,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Text(
                                                item.name.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            'Тоо: ${item.qtyAvailable}',
                                            style: const TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                            'Үнэ: ${item.listPrice}',
                                            style: const TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          child: Container(
                            decoration: item.image128 == null
                                ? const BoxDecoration(
                                    // assets/images/products.png
                                    color: Colors.white,
                                  )
                                : BoxDecoration(
                                    color:
                                        const Color.fromARGB(227, 6, 32, 179),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: MemoryImage(
                                        base64Decode(item.image128.toString()),
                                      ),
                                    ),
                                  ),
                            child: item.image128 == null
                                ? const Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 70,
                                        right: 20,
                                        left: 20,
                                        top: 20),
                                    child: Image(
                                      width: 50,
                                      height: 50,
                                      image: AssetImage(
                                        'assets/images/icons/products.png',
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Add your _buildAppBar method and any other methods here

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: false,
      title: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    hintText: 'Хайх',
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: Colors.black),
              ),
            ),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                    size: 36.4,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SalesProductDetailScreen(
                          list: cartList,
                        ),
                      ),
                    );
                  },
                ),
                productCount == 0
                    ? const SizedBox()
                    : Positioned(
                        right: 5,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: Colors.yellow),
                          child: Center(
                            child: Text(
                              productCount == 0 ? '0' : '$productCount',
                              style: TextStyles.black14,
                            ),
                          ),
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CartItem {
  int id;
  String name;
  double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });
}
