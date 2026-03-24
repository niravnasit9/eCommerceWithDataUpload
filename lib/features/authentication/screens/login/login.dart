import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:yt_ecommerce_admin_panel/common/styles/spacing_styles.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/login_signup/form_divider.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/login_signup/social_buttons.dart';
import 'package:yt_ecommerce_admin_panel/features/authentication/screens/login/widgets/login_form.dart';
import 'package:yt_ecommerce_admin_panel/features/authentication/screens/login/widgets/login_header.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/text_strings.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo,Title & Sub-Title
              TLoginHeader(dark: dark),

              ///Form
              const TLoginForm(),

              ///   Dividers
              TFormDivider(dividerText: TTexts.orSignInWith.capitalize!,),
              const SizedBox(height: TSizes.spaceBtwSections,),

              ///   Footer
              const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}




