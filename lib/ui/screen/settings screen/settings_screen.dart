import 'dart:convert';

import 'package:abico_delivery_start/app_types.dart';
import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/globals.dart';
import 'package:abico_delivery_start/model/employe_data_entity.dart';
import 'package:abico_delivery_start/service/company_name_repo.dart';
import 'package:abico_delivery_start/service/settings_repo.dart';
import 'package:abico_delivery_start/ui/components/custom_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // final bool _refreshData = false;
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('*** хэрэглэгч гарлаа');
    Navigator.pushReplacementNamed(
      context,
      RoutesName.login,
    );
  }

  CompanyNameRepository getcompany = CompanyNameRepository();

  @override
  void initState() {
    super.initState();
    getcompany.getCompanyName();
    // _onRefresh();s
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: FutureBuilder<EmployeeDataEntity?>(
              future: EmployeDataApiClient().getEmployeeData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CustomProgressIndicator()); // Show a loading indicator while fetching data.
                } else if (snapshot.hasError) {
                  return _errorWidget();
                } else if (snapshot.hasData) {
                  final employee = snapshot.data!;

                  return _userWidget(context, employee);
                } else {
                  return const Text('No employee data available');
                }
              },
            ),
          ),
          _logoutWidget(context),
        ],
      ),
    );
  }

  SizedBox _logoutWidget(BuildContext context) {
    return SizedBox(
      // height: MediaQuery.of(context).size.height * 0.10,
      child: InkWell(
        onTap: logout,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color.fromARGB(255, 29, 60, 113),
              boxShadow: const [BoxShadows.shadow3]),
          child: const Center(
            child: Text(
              'Гарах',
              style: TextStyles.white16semibold,
            ),
          ),
        ),
      ),
    );
  }

  Column _userWidget(BuildContext context, EmployeeDataEntity employee) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.14,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  flex: employee.image1920 == null ? 0 : 2,
                  child: Container(
                    decoration: employee.image1920 == null
                        ? null
                        : BoxDecoration(
                            color: const Color.fromRGBO(104, 26, 81, 0.9),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: MemoryImage(base64Decode(
                                  employee.image1920,
                                ))),
                            borderRadius: BorderRadius.circular(50)),
                  )),
              Expanded(
                flex: 3,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      employee.name.toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      employee.jobTitle == null
                          ? ' Албан тушаал: Хоосон'
                          : ' Албан тушаал: ${employee.jobTitle.toString()}',
                      style: TextStyles.black16,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.32,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.mainColor),
              child: Column(
                children: [
                  _buildRow(
                    Globals.getCompany().isEmpty
                        ? 'Хоосон'
                        : Globals.getCompany(),
                    // 'IVCO',
                    'Компани',
                    const Icon(Icons.home, size: 30),
                  ),
                  _buildRow(
                    employee.mobilePhone == null
                        ? 'Хоосон'
                        : employee.mobilePhone.toString(),
                    // '99999999',
                    'Утасны дугаар',
                    const Icon(Icons.phone, size: 30),
                  ),
                  _buildRow(
                    employee.workEmail == null
                        ? 'Хоосон'
                        : employee.workEmail.toString(),

                    // 'email@ivco.mn',
                    'e-мэйл',
                    const Icon(Icons.email, size: 30),
                  ),
                  _buildRow(
                    employee.workLocation == null
                        ? 'Хоосон'
                        : employee.workLocation.toString(),
                    'Хаяг',
                    const Icon(Icons.location_city, size: 30),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Center _errorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // color: const Color.fromARGB(255, 238, 69, 57),
              color: AppColors.mainColor),
          height: 300,
          width: 300,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(
                image: AssetImage(
                  '/Users/unurjargal/Documents/GitHub/abico_delivery/abico_delivery_start/assets/dino.png',
                ),
                height: 200,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Интернэт холболтоо\nшалгана уу!',
                style: TextStyles.white20semibold,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String defualtText, String dynamicText, Icon icon) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.white),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: icon,
                )),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dynamicText,
                  style: TextStyles.white14semibold,
                ),
                Text(
                  defualtText,
                  style: TextStyles.white14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
