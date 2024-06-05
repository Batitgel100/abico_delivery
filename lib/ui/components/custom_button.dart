import 'package:abico_delivery_start/constant/constant.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {Key? key,
      this.height,
      this.width,
      required this.title,
      this.onTap,
      this.loading = false})
      : super(key: key);
  double? height;
  double? width;
  String title;
  VoidCallback? onTap;
  bool loading;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadows.shadows]),
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.white,
                ))
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyles.white14semibold,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
