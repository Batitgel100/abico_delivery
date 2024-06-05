import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/ui/screen/sales/sales_order_screen.dart';
import 'package:flutter/material.dart';

class SalesHomeScreen extends StatefulWidget {
  const SalesHomeScreen({super.key});

  @override
  State<SalesHomeScreen> createState() => _SalesHomeScreenState();
}

class _SalesHomeScreenState extends State<SalesHomeScreen> {
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
                    MaterialPageRoute(
                      builder: (_) => const SalesOrderScreen(),
                    ),
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
                          'Борлуулалтын захиалга',
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => ),
                  // );
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
                          'Харилцагч',
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (_) => ),
                  // );
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
                          'Үнийн хүснэгт',
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
