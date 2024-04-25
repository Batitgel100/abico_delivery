import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/model/stock_picking/stock_picking_model.dart';
import 'package:abico_delivery_start/service/stock_picking/stock_picking_api.dart';
import 'package:abico_delivery_start/ui/components/custom_indicator.dart';
import 'package:abico_delivery_start/ui/screen/stock_picking/stock_picking_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  StockPickingApiClient getStockPickingList = StockPickingApiClient();
  final TextEditingController stockPickingController = TextEditingController();
  List<StockPickingEntity> stockPickingList = [];
  List<StockPickingEntity> stockPickingFilteredList = [];
  String searchQuery = '';
  bool isLoading = true;
  bool isSelected = false;
  String locationName = '';

  @override
  void initState() {
    super.initState();
    fetchStockPickingData();
  }

  void fetchStockPickingData() {
    getStockPickingList.fetchStockPicking().then((data) {
      if (mounted) {
        setState(() {
          stockPickingList = data;
          isLoading = false;
        });
      }
    });
  }

  void findLocationName() {}

  Future<void> _refreshList() async {
    List<StockPickingEntity> updatedData =
        await getStockPickingList.fetchStockPicking();
    setState(() {
      stockPickingList = updatedData;
      stockPickingFilteredList = stockPickingList.where((item) {
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
              stockPickingFilteredList = stockPickingList.where((item) {
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
            ? stockPickingList.length
            : stockPickingFilteredList.length,
        itemBuilder: (BuildContext context, int index) {
          final item = searchQuery.isEmpty
              ? stockPickingList[index]
              : stockPickingFilteredList[index];
          // if (item.state != "draft" && item.state != "confirm") {
          //   return const SizedBox.shrink();
          // }
          String formattedDate = item.scheduledDate != null
              ? DateFormat('yyyy-MM-dd').format(item.scheduledDate!)
              : '';
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CountItemScreen(
                            itemss: item,
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
                      _buildItem('Хүргэлтийн нэр', item.name ?? 'Хоосон'),
                      _buildItem(
                          'Хүргэлтийн хаяг',
                          item.scheduledDate == null
                              ? item.scheduledDate.toString()
                              : 'Хоосон'),
                      _buildItem(
                          'Агуулахын баримтын төрөл', item.name ?? 'Хоосон'),
                      _buildItem(
                        'Эх байрлал',
                        item.locationId?.name ?? 'Хоосон',
                      ),
                      _buildItem('Товлосон огноо', formattedDate),
                      _buildItem('Эх баримт', item.origin ?? 'Хоосон'),
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

  Padding _buildState(StockPickingEntity item) {
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
