import 'package:abico_delivery_start/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatefulWidget {
  final String version;
  final String description;
  final String appLink;
  final bool allowDismissal;

  const UpdateDialog(
      {super.key,
      this.version = " ",
      required this.description,
      required this.appLink,
      required this.allowDismissal});

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  void dispose() {
    if (!widget.allowDismissal) {
      print("EXIT APP");
      // SystemNavigator.pop(); this will close the app
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastLinearToSlowEaseIn,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: content(context),
      ),
    );
  }

  Widget content(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: screenHeight / 12,
          width: screenWidth / 1.5,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              topLeft: Radius.circular(12),
            ),
            color: AppColors.mainColor,
          ),
          child: const Center(
            child: Text(
              'Шинэчлэл хийх',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Container(
          height: screenHeight / 10,
          width: screenWidth / 1.5,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        widget.allowDismissal
                            ? Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.mainColor,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Үгүй",
                                        style: TextStyle(
                                          color: AppColors.mainColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(
                          width: widget.allowDismissal ? 16 : 0,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await launchUrl(Uri.parse(
                                  'https://apps.apple.com/app/abico-stock/id6499345046'));
                            },
                            child: Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.mainColor,
                                // boxShadow: const [BoxShadows.shadow3],
                              ),
                              child: const Center(
                                child: Text("Шинэчлэх",
                                    style: TextStyles.white16semibold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
