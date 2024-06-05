import 'dart:async';
import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/model/stock_picking/stock_picking_model.dart';
import 'package:abico_delivery_start/model/stock_picking/stock_picking_line_entity.dart';
import 'package:abico_delivery_start/model/stock_picking/stock_picking_type_repo.dart';
import 'package:abico_delivery_start/service/stock_picking/stock_picking_api.dart';
import 'package:abico_delivery_start/service/stock_picking/stock_picking_line_repo.dart';
import 'package:abico_delivery_start/service/stock_picking/stock_picking_put_repo.dart';
import 'package:abico_delivery_start/ui/components/custom_indicator.dart';
import 'package:abico_delivery_start/ui/screen/stock_picking/stock_dialog.dart';
import 'package:abico_delivery_start/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';

class CountItemScreen extends StatefulWidget {
  final StockPickingEntity? itemss;

  const CountItemScreen({
    super.key,
    required this.itemss,
  });

  @override
  State<CountItemScreen> createState() => _CountItemScreenState();
}

class _CountItemScreenState extends State<CountItemScreen> {
  StockPickingApiClient stockPickingApiClient = StockPickingApiClient();
  StockPickingLineApiClient fetch = StockPickingLineApiClient();
  TextEditingController qtyController = TextEditingController();
  StockMovePutApiClient put = StockMovePutApiClient();
  List<StockPickingLineEntity> productList = [];
  List<StockPickingLineEntity> filteredList = [];
  late Timer inactivityTimer;
  StockPickingEntity? item;
  String locationName = 'Хоосон';
  String pickingTypeName = '';
  String searchQuery = '';
  bool startPage = false;
  bool isLoading = true;
  int locatiomId = 0;
  int barcode = 0;

  @override
  void initState() {
    super.initState();
    fetchTypeData();
    fetchData();
    fetchDatas();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: (item == null || productList.isEmpty)
          ? const Center(
              child: CustomProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: startPage
                  ? Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.055,
                        ),
                        _buildAppBar(context),
                        _buildInformation(locationName),
                        _build10SizedBox(),
                        _buildButtonRow(context),
                        item!.state == null
                            ? const SizedBox()
                            : item!.state.toString() == 'confirm'
                                ? _buildButtonRow(context)
                                : const SizedBox(),
                        _build10SizedBox(),
                        _buildTextField(),
                        _build10SizedBox(),
                        if (isLoading) _listIndicator() else _buildList(),
                      ],
                    )
                  : const Center(child: CustomProgressIndicator()),
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
                return item.productId!.name
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
      child: RefreshIndicator(
        onRefresh: _refreshList,
        child: productList.isEmpty
            ? const Text('Хоосон')
            : ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: searchQuery.isEmpty
                    ? productList.length
                    : filteredList.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = searchQuery.isEmpty
                      ? productList[index]
                      : filteredList[index];
                  // print(
                  //     '++${searchQuery.isEmpty ? productList.length : filteredList.length}');
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

                          _build(
                              'Бараа',
                              item.productId != null
                                  ? item.productId!.name
                                  : 'Хоосон'),
                          _build('Бэлдэх\nтоо', item.productUomQty.toString()),
                          _build2(
                              'Бэлдсэн\nтоо',
                              item.checkQty.toString(),
                              TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => StockPickingDialog(
                                              handleButtonCallback: () async {
                                                await fetchData();
                                                setState(() {});
                                              },
                                              note: item,
                                            ));
                                  },
                                  child: const Text('Тоо засах'))),
                          // _build('байршил', item.locationId ?? 'Хоосон'),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Row _buildButtonRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildButton(
          () {},
          'Шалгасан',
        ),
        _buildButton(
          () {
            scanBarcodeWithOne(context);
            // _scan();
          },
          'Нэгээр',
        ),
        _buildButton(
          () {
            _scan();
          },
          'Олоноор',
        ),
      ],
    );
  }

  Expanded _buildInformation(String locationName) {
    String formattedDate = widget.itemss!.scheduledDate != null
        ? DateFormat('yyyy-MM-dd').format(widget.itemss!.scheduledDate!)
        : '';

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [BoxShadows.shadow3],
          borderRadius: BorderRadius.circular(12),
          color: AppColors.mainColor,
        ),
        child: Column(
          children: [
            if (item != null)
              _buildItem('Хүргэлтийн хаяг', widget.itemss!.name ?? 'Хоосон'),
            if (item != null)
              _buildItem('Агуулахын баримтын\nтөрөл', pickingTypeName),
            if (item != null)
              _buildItem('Товлосон огноо', formattedDate.toString()),
            if (item != null)
              _buildItem('Эх баримт', widget.itemss!.origin ?? 'Хоосон'),
            if (item != null) _buildItem('Эх байрлал', locationName.toString()),
          ],
        ),
      ),
    );
  }

  Row _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 30,
            ),
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
        height: MediaQuery.of(context).size.height * 0.045,
        width: MediaQuery.of(context).size.width * 0.27,
        decoration: BoxDecoration(
            boxShadow: const [BoxShadows.shadow3],
            borderRadius: BorderRadius.circular(8),
            color: const Color.fromARGB(221, 46, 56, 255)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
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
              // width: MediaQuery.of(context).size.width * 0.27,
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

  Padding _build(
    String type,
    String name,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                '$type:',
                style: TextStyles.black16semibold,
              ),
            ),
            Expanded(
              child: Text(
                name,
                style: TextStyles.black16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _build2(
    String type,
    String name,
    Widget button,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Text(
                '$type:',
                style: TextStyles.black16semibold,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                name,
                style: TextStyles.black16,
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(child: button),
            ),
          ],
        ),
      ),
    );
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
        StockPickingLineEntity? matchingProduct;

        for (var product in productList) {
          if (product.barcode == barcodeScanRes) {
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
                  builder: (_) => StockPickingDialog(
                        note: matchingProduct as StockPickingLineEntity,
                        handleButtonCallback: () async {
                          isLoading = true;

                          await fetchData();
                        },
                      ));
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
                builder: (_) => CountItemScreen(
                      itemss: widget.itemss,
                    )));
      } else {
        print('Failed to scan barcode: ${e.message}');
      }
    }
  }

  Future<void> scanBarcodeWithOne(BuildContext context) async {
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
        StockPickingLineEntity? matchingProduct;

        for (var product in productList) {
          if (product.barcode == barcodeScanRes) {
            matchingProduct = product;
            break;
          }
        }
        print(' match id${matchingProduct?.id}');

        // Increment the value retrieved from barcode scanner by one
        if (matchingProduct != null && matchingProduct.checkQty != null) {
          double newValue = matchingProduct.checkQty! + 1;
          await addOrUpdateNote(matchingProduct, newValue, context);
        }
      }
    } on PlatformException catch (e) {
      if (e.code == 'USER_CANCELLED') {
        print('Barcode scanning cancelled by user');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CountItemScreen(
                      itemss: widget.itemss,
                    )));
      } else {
        print('Failed to scan barcode: ${e.message}');
      }
    }
  }

  Future<void> addOrUpdateNote(StockPickingLineEntity matchingProduct,
      double newValue, BuildContext context) async {
    try {
      print('Matching Product Found: ${matchingProduct.productId?.id}');

      // Perform asynchronous work outside of setState
      await put.getStockMovePutList(
        '49.0.129.18:9393',
        matchingProduct.id.toString(),
        '$newValue',
      );

      // Update widget state synchronously within setState
      setState(() {
        // Update state variables here if needed
      });

      print('Success'); // This will be executed if the try block succeeds
    } catch (e) {
      await fetchData();
      // Handle specific error from put.getStockMovePutList()
      Utils.flushBarSuccessMessage('Амжилттай 1 - р нэмэгдлээ', context);
      // You can add additional error handling logic here
    }
  }

  void _scan() async {
    await scanBarcode(context);
  }

  void startTimer() {
    const inactivityDuration =
        Duration(milliseconds: 200); // 600 seconds = 10 minutes

    inactivityTimer = Timer(inactivityDuration, () {
      setState(() {
        startPage = true;
      });
    });
  }

  void fetchTypeData() async {
    StockPickingTypeApi api =
        StockPickingTypeApi(); // Create an instance of the API class
    Map<String, dynamic>? data = await api.fetchData(
        widget.itemss!.pickingTypeId as int); // Fetch data from the API

    if (data != null) {
      setState(() {
        pickingTypeName = data['results'][0]['name'];
      });
    }
  }

  void findLocation() {}
  Future<void> fetchDatas() async {
    if (mounted) {
      try {
        final data = await stockPickingApiClient.fetchStockPicking();
        final itemWithId = data.firstWhere(
          (item) => item.id == widget.itemss!.id,
        );

        setState(() {
          item = itemWithId;
        });
      } catch (error) {
        print('Error location data: $error');
      }
    }
  }

  Future<void> _refreshList() async {
    if (item != null) {
      List<StockPickingLineEntity> updatedData =
          await StockPickingLineApiClient.fetchData(widget.itemss!.id);
      setState(() {
        productList = updatedData;
        filteredList = productList.where((item) {
          return item.productId!.name
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
        }).toList();
      });
    }
  }

  Future<void> fetchData() async {
    try {
      List<StockPickingLineEntity> data =
          await StockPickingLineApiClient.fetchData(widget.itemss!.id);
      if (mounted) {
        setState(() {
          productList = data;
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }
}
