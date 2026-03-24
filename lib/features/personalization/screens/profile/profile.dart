import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/appbar/appbar.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/images/t_circular_image.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/texts/section_heading.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/controllers/user_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/screens/profile/widgets/change_email.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/screens/profile/widgets/change_name.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/screens/profile/widgets/change_phonenumber.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/screens/profile/widgets/change_username.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: const TAppBar(
        title: Text('Profile'),
        showBackArrow: true,
      ),

      ///  --  Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            /// Profile Picture
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Obx(() {
                    final networkImage = controller.user.value.profilePicture;
                    final image =
                        networkImage.isNotEmpty ? networkImage : TImages.user;
                    return controller.imageUploading.value
                        ? const TShimmerEffect(
                            width: 80, height: 80, radius: 80)
                        : TCircularImage(
                            image: image,
                            width: 80,
                            height: 80,
                            isNetworkImage: networkImage.isNotEmpty,
                          );
                  }),
                  TextButton(
                    onPressed: () => controller.uploadUserProfilePicture(),
                    child: const Text('Change Profile Picture'),
                  ),
                ],
              ),
            ),

            /// Details
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            ///  --  Heading Profile Info
            const TSectionHeading(
                title: 'Profile Information', showActionButton: false),
            const SizedBox(height: TSizes.spaceBtwItems),

            TProfileMenu(
                onPressed: () => Get.to(() => const ChangeName()),
                title: 'Name',
                value: controller.user.value.fullName),
            TProfileMenu(
                onPressed: () => Get.to(() => const ChangeUsername()),
                title: 'Username',
                value: controller.user.value.username),

            const SizedBox(height: TSizes.spaceBtwItems / 2),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            ///  --  Heading Personal Info
            const TSectionHeading(
                title: 'Profile Information', showActionButton: false),
            const SizedBox(height: TSizes.spaceBtwItems),

            TProfileMenu(
                onPressed: () {},
                title: 'User ID',
                value: controller.user.value.id,
                icon: Iconsax.copy),
            TProfileMenu(
                onPressed: () => Get.to(() => const ChangeEmail()),
                title: 'E-Mail',
                value: controller.user.value.email),
            TProfileMenu(
                onPressed: () => Get.to(() => const ChangePhoneNumber()),
                title: 'Phone Number',
                value: controller.user.value.phoneNumber),
            TProfileMenu(title: 'Gender', value: 'Male', onPressed: () {}),
            TProfileMenu(
              title: 'Date of Birth',
              value: '06 May 2004',
              onPressed: () {},
            ),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            Center(
              child: TextButton(
                  onPressed: () => controller.deleteAccountWarningPopup(),
                  child: const Text('Close Account',
                      style: TextStyle(color: Colors.red))),
            ),
          ],
        ),
      ),
    );
  }
}
