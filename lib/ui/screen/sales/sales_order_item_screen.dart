import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/model/sales/sales_order_entity.dart';
import 'package:abico_delivery_start/model/sales/sales_order_line_entity.dart';
import 'package:abico_delivery_start/service/sales/sales_line_repo.dart';
import 'package:abico_delivery_start/ui/components/custom_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesOrderItemScreen extends StatefulWidget {
  final SalesOrderEntity item;
  const SalesOrderItemScreen({
    super.key,
    required this.item,
  });

  @override
  State<SalesOrderItemScreen> createState() => _SalesOrderItemScreenState();
}

class _SalesOrderItemScreenState extends State<SalesOrderItemScreen> {
  String locationName = 'Хоосон';
  String pickingTypeName = '';
  String searchQuery = '';
  bool startPage = true;
  bool isLoading = true;
  int locatiomId = 0;
  int barcode = 0;
  List<SaleOrderLineEntity> lineList = [];
  SalesOrderLineApiClient lineClient = SalesOrderLineApiClient();

  @override
  void initState() {
    super.initState();
    fetchLineData();
  }

  Future<void> fetchLineData() async {
    try {
      List<SaleOrderLineEntity> data =
          await lineClient.fetchsales(widget.item.id);
      setState(() {
        lineList = data;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body:
          // (item == null || productList.isEmpty)
          //     ? const Center(
          //         child: CustomProgressIndicator(),
          //       )
          //     :
          Padding(
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
                  // item!.state == null
                  //     ? const SizedBox()
                  //     : item!.state.toString() == 'confirm'
                  //         ? _buildButtonRow(context)
                  //         : const SizedBox(),
                  _build10SizedBox(),
                  _buildTextField(),
                  _build10SizedBox(),
                  if (isLoading)
                    _listIndicator()
                  else
                    lineList.isEmpty
                        ? const Expanded(
                            child: Center(
                              child: Text('Хоосон'),
                            ),
                          )
                        : _buildList(),
                ],
              )
            : const Center(
                child: CustomProgressIndicator(),
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
              // searchQuery = query;
              // filteredList = productList.where((item) {
              //   // Your search logic here
              //   return item.productId!.name
              //       .toLowerCase()
              //       .contains(query.toLowerCase());
              // }).toList();
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
      flex: 3,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: lineList.length,
        //  searchQuery.isEmpty
        //     ? productList.length
        //     : filteredList.length,
        itemBuilder: (BuildContext context, int index) {
          final item = lineList[index];
          // final item = searchQuery.isEmpty
          //     ? productList[index]
          //     : filteredList[index];
          // print(
          //     '++${searchQuery.isEmpty ? productList.length : filteredList.length}');
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.09,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.white,
                  boxShadow: const [BoxShadows.shadows]),
              child: _build(
                item.name,
                item.priceUnit.toString(),
                item.productUomQty.toString(),
                item.priceSubtotal.toString(),
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
          () {},
          'Бараа нэмэх',
        ),
      ],
    );
  }

  Expanded _buildInformation(String locationName) {
    String formattedDate = widget.item.dateOrder != null
        ? DateFormat('yyyy-MM-dd').format(widget.item.dateOrder!)
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
            // if (item != null)
            _buildItem(
                'Захиалгын дугаар',
                // widget.itemss!.name ??
                widget.item.name),
            // if (item != null)
            _buildItem('Захиалсан огноо', formattedDate),
            // if (item != null)
            _buildItem('Захиалагч', widget.item.partnerId.toString()
                //  formattedDate.toString()
                ),
            // if (item != null)
            _buildItem(
                'Үнийн хүснэгт',
                //  widget.itemss!.origin ??
                widget.item.pricelistId.toString()),
            // if (item != null)
            _buildItem('Борлуулагч', widget.item.userId.toString()
                //  locationName.toString()
                ),
            _buildState()
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

  Expanded _buildState() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.yellow,
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
                style: TextStyles.black16semibold,
              ),
              if (widget.item.state == 'done')
                const Text(
                  'Батлагдсан',
                  style: TextStyles.black16semibold,
                )
              else if (widget.item.state == 'draft')
                const Text(
                  'Ноорог',
                  style: TextStyles.black16semibold,
                )
              else if (widget.item.state == 'confirm')
                const Text(
                  'Явагдаж буй',
                  style: TextStyles.black16semibold,
                )
              else if (widget.item.state == 'cancel')
                const Text(
                  'Цуцлагдсан',
                  style: TextStyles.black16semibold,
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
              child: Text(
                '$text:',
                style: TextStyles.white14semibold,
              ),
            ),
            Text(
              data,
              style: TextStyles.white14,
            ),
          ],
        ),
      ),
    );
  }

  Column _build(
    String type,
    String text1,
    String text2,
    String text3,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          child: Text(
            type,
            style: TextStyles.black14semibold,
            overflow: TextOverflow.clip,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'үнэ: $text1',
              style: const TextStyle(
                  color: Color.fromARGB(211, 103, 49, 5), fontSize: 14),
            ),
            Text(
              'тоо: $text1',
              style: const TextStyle(
                  color: Color.fromARGB(211, 103, 49, 5), fontSize: 14),
            ),
            Text(
              'нийт $text1',
              style: const TextStyle(
                  color: Color.fromARGB(211, 103, 49, 5), fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}
