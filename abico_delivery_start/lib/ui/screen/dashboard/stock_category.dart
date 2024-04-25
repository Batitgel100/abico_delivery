import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/ui/screen/stock_inventory/stock_inventory_screen.dart';
import 'package:abico_delivery_start/ui/screen/stock_picking/stock_picking_screen.dart';
import 'package:abico_delivery_start/ui/screen/product/product_screen.dart';
import 'package:flutter/material.dart';

class StockCategoryScreen extends StatefulWidget {
  const StockCategoryScreen({super.key});

  @override
  State<StockCategoryScreen> createState() => _StockCategoryScreenState();
}

class _StockCategoryScreenState extends State<StockCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, bottom: 15, right: 20, top: 60),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StockScreen()),
                  );
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      boxShadow: const [BoxShadows.shadow3],
                      borderRadius: BorderRadius.circular(20),
                      gradient: Gradients.gradient),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Агуулахын хөдөлгөөн',
                          style: TextStyles.white20semibold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 15, right: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProductScreen()),
                  );
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      boxShadow: const [BoxShadows.shadow3],
                      borderRadius: BorderRadius.circular(20),
                      gradient: Gradients.gradient),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Барааны бүртгэл',
                          style: TextStyles.white20semibold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 15, right: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const StockInventoryScreen()),
                  );
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      boxShadow: const [BoxShadows.shadow3],
                      borderRadius: BorderRadius.circular(20),
                      gradient: Gradients.gradient),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Тооллого бүртгэл',
                          style: TextStyles.white20semibold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
