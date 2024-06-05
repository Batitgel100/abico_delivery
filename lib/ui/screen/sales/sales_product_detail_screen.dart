import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/globals.dart';
import 'package:abico_delivery_start/model/product_entity.dart';
import 'package:abico_delivery_start/ui/components/custom_button.dart';
import 'package:abico_delivery_start/ui/screen/sales/sales_product_screen.dart';
import 'package:flutter/material.dart';

class SalesProductDetailScreen extends StatefulWidget {
  final List<CartItem> list;
  const SalesProductDetailScreen({super.key, required this.list});

  @override
  State<SalesProductDetailScreen> createState() =>
      _SalesProductDetailScreenState();
}

class _SalesProductDetailScreenState extends State<SalesProductDetailScreen> {
  double totalListPrice = 0;
  double totalTatvar = 0;
  double withoutTatvar = 0;
  TextEditingController searchController = TextEditingController();
  List<CartItem> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = widget.list;
    getTotal();
    searchController.addListener(() {
      filterList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterList() {
    if (searchController.text.isEmpty) {
      setState(() {
        filteredList = widget.list;
      });
    } else {
      setState(() {
        filteredList = widget.list.where((item) {
          return item.name
              .toLowerCase()
              .contains(searchController.text.toLowerCase());
        }).toList();
      });
    }
  }

  double get tax {
    var total = 0.0;
    for (var item in widget.list) {
      total += item.price * item.quantity;
    }
    return total / 1.1 * 0.1;
  }

  getTotal() {
    if (mounted) {
      setState(() {
        totalListPrice = widget.list
            .fold(0, (sum, item) => sum + (item.price * item.quantity ?? 0));
        totalTatvar = tax;
        withoutTatvar = totalListPrice - tax;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _partner(),
              _info(),
              const SizedBox(
                height: 10,
              ),
              _search(context),
              const SizedBox(
                height: 10,
              ),
              _list(context),
              _errorList(context),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: CustomButton(
                  title: 'Илгээх',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ));
  }

  Container _errorList(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: MediaQuery.of(context).size.height * 0.15,
        child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xff6669f1))),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: const Text('Text'));
            }));
  }

  SizedBox _list(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (_, index) {
          var item = filteredList[index];
          double total = item.price * item.quantity;

          return GestureDetector(
            onTap: () async {},
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              color: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/icons/products.png'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              children: [
                                Text(
                                  item.name.toString(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Үнэ: ${item.price} ',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 139, 40, 40),
                                      fontSize: 12),
                                ),
                                Text(
                                  'Тоо:  ${item.quantity}',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 139, 40, 40),
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            Text(
                              ('Нийт: $total'),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 139, 40, 40),
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Padding _search(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        decoration: const BoxDecoration(boxShadow: [BoxShadows.shadows]),
        child: Center(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              hintText: 'Хайх',
              prefixIcon: const Icon(Icons.search),
              prefixIconColor: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Padding _info() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Татваргүй дүн: ${withoutTatvar.toStringAsFixed(2)}',
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Татвар: ${totalTatvar.toStringAsFixed(2)}',
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Нийт: $totalListPrice',
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Row _partner() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(206, 226, 105, 145),
                    Color.fromRGBO(104, 26, 81, 0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Захиалагч: ${Globals.getZahialagch()}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      ],
    );
  }

//app bar iin widget
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
