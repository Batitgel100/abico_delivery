import 'package:abico_delivery_start/model/stock_picking/stock_picking_line_entity.dart';
import 'package:abico_delivery_start/service/stock_picking/stock_picking_put_repo.dart';
import 'package:abico_delivery_start/utils/utils.dart';
import 'package:flutter/material.dart';

class StockOnePickingDialog extends StatefulWidget {
  final StockPickingLineEntity note;
  final Function handleButtonCallback;

  const StockOnePickingDialog(
      {super.key, required this.note, required this.handleButtonCallback});

  @override
  State<StockOnePickingDialog> createState() => _StockOnePickingDialogState();
}

class _StockOnePickingDialogState extends State<StockOnePickingDialog> {
  final controller = TextEditingController(text: "0");
  StockMovePutApiClient put = StockMovePutApiClient();
  List<StockPickingLineEntity> stockMoveLineData = [];

  bool ihbaival = false;

  double number = 0;
  @override
  void initState() {
    number = widget.note.diffQty!;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Бараа ${widget.note.productName}'),
                const SizedBox(
                  height: 10,
                ),
                Text('Бэлдэх тоо ${widget.note.productUomQty}'),
                Text('Бэлдсэн тоо ${widget.note.checkQty}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Тоолсон тоо:'),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        scrollPadding:
                            const EdgeInsets.symmetric(horizontal: 50),
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
                        keyboardType: TextInputType.number,
                        controller: controller,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Үгүй')),
                    buildButton()
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildButton() {
    return ElevatedButton(
      onPressed: addOrUpdateNote,
      child: const Text('Тийм'),
    );
  }

  void addOrUpdateNote() async {
    int checkQty = widget.note.checkQty!.toInt();
    int a = int.parse(controller.text);

    final isUpdating = widget.note != null;
    if (widget.note.productUomQty! >= widget.note.checkQty! + 1) {
      // ynzliishuu +a shuu
      int too =
          // checkQty +
          a;
      put.getStockMovePutList(
        '49.0.129.18:9393',
        widget.note.id.toString(),
        too.toString(),
      );
      await widget.handleButtonCallback();

      Navigator.of(context).pop();
      Utils.flushBarSuccessMessage('Амжилттай $too - р нэмэгдлээ', context);
    } else {
      setState(() {
        ihbaival == true;
      });
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content: Text(
          'Бэлдсэн тоо нь Бэлдэх тооноос их байж болохгүй',
          textAlign: TextAlign.center,
        )));
    }
  }

  // Future updateNote() async {
  //   double a = double.parse(controller.text);
  //   await DBProvider.db.updateStockMoveLine(StockMoveLineEntity(
  //     id: widget.note.id,
  //     productId: widget.note.productId,
  //     descriptionPicking: widget.note.descriptionPicking,
  //     dateExpected: widget.note.dateExpected,
  //     quantityDone: widget.note.quantityDone,
  //     productUom: widget.note.productUom,
  //     productUomQty: widget.note.productUomQty,
  //     pickingId: widget.note.pickingId,
  //     checkQty: widget.note.checkQty + a,
  //     diffQty: widget.note.diffQty,
  //     barcode: widget.note.barcode,
  //     productName: widget.note.productName,
  //   ));
  // }
}
