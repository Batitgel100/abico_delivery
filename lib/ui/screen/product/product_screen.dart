import 'dart:convert';
import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/model/product_entity.dart';
import 'package:abico_delivery_start/service/product/product_list_repo.dart';
import 'package:abico_delivery_start/ui/components/custom_indicator.dart';
import 'package:abico_delivery_start/ui/screen/product/product_item_screen.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final String? barcode;

  const ProductScreen({super.key, this.barcode});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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

  void _onItemTap(ProductEntity item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductItemScreen(
          name: item.name.toString(),
          // uom: item.uomId!.name.toString(),
          barcode: item.barcode.toString(),
          image: Container(
            height: item.image128 == null
                ? MediaQuery.of(context).size.height * 0.0
                : MediaQuery.of(context).size.height * 0.4,
            decoration: item.image128 == null
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white)
                : BoxDecoration(
                    color: const Color.fromARGB(227, 6, 32, 179),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: MemoryImage(
                        base64Decode(item.image128.toString()),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
          ),
          defaultCode: item.defaultCode.toString(),
          // type: item.categId!.name.toString(),
          volume: item.qtyAvailable.toString(),
          weight: item.weight.toString(), listPrice: item.listPrice.toString(),
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    final data = await getProductList.fetchData();
    if (mounted) {
      setState(() {
        productList = data;
        isLoading = false;
        filterListByBarcode();
      });
    }
  }

  void filterListByBarcode() {
    filteredList = productList.where((item) {
      return (item.name?.toLowerCase().contains(searchQuery.toLowerCase()) ??
              false) ||
          (item.defaultCode
                  ?.toLowerCase()
                  .contains(searchQuery.toLowerCase()) ??
              false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
      body: isLoading
          ? const CustomProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: AppColors.secondBlack, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                        decoration:
                            const InputDecoration.collapsed(hintText: 'Хайх'),
                        onChanged: (query) {
                          setState(() {
                            searchQuery = query;
                            filterListByBarcode();
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
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
                            child: InkWell(
                              onTap: () {
                                _onItemTap(item);
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.13,
                                        width: 100,
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
                                                    base64Decode(item.image128
                                                        .toString()),
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
                                              _buildText('Барааны нэр'),
                                              _buildTextEnd(
                                                  item.name.toString()),
                                            ),
                                            _buildRow(
                                              _buildText('Бар код'),
                                              _buildTextEnd(item.barcode == null
                                                  ? 'Хоосон'
                                                  : item.barcode.toString()),
                                            ),
                                            _buildRow(
                                              _buildText('Дотоод Сурвалж'),
                                              _buildTextEnd(
                                                  item.defaultCode.toString()),
                                            ),
                                            _buildRow(
                                              _buildText('Хэмжих нэгж'),
                                              _buildTextEnd(
                                                  // item.uomId!.name.toString(),
                                                  ''),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
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

Widget _buildText(String text) {
  return Text(
    '$text:',
    style: const TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
  );
}

Widget _buildRow(Widget defualtText, Widget dynamicText) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      defualtText,
      Expanded(child: dynamicText),
    ],
  );
}

Expanded _buildItem(
  String type,
  String name,
) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                type,
                style: TextStyles.white16,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 2,
              child: Text(
                name,
                style: TextStyles.white16,
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildTextEnd(String text) {
  return Text(
    text,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
    textAlign: TextAlign.end,
  );
}
