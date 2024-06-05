import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/globals.dart';
import 'package:abico_delivery_start/model/sales/sales_order_entity.dart';
import 'package:abico_delivery_start/service/sales/sales_order_api.dart';
import 'package:abico_delivery_start/ui/components/custom_indicator.dart';
import 'package:abico_delivery_start/ui/screen/sales/sales_partner_screen.dart';
import 'package:abico_delivery_start/ui/screen/sales/sales_order_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SalesOrderScreen extends StatefulWidget {
  const SalesOrderScreen({super.key});

  @override
  State<SalesOrderScreen> createState() => _SalesOrderScreenState();
}

class _SalesOrderScreenState extends State<SalesOrderScreen> {
  SalesOrderApiClient salesData = SalesOrderApiClient();
  List<SalesOrderEntity> itemList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchSalesData();
  }

  void fetchSalesData() async {
    try {
      await salesData.fetchsales().then((data) {
        if (mounted) {
          setState(() {
            itemList = data;
            isLoading = false;
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _sizedBox(context),
            _appBar(context),
            const SizedBox(
              height: 10,
            ),
            _buildSearchLine(),
            isLoading
                ? const Center(
                    child: CustomProgressIndicator(),
                  )
                : _buildList(),
          ],
        ),
      ),
    );
  }

  Row _appBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const PartnerScreen()));
              },
              child: const Text('Үүсгэх')),
        ),
      ],
    );
  }

  SizedBox _sizedBox(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.055,
    );
  }

  Container _buildSearchLine() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.secondBlack, width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextField(
          decoration: const InputDecoration.collapsed(hintText: 'Хайх'),
          onChanged: (query) {},
        ),
      ),
    );
  }

  Expanded _buildList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 15),
        itemCount: itemList.length,
        itemBuilder: (BuildContext context, int index) {
          var item = itemList[index];
          String formattedDate = item.dateOrder != null
              ? DateFormat('yyyy-MM-dd').format(item.dateOrder!)
              : '';

          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SalesOrderItemScreen(
                            item: item,
                          )),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [BoxShadows.shadow3],
                    gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color.fromARGB(255, 104, 26, 81),
                        Color.fromARGB(255, 232, 138, 157),
                      ],
                    )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: .0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildItem('Захиалгын дугаар', item.name),
                      _buildItem('Захиалгын огноо', formattedDate),
                      _buildItem('Захиалагч', item.partnerId.toString()),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 2),
                        child: Container(
                          color: Colors.white,
                          height: 2,
                        ),
                      ),
                      _buildItem(
                        'Татваргүй дүн',
                        item.amountUntaxed.toString(),
                      ),
                      _buildItem(
                        'Татвар',
                        item.amountTax.toString(),
                      ),
                      _buildItem(
                        'Нийт',
                        item.amountTotal.toString(),
                      ),
                      _buildState(
                        'Төлөв',
                        item.state.toString(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Padding _buildState(String text, String text2) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(text), Text(text2)],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[0-9]'),
              ),
            ],
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: '0',
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: controller,
          ),
        ),
      ],
    );
  }
}

Padding _buildItem(
  String type,
  String name,
) {
  return Padding(
    padding: const EdgeInsets.only(top: 3),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '$type :',
              style: TextStyles.white14semibold,
            ),
          ),
          Expanded(
            child: Text(
              name,
              style: TextStyles.white14,
            ),
          ),
        ],
      ),
    ),
  );
}
