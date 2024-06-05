import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/model/inventory/inventory_entity.dart';
import 'package:abico_delivery_start/model/product_entity.dart';
import 'package:abico_delivery_start/model/stock_picking/stock_picking_model.dart';
import 'package:abico_delivery_start/service/inventory/inventory_line_create_repo.dart';
import 'package:abico_delivery_start/service/product/product_list_repo.dart';
import 'package:abico_delivery_start/ui/components/custom_indicator.dart';
import 'package:abico_delivery_start/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateInventoryLineDialog extends StatefulWidget {
  final Function onclick;
  final int inventoryId;
  final List<LocationIds>? locationList;
  const CreateInventoryLineDialog(
      {Key? key,
      required this.locationList,
      required this.inventoryId,
      required this.onclick})
      : super(key: key);

  @override
  State<CreateInventoryLineDialog> createState() =>
      _CreateInventoryLineDialogState();
}

class _CreateInventoryLineDialogState extends State<CreateInventoryLineDialog> {
  TextEditingController qty = TextEditingController();
  ProductListApiClient productListGet = ProductListApiClient();
  TextEditingController controller = TextEditingController();
  final CreateInventoryLineApiClient apiClient = CreateInventoryLineApiClient();
  List<ProductEntity> productList = [];
  List<ProductEntity> filteredProductList = [];
  List<LocationIds>? locationList = [];
  bool choose = false;
  bool locationChoose = false;
  bool locationSelected = false;
  bool isLoading = true;
  bool isSelected = false;
  bool isLocationSingle = false;
  String productName = 'Сонгоогүй';
  String locationName = '';
  int productId = 0;
  int locationId = 0;
  String barcode = '0';
  @override
  void initState() {
    super.initState();

    locationList = widget.locationList;
  }

  void onClick() async {
    if (locationSelected == false) {
      Utils.flushBarErrorMessage('Байршил сонгоно уу!', context);
    } else if (isSelected == false) {
      Utils.flushBarErrorMessage('Бараа сонгоно уу!', context);
    } else {
      try {
        double qtyValue = double.tryParse(qty.text) ?? 0.0;

        await apiClient.create(
          productId,
          locationId,
          widget.inventoryId,
          qtyValue,
          productName,
          barcode,
          context,
        );

        await widget.onclick();
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
      } catch (error) {
        print('Error in onClick: $error');
        // Handle the error as needed
      }
    }
  }

  void _filterProducts(String query) {
    setState(
      () {
        filteredProductList = productList
            .where((product) =>
                product.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      },
    );
  }

  Future<void> fetchData() async {
    try {
      List<ProductEntity> data = await productListGet.fetchData();
      if (mounted) {
        setState(() {
          productList = data;
          filteredProductList = productList;
          isLoading = false;
          print('success product data');
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  void dispose() {
    super.dispose();
    qty.dispose();
    // Dispose any resources here if needed
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 95,
        height: choose ? MediaQuery.of(context).size.height * 0.5 : null,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              _title(
                'Байршил :',
              ),
              const SizedBox(
                height: 10,
              ),
              locationChoose
                  ? SizedBox(
                      height: 100,
                      child: ListView.builder(
                        itemCount: locationList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          var item = locationList![index];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                locationChoose = false;
                                locationName = item.displayName;
                                locationSelected = true;
                                locationId = item.id;
                              });
                            },
                            child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(104, 26, 81, 0.9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    item.displayName,
                                    style: TextStyles.white16,
                                  ),
                                )),
                          );
                        },
                      ),
                    )
                  : locationSelected
                      ? Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.mainColor),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  locationName,
                                  style: TextStyles.white16semibold,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    locationSelected = false;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                    color: Colors.white,
                                  ),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            setState(() {
                              locationChoose = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.mainColor,
                                boxShadow: const [BoxShadows.shadow3]),
                            child: const Text(
                              'Байршил сонгох',
                              style: TextStyles.white16,
                            ),
                          ),
                        ),
              const SizedBox(
                height: 20,
              ),
              _line(),
              const SizedBox(
                height: 20,
              ),
              isSelected
                  ? const SizedBox()
                  : TextField(
                      controller: controller,
                      onChanged: _filterProducts,
                      decoration: InputDecoration(
                        labelText: 'Бараа хайх',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              choose ? _buildDropDownList(context) : const SizedBox(),
              choose
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title(
                          'Сонгосон бараа :',
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        isSelected
                            ? Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.mainColor),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        productName,
                                        style: TextStyles.white16semibold,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                    productName == 'Сонгоогүй'
                                        ? const SizedBox()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                isSelected = false;
                                                choose = true;
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                                color: Colors.white,
                                              ),
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                              )
                            : InkWell(
                                onTap: () async {
                                  setState(() {
                                    isLoading = true;
                                    choose = true;
                                  });
                                  await fetchData();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: AppColors.mainColor,
                                      boxShadow: const [BoxShadows.shadow3]),
                                  child: const Text(
                                    'Бараа сонгох',
                                    style: TextStyles.white16,
                                  ),
                                ),
                              ),
                      ],
                    ),
              const SizedBox(
                height: 20,
              ),
              _line(),
              const SizedBox(
                height: 20,
              ),
              _title('Тоо ширхэг'),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: qty,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Тоо ширхэг оруулах',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: onClick,
          child: const Text('Нэмэх'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without creating
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Container _line() {
    return Container(
      height: 1,
      color: const Color.fromARGB(177, 0, 0, 0),
    );
  }

  Text _title(String text) {
    return Text(
      text,
      style: TextStyles.black16semibold,
    );
  }

  Widget _buildDropDownList(BuildContext context) {
    return isLoading
        ? const Center(child: CustomProgressIndicator())
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView.separated(
              itemCount: filteredProductList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                var item = filteredProductList[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      choose = false;
                      isSelected = true;
                      productName = item.name.toString();
                      productId = item.id;
                      barcode = (item.barcode == 'null' ? '0' : item.barcode)!;
                    });
                    print('*** бүтээгдэхүнн сонгогдлоо.');
                    setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(104, 26, 81, 0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                item.name.toString(),
                                style: TextStyles.white16,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}
