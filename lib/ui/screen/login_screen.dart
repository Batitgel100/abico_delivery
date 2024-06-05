// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';

import 'package:abico_delivery_start/app_types.dart';
import 'package:abico_delivery_start/constant/constant.dart';
import 'package:abico_delivery_start/service/authentication.dart';
import 'package:abico_delivery_start/ui/components/custom_text_field.dart';
import 'package:abico_delivery_start/ui/components/update_dialog.dart';
import 'package:abico_delivery_start/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ipController = TextEditingController();
  AuthService auth = AuthService();
  bool remember = false;
  RegExp pattern = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  @override
  void initState() {
    super.initState();
    final newVersion = NewVersion(androidId: 'com.tengerSoft.AbicoDelivery');
    Timer(const Duration(microseconds: 800), () {
      checkNewVersion(newVersion);
    });
    loadSavedCredentials();
  }

  void checkNewVersion(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      if (status.canUpdate) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return UpdateDialog(
              allowDismissal: true,
              description: status.releaseNotes!,
              version: status.storeVersion,
              appLink: status.appStoreLink,
            );
          },
        );
      }
    }
  }

  void main() async {
    if (remember == true) {
      saveCredentials();
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }

    final loggedIn = await auth.login(ipController.text, emailController.text,
        passwordController.text, context);
    if (loggedIn) {
      Utils.flushBarSuccessMessage('Амжилттай нэвтэрлээ', context);
      print('Амжилттай нэвтэрлээ');
      Navigator.pushReplacementNamed(context, RoutesName.main);
    } else {
      // print('Нэвтрэх хүсэлт амжилтгүй');
      Utils.flushBarErrorMessage(
          // Нэвтрэх нэр эсвэл нууц үг буруу байна.
          ' Нэвтрэх хүсэлт амжилтгүй',
          context);
    }
  }

  Future<void> saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ip', ipController.text);

    await prefs.setString('username', emailController.text);
    await prefs.setString('password', passwordController.text);
  }

  Future<void> loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedIp = prefs.getString('ip');
    final savedUsername = prefs.getString('username');
    final savedPassword = prefs.getString('password');
    if (mounted) {
      setState(() {
        ipController.text = savedIp ?? '';
        emailController.text = savedUsername ?? '';
        passwordController.text = savedPassword ?? '';

        remember =
            savedIp != null && savedUsername != null && savedPassword != null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image(
                    image: AssetImage(
                      'assets/images/logo/tenger_logo.png',
                    ),
                    width: 220.0,
                    height: 120.0,
                    fit: BoxFit.scaleDown,
                  ),
                ],
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIpField(),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildEmailField(),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildPasswordField(),
                  const SizedBox(
                    height: 20,
                  ),
                  _buldCheckBox(),
                  InkWell(
                    onTap: () {
                      if (ipController.text.isEmpty) {
                        Utils.flushBarErrorMessage(
                            'Хандах хаягаа оруулна уу', context);
                      } else if (emailController.text.isEmpty) {
                        Utils.flushBarErrorMessage(
                            'Нэвтрэх нэрээ оруулна уу', context);
                      } else if (passwordController.text.isEmpty) {
                        Utils.flushBarErrorMessage(
                            'Нууц үг оруулна уу', context);
                      } else if (passwordController.text.length < 3) {
                        Utils.flushBarErrorMessage(
                            '6 оронтой тоо оруулна уу', context);
                      } else {
                        main();
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.065,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.mainColor),
                      child: const Center(
                        child: Text(
                          'Нэвтрэх',
                          style: TextStyles.white16semibold,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _buldCheckBox() {
    return Row(
      children: [
        Checkbox(
          value: remember,
          tristate: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onChanged: (newValue) {
            setState(() {
              remember = newValue ?? false;
            });
          },
        ),
        const Text('Хэрэглэгч сануулах'),
      ],
    );
  }

  CustomPasswordField _buildPasswordField() {
    return CustomPasswordField(
      controller: passwordController,
      onChanged: (String value) {},
      hintText: '',
      labelText: 'Нууц үг',
    );
  }

  CustomTextField _buildEmailField() {
    return CustomTextField(
      controller: emailController,
      onChanged: (String value) {},
      hintText: '',
      labelText: 'Нэвтрэх нэр',
    );
  }

  CustomTextField _buildIpField() {
    return CustomTextField(
      controller: ipController,
      onChanged: (String value) {},
      hintText: '',
      labelText: 'Хандах хаяг',
    );
  }
}
