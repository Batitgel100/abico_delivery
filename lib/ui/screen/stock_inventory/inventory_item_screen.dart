import 'dart:async';
import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/globals.dart';
import 'package:abico_delivery_start/model/inventory/inventory_entity.dart';
import 'package:abico_delivery_start/model/inventory/inventory_line_entity.dart';
import 'package:abico_delivery_start/service/inventory/inventory_line_put.dart';
import 'package:abico_delivery_start/service/inventory/inventory_line_repo.dart';
import 'package:abico_delivery_start/service/inventory/inventory_repo.dart';
import 'package:abico_delivery_start/ui/components/custom_indicator.dart';
import 'package:abico_delivery_start/ui/screen/stock_inventory/inventory_barcode_dialog.dart';
import 'package:abico_delivery_start/ui/screen/stock_inventory/inventory_create_dialog.dart';
import 'package:abico_delivery_start/ui/screen/stock_inventory/inventory_qty_screen.dart';
import 'package:abico_delivery_start/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';

class InventoryItemScreen extends StatefulWidget {
  final InventoryEntity itemss;
  final String? locationName;

  const InventoryItemScreen(
      {super.key, required this.itemss, this.locationName});

  @override
  State<InventoryItemScreen> createState() => _InventoryItemScreenState();
}

class _InventoryItemScreenState extends State<InventoryItemScreen> {
  List<InventoryLineEntity> productList = [];
  List<InventoryLineEntity> filteredList = [];
  InventoryLineApiClient fetchLineData = InventoryLineApiClient();
  TextEditingController qtyController = TextEditingController();
  InventoryApiClient inventoryApiClient = InventoryApiClient();
  StockInventoryLinePutApiClient put = StockInventoryLinePutApiClient();
  String searchQuery = '';
  InventoryEntity? item;
  bool isLoading = false;
  int barcode = 0;

  @override
  void initState() {
    super.initState();
    fetchDatas();
    fetchData();
  }

  Future<void> scanBarcode(BuildContext context) async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      print('barcode data: $barcodeScanRes');

      if (barcodeScanRes != '-1') {
        InventoryLineEntity? matchingProduct;

        for (var product in productList) {
          if (product.productId?.barcode == barcodeScanRes) {
            matchingProduct = product;
            break;
          }
        }

        if (mounted) {
          setState(() {
            if (matchingProduct != null) {
              print('Matching Product Found: ${matchingProduct.productId?.id}');
              showDialog(
                  context: context,
                  builder: (_) => StockInventoryBarCodeDialog(
                        note: matchingProduct as InventoryLineEntity,
                        handleButtonCallback: () async {
                          await fetchData();
                          setState(() {});
                        },
                      ));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => InventoryQtyUpdateScreen(
              //               item: matchingProduct,
              //               id: widget.itemss.id,
              //             )));
            } else {
              print('No Matching Product Found');
              Utils.flushBarErrorMessage('Бараа олдсонгүй', context);
            }
          });
        }
      }
    } on PlatformException catch (e) {
      if (e.code == 'USER_CANCELLED') {
        print('Barcode scanning cancelled by user');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => InventoryItemScreen(
                      itemss: widget.itemss,
                    )));
      } else {
        print('Failed to scan barcode: ${e.message}');
      }
    }
  }

  void _scan() async {
    await scanBarcode(context);
  }

  void findLocation() {}
  Future<void> fetchDatas() async {
    try {
      final data = await inventoryApiClient.fetchStockPicking();
      final itemWithId = data.firstWhere(
        (item) => item.id == widget.itemss.id,
      );
      setState(() {
        item = itemWithId;
      });
    } catch (error) {
      print('Error fetching location data: $error');
    }
  }

  Future<void> fetchData() async {
    try {
      List<InventoryLineEntity> data =
          await fetchLineData.fetchData(widget.itemss.id);
      setState(() {
        productList = data;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  int locatiomId = 0;
  @override
  Widget build(BuildContext context) {
    String locationName = 'Хоосон';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: (item == null || productList.isEmpty)
          ? const Center(
              child: CustomProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.055,
                  ),
                  _buildAppBar(context),
                  _buildInformation(locationName),
                  _build10SizedBox(),
                  _buildButtonRow(context),
                  _build10SizedBox(),
                  _buildTextField(),
                  _build10SizedBox(),
                  if (isLoading) _listIndicator() else _buildList(),
                ],
              ),
            ),
    );
  }

  Container _buildTextField() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.secondBlack, width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextField(
          onChanged: (query) {
            setState(() {
              searchQuery = query;
              filteredList = productList.where((item) {
                // Your search logic here
                return item.productId!.displayName!
                    .toLowerCase()
                    .contains(query.toLowerCase());
              }).toList();
            });
          },
          decoration: const InputDecoration.collapsed(hintText: 'Хайх'),
        ),
      ),
    );
  }

  SizedBox _build10SizedBox() {
    return const SizedBox(
      height: 10,
    );
  }

  _listIndicator() {
    return const CustomProgressIndicator();
  }

  Expanded _buildList() {
    return Expanded(
      flex: 2,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount:
            searchQuery.isEmpty ? productList.length : filteredList.length,
        itemBuilder: (BuildContext context, int index) {
          final item =
              searchQuery.isEmpty ? productList[index] : filteredList[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _line(),
                  _build('Бараа', item.productId?.displayName ?? 'Хоосон'),
                  _build('Гарт байгаа', item.theoreticalQty.toString()),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Тоолсон:',
                                  style: TextStyles.black16semibold,
                                ),
                                const SizedBox(
                                  width: 33,
                                ),
                                Text(
                                  item.productQty.toString(),
                                  style: TextStyles.black16semibold,
                                )
                              ]),
                        ),
                        TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => StockInventoryBarCodeDialog(
                                      note: item,
                                      handleButtonCallback: () async {
                                        await fetchData();
                                        setState(() {});
                                      }));
                            },
                            child: const Text('Тоо засах'))
                      ],
                    ),
                  ),

                  // _build('байршил', item.locationId ?? 'Хоосон'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Row _buildButtonRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildButton(
          () {
            _scan();
          },
          'Баркод',
        ),
        _buildButton(
          () {
            showDialog(
                context: context,
                builder: (_) => CreateInventoryLineDialog(
                      locationList: widget.itemss.locationIdss,
                      inventoryId: widget.itemss.id,
                      onclick: () async {
                        await fetchData();
                        await fetchDatas();
                        setState(() {});
                      },
                    ));
          },
          'Бараа нэмэх',
        ),
      ],
    );
  }

  Container _buildInformation(String locationName) {
    String formattedDate = widget.itemss.accountingDate != null
        ? DateFormat('yyyy-MM-dd').format(widget.itemss.accountingDate!)
        : '';

    return Container(
      height: MediaQuery.of(context).size.height * 0.22,
      decoration: BoxDecoration(
        boxShadow: const [BoxShadows.shadow3],
        borderRadius: BorderRadius.circular(12),
        color: AppColors.mainColor,
      ),
      child: Column(
        children: [
          if (item != null) // Add this check
            _buildItem('Тооллогын нэр', widget.itemss.name.toString()),
          if (item != null) // Add this check
            _buildItem('Санхүүгийн огноо', formattedDate.toString()),
          if (item != null) // Add this check
            _buildItem('Компани', Globals.getCompany()),
          if (item != null) // Add this check
            _buildItemWidget(
              'Байрлалууд',
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(0),
                  itemCount: item!.locationIdss!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final items = item?.locationIdss?[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${items!.displayName}, ',
                        style: TextStyles.white16semibold,
                      ),
                    );
                  },
                ),
              ),
            ),
          _buildState()
        ],
      ),
    );
  }

  Row _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30,
          ),
        ),
      ],
    );
  }

  Padding _line() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 1.5,
        color: Colors.black,
      ),
    );
  }

  Expanded _buildState() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Төлөв',
                style: TextStyles.white16,
              ),
              if (item!.state == 'done')
                const Text(
                  'Батлагдсан',
                  style: TextStyles.white16,
                )
              else if (item!.state == 'draft')
                const Text(
                  'Ноорог',
                  style: TextStyles.white16,
                )
              else if (item!.state == 'confirm')
                const Text(
                  'Явагдаж буй',
                  style: TextStyles.white16,
                )
              else if (item!.state == 'cancel')
                const Text(
                  'Цуцлагдсан',
                  style: TextStyles.white16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell _buildButton(VoidCallback ontap, String text) {
    return InkWell(
      onTap: ontap,
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.045,
        // width: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(
            boxShadow: const [BoxShadows.shadow3],
            borderRadius: BorderRadius.circular(8),
            color: const Color.fromARGB(221, 46, 56, 255)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Text(
              text,
              style: TextStyles.white16,
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildItem(String text, String data) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Text(
                '$text:',
                style: TextStyles.white16semibold,
              ),
            ),
            Text(
              data,
              style: TextStyles.white16,
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildItemWidget(String text, Widget data) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Text(
                '$text:',
                style: TextStyles.white16semibold,
              ),
            ),
            data
          ],
        ),
      ),
    );
  }

  Padding _build(
    String type,
    String name,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.26,
              child: Text(
                '$type:',
                style: TextStyles.black16semibold,
              ),
            ),
            Expanded(
              child: Text(
                overflow: TextOverflow.visible,
                name,
                style: TextStyles.black16semibold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
