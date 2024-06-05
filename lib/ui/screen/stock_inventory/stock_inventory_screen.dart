import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/globals.dart';
import 'package:abico_delivery_start/model/inventory/inventory_entity.dart';
import 'package:abico_delivery_start/model/stock_picking/stock_picking_model.dart';
import 'package:abico_delivery_start/service/inventory/inventory_repo.dart';
import 'package:abico_delivery_start/service/stock_picking/stock_picking_api.dart';
import 'package:abico_delivery_start/ui/components/custom_indicator.dart';
import 'package:abico_delivery_start/ui/screen/stock_inventory/inventory_item_screen.dart';
import 'package:abico_delivery_start/ui/screen/stock_picking/stock_picking_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class StockInventoryScreen extends StatefulWidget {
  const StockInventoryScreen({super.key});

  @override
  State<StockInventoryScreen> createState() => _StockInventoryScreenState();
}

class _StockInventoryScreenState extends State<StockInventoryScreen> {
  InventoryApiClient getInventoryList = InventoryApiClient();
  final TextEditingController stockPickingController = TextEditingController();
  List<InventoryEntity> inventoryList = [];
  List<InventoryEntity> inventoryFilteredList = [];
  String searchQuery = '';
  bool isLoading = true;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    fetchStockPickingData();
  }

  void fetchStockPickingData() {
    getInventoryList.fetchStockPicking().then((data) {
      if (mounted) {
        setState(() {
          inventoryList = data;
          isLoading = false;
        });
      }
    });
  }

  void findLocationName() {}

  Future<void> _refreshList() async {
    List<InventoryEntity> updatedData =
        await getInventoryList.fetchStockPicking();
    setState(() {
      inventoryList = updatedData;
      inventoryFilteredList = inventoryList.where((item) {
        return item.name!.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    });
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
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CustomProgressIndicator(),
                        ),
                      )
                    : _buildList(),
              ],
            )));
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
          onChanged: (query) {
            setState(() {
              searchQuery = query;
              inventoryFilteredList = inventoryList.where((item) {
                // Your search logic here
                return item.name!.toLowerCase().contains(query.toLowerCase());
              }).toList();
            });
          },
        ),
      ),
    );
  }

  Expanded _buildList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 15),
        itemCount: searchQuery.isEmpty
            ? inventoryList.length
            : inventoryFilteredList.length,
        itemBuilder: (BuildContext context, int index) {
          final item = searchQuery.isEmpty
              ? inventoryList[index]
              : inventoryFilteredList[index];
          // if (item.state != "draft" && item.state != "confirm") {
          //   return const SizedBox.shrink();
          // }
          final List<LocationIds>? locationIds = item.locationIdss;
          final locationNames =
              locationIds!.map((location) => location.displayName).join(', ');

          String formattedDate = item.accountingDate != null
              ? DateFormat('yyyy-MM-dd').format(item.accountingDate!)
              : '';
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => InventoryItemScreen(
                            itemss: item,
                            locationName: locationNames,
                          )),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color.fromARGB(255, 104, 26, 81),
                        Color.fromARGB(255, 196, 92, 113),
                      ],
                    )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: .0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildItem('Тооллогын код', item.name ?? 'Хоосон'),
                      _buildItem('Санхүүгийн огноо', formattedDate),
                      _buildItem('Компани', Globals.getCompany() ?? 'Хоосон'),
                      _buildItem(
                        'Байрлалууд',

                        // (item.locationIds != null && item.locationIds!.isNotEmpty)
                        //     ? '${item.locationIds![0].displayName}'
                        //     :
                        item.locationIdss == '' ? 'Хоосон' : locationNames,
                      ),
                      _buildState(item),
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

  Padding _buildState(InventoryEntity item) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.facebookBlue,
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
            children: [
              if (item.state.toString() == 'assigned')
                const Text(
                  'Батлагдсан',
                  style: TextStyles.black16semibold,
                )
              else if (item.state.toString() == 'draft')
                const Text(
                  'Ноорог',
                  style: TextStyles.black14semibold,
                )
              else if (item.state.toString() == 'confirm')
                const Text(
                  'Явагдаж буй',
                  style: TextStyles.black14semibold,
                )
              else if (item.state.toString() == 'cancel')
                const Text(
                  'Цуцлагдсан',
                  style: TextStyles.black14semibold,
                ),
            ],
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
