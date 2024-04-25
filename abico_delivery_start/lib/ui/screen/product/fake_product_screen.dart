import 'dart:convert';

import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/model/product_entity.dart';
import 'package:abico_delivery_start/service/product/product_list_repo.dart';
import 'package:abico_delivery_start/ui/components/custom_indicator.dart';
import 'package:flutter/material.dart';

class FakeProductScreen extends StatefulWidget {
  final String? barcode;

  const FakeProductScreen({super.key, this.barcode});

  @override
  State<FakeProductScreen> createState() => _FakeProductScreenState();
}

class _FakeProductScreenState extends State<FakeProductScreen> {
  ProductListApiClient getProductList = ProductListApiClient();
  bool isLoading = true;
  List<ProductEntity> productList = [];
  List<ProductEntity> filteredList = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchData();
    if (widget.barcode != null) {
      searchQuery = widget.barcode!;
      filterListByBarcode();
    } else {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    final data = await getProductList.fetchData();
    setState(() {
      productList = data;
      isLoading = false;
      filterListByBarcode();
    });
  }

  void filterListByBarcode() {
    filteredList = productList.where((item) {
      return (item.barcode?.toLowerCase() ?? '')
          .contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CustomProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 15),
                      itemCount: searchQuery.isEmpty
                          ? productList.length
                          : filteredList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = searchQuery.isEmpty
                            ? productList[index]
                            : filteredList[index];
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Container(
                              height: 650,
                              decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: 300,
                                      width: 350,
                                      decoration: item.image128 == null
                                          ? BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white)
                                          : BoxDecoration(
                                              color: const Color.fromARGB(
                                                  227, 6, 32, 179),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: MemoryImage(
                                                  base64Decode(
                                                      item.image128.toString()),
                                                ),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          _buildRow(
                                            _buildRightText('Барааны нэр:'),
                                            _buildRightText(
                                                item.name.toString() == 'null'
                                                    ? 'Хоосон'
                                                    : item.name.toString()),
                                          ),
                                          _buildRow(
                                            _buildRightText('Бар код:'),
                                            _buildRightText(
                                                item.barcode.toString() ==
                                                        'null'
                                                    ? 'Хоосон'
                                                    : item.barcode.toString()),
                                          ),
                                          _buildRow(
                                            _buildRightText('Дотоод сурвалж:'),
                                            _buildRightText(item.defaultCode
                                                        .toString() ==
                                                    'null'
                                                ? 'Хоосон'
                                                : item.defaultCode.toString()),
                                          ),
                                          // _buildRow(
                                          //   _buildRightText('Хэмжих нэгж:'),
                                          //   _buildRightText(
                                          //     item.uomId!.name.toString() ==
                                          //             'null'
                                          //         ? 'Хоосон'
                                          //         : item.uomId!.name.toString(),
                                          //   ),
                                          // ),
                                          // _buildRow(
                                          //     _buildRightText('Ангилал:'),
                                          //     _buildRightText(
                                          //       item.categId!.name.toString() ==
                                          //               'null'
                                          //           ? 'Хоосон'
                                          //           : item.categId!.name
                                          //               .toString(),
                                          //     )),
                                          _buildRow(
                                            _buildRightText('Жин:'),
                                            _buildRightText(
                                              item.weight.toString(),
                                            ),
                                          ),
                                          _buildRow(
                                            _buildRightText('Тоо:'),
                                            _buildRightText(
                                              item.volume.toString(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ));
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

Text _buildRightText(String text) => Text(
      text,
      style: TextStyles.white16,
    );

Widget _buildRow(Widget defualtText, Widget dynamicText) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: defualtText),
      Expanded(flex: 2, child: dynamicText),
    ],
  );
}
