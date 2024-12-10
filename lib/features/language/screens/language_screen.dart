import 'package:flutter/material.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/language/screens/web_language_screen.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/features/language/widgets/language_card_widget.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatefulWidget {
  final bool fromMenu;
  const LanguageScreen({super.key, required this.fromMenu});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.fromMenu || ResponsiveHelper.isDesktop(context))
          ? CustomAppBarWidget(title: 'language'.tr, isBackButtonExist: true)
          : null,
      endDrawer: const MenuDrawerWidget(),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Theme.of(context).cardColor,
      body:
          GetBuilder<LocalizationController>(builder: (localizationController) {
        return ResponsiveHelper.isDesktop(context)
            ? const WebLanguageScreen()
            : Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 16, end: 16, bottom: 43),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 128),
                      const Align(
                        alignment: Alignment.center,
                        child:
                        CustomAssetImageWidget(
                          Images.lang,
                          height: 79,
                          width: 171,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 89),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                      //   child: Text('choose_your_language'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      // ),
                      // const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                      //   child: Text('choose_your_language_to_proceed'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      // ),
                      // const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      Expanded(
                        child: SingleChildScrollView(
                          child: SizedBox(
                            child: GridView.builder(
                                itemCount:
                                    localizationController.languages.length,
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 16,
                                        mainAxisExtent: 136),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return LanguageCardWidget(
                                    languageModel:
                                        localizationController.languages[index],
                                    localizationController:
                                        localizationController,
                                    index: index,
                                  );
                                }),
                          ),
                        ),
                      ),
                      CustomButtonWidget(
                        color: const Color(0xff2B3D16),
                        height: 40,
                        radius: 6,
                        buttonText: 'save'.tr,
                        onPressed: () {
                          if (localizationController.languages.isNotEmpty &&
                              localizationController.selectedLanguageIndex !=
                                  -1) {
                            localizationController.setLanguage(Locale(
                              AppConstants
                                  .languages[localizationController
                                      .selectedLanguageIndex]
                                  .languageCode!,
                              AppConstants
                                  .languages[localizationController
                                      .selectedLanguageIndex]
                                  .countryCode,
                            ));
                            if (widget.fromMenu) {
                              Navigator.pop(context);
                            } else {
                              Get.offNamed(RouteHelper.getOnBoardingRoute());
                            }
                          } else {
                            showCustomSnackBar('select_a_language'.tr);
                          }
                        },
                      ),
                    ]),
              );
      }),
    );
  }
}
