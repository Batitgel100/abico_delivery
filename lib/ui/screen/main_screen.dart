import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/service/company_name_repo.dart';
import 'package:abico_delivery_start/ui/screen/dashboard/home_screen.dart';
import 'package:abico_delivery_start/ui/screen/product/fake_product_screen.dart';
import 'package:abico_delivery_start/ui/screen/settings%20screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  CompanyNameRepository companyName = CompanyNameRepository();
  @override
  void initState() {
    super.initState();
    getEmployee();
    companyName.getCompanyName();
  }

  void getEmployee() {}

  int _selectedIndex = 0;

  Future<void> scanBarcode(BuildContext context) async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      print('barcode data: $barcodeScanRes');

      if (barcodeScanRes != '-1') {
        if (barcodeScanRes != '-1') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FakeProductScreen(barcode: barcodeScanRes),
            ),
          );
        }
        //navigate
      }
    } on PlatformException catch (e) {
      if (e.code == 'USER_CANCELLED') {
        print('Barcode scanning cancelled by user');
      } else {
        print('Failed to scan barcode: ${e.message}');
      }
    }
  }

  void _scan() async {
    await scanBarcode(context);
  }

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Нүүр',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.menu),
      label: 'Тохиргоо',
    ),
  ];
  static final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          onPressed: () => _scan(),
          backgroundColor: AppColors.mainColor,
          child: Image.asset(
            'assets/images/icons/scan.webp',
            color: Colors.white,
            width: 30,
          )),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        decoration: const BoxDecoration(
            boxShadow: [BoxShadows.shadows], color: Colors.white),
        child: BottomNavigationBar(
          selectedIconTheme: const IconThemeData(size: 35),
          elevation: 0,
          backgroundColor: Colors.transparent,
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.mainColor,
          unselectedItemColor: AppColors.secondBlack,
          items: _navItems,
          onTap: _onNavItemTapped,
        ),
      ),
    );
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
