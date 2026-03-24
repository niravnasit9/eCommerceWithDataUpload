import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/controllers/address_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/models/addres_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class TSingleAddress extends StatelessWidget {
  const TSingleAddress({
    super.key,
    required this.address,
    required this.onTap,
  });

  final AddressModel address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
        Obx(() {
          final selectedAddressId = controller.selectedAddress.value.id;
          final selectedAddress = selectedAddressId == address.id;
          return InkWell(
            onTap: onTap,
            child: TRoundedContainer(
              width: double.infinity,
              padding: const EdgeInsets.all(TSizes.md),
              showBorder: true,
              backgroundColor: selectedAddress
                  ? TColors.primary.withOpacity(0.5)
                  : Colors.transparent,
              borderColor: selectedAddress
                  ? Colors.transparent
                  : dark
                      ? TColors.darkerGrey
                      : TColors.grey,
              margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
              child: Stack(
                children: [
                  Positioned(
                    right: 5,
                    top: 3,
                    child: Icon(selectedAddress ? Iconsax.tick_circle5 : null,
                        color: selectedAddress
                            ? dark
                                ? TColors.light
                                : TColors.dark
                            : null),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: TSizes.md),
                      Text(address.phoneNumber,
                          style: const TextStyle(fontWeight: FontWeight.w400),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: TSizes.md),
                      Text(address.toString(), softWrap: true,style: const TextStyle(fontWeight: FontWeight.w400),),
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
