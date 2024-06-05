import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/globals.dart';
import 'package:abico_delivery_start/model/sales/partner/partner_entity.dart';
import 'package:abico_delivery_start/service/sales/partner_apiclient.dart';
import 'package:abico_delivery_start/ui/components/custom_indicator.dart';
import 'package:abico_delivery_start/ui/screen/sales/sales_order_item_screen.dart';
import 'package:abico_delivery_start/ui/screen/sales/sales_product_detail_screen.dart';
import 'package:abico_delivery_start/ui/screen/sales/sales_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PartnerScreen extends StatefulWidget {
  const PartnerScreen({super.key});

  @override
  State<PartnerScreen> createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerScreen> {
  PartnerApiClient getPartner = PartnerApiClient();
  List<PartnerEntity> partnerList = [];
  List<PartnerEntity> filteredPartnerList = [];
  TextEditingController controller = TextEditingController();
  bool loading = true;
  @override
  void initState() {
    super.initState();
    fetchPartner();
  }

  void fetchPartner() async {
    if (mounted) {
      try {
        await getPartner.fetchPartner().then((data) {
          if (mounted) {
            setState(() {
              partnerList = data;
              loading = false;
            });
          }
        });
      } catch (e) {
        print(e);
      }
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
            _buildList(),
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
      child: loading
          ? const Center(child: CustomProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.only(top: 15),
              itemCount: partnerList.length,
              itemBuilder: (BuildContext context, int index) {
                var item = partnerList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: InkWell(
                    onTap: () {
                      Globals.changeZahialagch(item.name.toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SalesProductScreen()),
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
                              Color.fromARGB(255, 196, 92, 113),
                            ],
                          )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildItem(
                              'Харилцагчын нэр',
                              item.name == 'null'
                                  ? 'Хоосон'
                                  : item.name.toString(),
                            ),
                            _buildItem(
                              'Харилцагчын код',
                              item.companyId == null
                                  ? 'Хоосон'
                                  : item.companyId.toString(),
                            ),
                            // _buildItem(
                            //   'Компани төрөл',
                            //   item.name.toString() == 'person'
                            //       ? 'Хувь хүн'
                            //       : 'Компани',
                            // ),
                            // _buildItem('Албан тушаал', item.name.toString()),
                            _buildItem(
                                'Гар утас',
                                item.phone == null
                                    ? 'Хоосон'
                                    : item.phone.toString()),
                            // _buildItem('утас', item.phone.toString()),
                            _buildItem(
                                'и-мэйл',
                                item.email == null
                                    ? 'Хоосон'
                                    : item.email.toString()),
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
              style: TextStyles.white16semibold,
            ),
          ),
          Expanded(
            child: Text(
              name,
              style: TextStyles.white16,
            ),
          ),
        ],
      ),
    ),
  );
}
