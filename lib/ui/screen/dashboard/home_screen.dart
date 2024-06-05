import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/ui/screen/dashboard/stock_category.dart';
import 'package:abico_delivery_start/ui/screen/sales/sales_home_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (reason) async {
        // Return a Future<void> to prevent the back button from closing the app
        return;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 130,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, bottom: 15, right: 5),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const StockCategoryScreen()));
                    },
                    child: Container(
                      width: 180,
                      height: 160,
                      decoration: BoxDecoration(
                          boxShadow: const [BoxShadows.shadow3],
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.white),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Агуулах',
                              style: TextStyles.main20semibold,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Icon(
                              size: 50,
                              Icons.warehouse_outlined,
                              color: AppColors.mainColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, bottom: 15, right: 15),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SalesHomeScreen(),
                        ),
                      );
                    },
                    child: Ink(
                      width: 180,
                      height: 160,
                      decoration: BoxDecoration(
                          boxShadow: const [BoxShadows.shadow3],
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.white),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Борлуулалт',
                              style: TextStyles.main20semibold,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Icon(
                              size: 50,
                              Icons.shopping_cart_outlined,
                              color: AppColors.mainColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
