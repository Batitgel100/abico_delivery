import 'package:abico_orders/constant/constant.dart';
import 'package:abico_orders/ui/components/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool remember = false;
  RegExp pattern = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:Column(
        children: [
          const Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image(
                    image: AssetImage(
                      'assets/ivco_logo.png',
                    ),
                    fit: BoxFit.scaleDown,
                  ),
                ],
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // _buildIpField(),
                  // const SizedBox(
                  //   height: 20,
                  // ),
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
                     
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.065,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
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
                  const Text('IVCO LLC 2023'),
                  const SizedBox(
                    height: 40,
                  ),
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

  CustomTextField _buildPasswordField() {
    return CustomTextField(
      baseColor: AppColors.secondBlack,
      borderColor: AppColors.mainColor,
      controller: passwordController,
      errorColor: Colors.red,
      hint: 'Нууц үг',
      obscureText: true,
    );
  }

  CustomTextField _buildEmailField() {
    return CustomTextField(
      baseColor: AppColors.secondBlack,
      borderColor: AppColors.mainColor,
      controller: emailController,
      errorColor: Colors.red,
      hint: 'Нэвтрэх нэр',
    );
  }
}

