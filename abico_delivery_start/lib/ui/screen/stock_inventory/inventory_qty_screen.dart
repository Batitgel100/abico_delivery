import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/model/inventory/inventory_line_entity.dart';
import 'package:abico_delivery_start/model/stock_picking/stock_picking_line_entity.dart';
import 'package:abico_delivery_start/ui/screen/stock_picking/stock_picking_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InventoryQtyUpdateScreen extends StatefulWidget {
  final int id;
  final InventoryLineEntity? item;

  const InventoryQtyUpdateScreen(
      {super.key, required this.item, required this.id});

  @override
  State<InventoryQtyUpdateScreen> createState() =>
      _InventoryQtyUpdateScreenState();
}

class _InventoryQtyUpdateScreenState extends State<InventoryQtyUpdateScreen> {
  // QuantityUpdateApiClient qtyUpdate = QuantityUpdateApiClient();
  TextEditingController qtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item!.productId!.displayName.toString(),
              style: TextStyles.black16semibold,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: qtyController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Тоо ширхэг оруулах',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {},
              child: const Text('Тоо засах'),
            )
          ],
        ),
      ),
    );
  }
}
