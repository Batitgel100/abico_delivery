// ignore_for_file: use_build_context_synchronously

import 'package:abico_delivery_start/model/inventory/inventory_line_entity.dart';
import 'package:abico_delivery_start/service/inventory/inventory_line_put.dart';
import 'package:abico_delivery_start/utils/utils.dart';
import 'package:flutter/material.dart';

class StockInventoryBarCodeDialog extends StatefulWidget {
  final InventoryLineEntity note;
  final dynamic data;
  final Function handleButtonCallback;

  const StockInventoryBarCodeDialog({
    Key? key,
    required this.note,
    this.data,
    required this.handleButtonCallback,
  }) : super(key: key);

  @override
  _StockInventoryBarCodeDialogState createState() =>
      _StockInventoryBarCodeDialogState();
}

class _StockInventoryBarCodeDialogState
    extends State<StockInventoryBarCodeDialog> {
  StockInventoryLinePutApiClient linePut = StockInventoryLinePutApiClient();
  StockInventoryLineHistoryPostApiClient history =
      StockInventoryLineHistoryPostApiClient();
  final TextEditingController controller = TextEditingController(text: '0');
  double? productQuantity;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    too();
  }

  void too() {
    productQuantity = widget.note.productQty;
    setState(() {});
  }

  void handleButton() async {
    final double inputValue = double.tryParse(controller.text) ?? 0.0;
    final double? productQty = widget.note.productQty;
    final double actionValue = productQty! + inputValue;

    if (inputValue > 0.0) {
      try {
        await linePut.getStockInventoryLinePutList(
          '49.0.129.18:9393',
          widget.note.id.toString(),
          actionValue.toString(),
        );
        await history.getStockInventoryLineHistoryPostList(
          widget.note.id.toString(),
          's',
          inputValue.toString(),
          // '-$inputValue'
        );
        setState(() {
          Utils.flushBarSuccessMessage(
              'Амжилттай $inputValue - р нэмэгдлээ', context);
          widget.note.productQty =
              actionValue; // Update the note object with the new productQty
        });
        // Navigator.pop(context); // Close the dialog after successful operation
      } catch (e) {
        historyPostPlus();
        await widget.handleButtonCallback();

        setState(() {
          widget.note.productQty =
              actionValue; // Update the note object with the new productQty
        });

        Navigator.pop(context);
        Utils.flushBarSuccessMessage(
            'Амжилттай $inputValue - р нэмэгдлээ', context);
      }
    } else {
      Utils.flushBarErrorMessage('Амжилтгүй: Нэгж оруулна уу', context);
    }
  }

  void handleButtonMinus() async {
    final double inputValue = double.tryParse(controller.text) ?? 0.0;
    final double? productQty = widget.note.productQty;
    final double actionValue = productQty! - inputValue;

    if (inputValue > 0.0) {
      try {
        await linePut.getStockInventoryLinePutList(
          '49.0.129.18:9393',
          widget.note.id.toString(),
          actionValue.toString(),
        );

        setState(() {
          Utils.flushBarSuccessMessage(
              'Амжилттай $inputValue - р хасагдлаа', context);
          widget.note.productQty =
              actionValue; // Update the note object with the new productQty
        });
      } catch (e) {
        historyPostMinus();
        await widget.handleButtonCallback();
        setState(() {
          widget.note.productQty =
              actionValue; // Update the note object with the new productQty
        });
        Navigator.pop(context);
        Utils.flushBarSuccessMessage(
            'Амжилттай $inputValue - р хасагдлаа', context);
      }
    } else {
      Utils.flushBarErrorMessage('Амжилтгүй: Нэгж оруулна уу', context);
    }
  }

  void historyPostMinus() async {
    final double inputValue = double.tryParse(controller.text) ?? 0.0;
    await history.getStockInventoryLineHistoryPostList(
        widget.note.id.toString(),
        's',
        // inputValue.toString(),
        '-$inputValue');
  }

  void historyPostPlus() async {
    final double inputValue = double.tryParse(controller.text) ?? 0.0;
    await history.getStockInventoryLineHistoryPostList(
        widget.note.id.toString(),
        's',
        // inputValue.toString(),
        '$inputValue');
  }

  @override
  Widget build(BuildContext context) {
    too();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Бараа: ${widget.note.productId?.displayName}' ?? 'Хоосон'),
              const SizedBox(height: 10),
              Text('Гарт байгаа: ${widget.note.theoreticalQty}'),
              Text('Тоолсон тоо: $productQuantity'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Тоолсон тоо:'),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
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
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: controller,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: handleButtonMinus, child: const Text('хасах')),
              ElevatedButton(
                  onPressed: handleButton, child: const Text('нэмэх'))
            ],
          )
        ],
      ),
    );
  }
}
