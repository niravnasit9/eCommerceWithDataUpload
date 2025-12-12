import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/loaders/animation_loader.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/order_controller.dart';
import 'package:yt_ecommerce_admin_panel/navigation_menu.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/cloud_helper_functions.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class TOrderListItems extends StatelessWidget {
  const TOrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(OrderController());
    return FutureBuilder(
        future: controller.fetchUserOrders(),
        builder: (_, snapshot) {
          final emptyWidget = TAnimationLoaderWidget(
            text: 'Whoops! No Orders Yet',
            animation: TImages.orderCompletedAnimation,
            showAction: true,
            actionText: 'Let\'s fill it.',
            onActionPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.offAll(() => const NavigationMenu());
              });
            },
          );

          final response = TCloudHelperFunctions.checkMultiRecordState(
              snapshot: snapshot, nothingFound: emptyWidget);
          if (response != null) return response;

          final orders = snapshot.data;
          return ListView.separated(
              shrinkWrap: true,
              itemCount: orders!.length,
              separatorBuilder: (_, Index) => const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
              itemBuilder: (_, index) {
                final order = orders[index];

                return TRoundedContainer(
                  showBorder: true,
                  padding: const EdgeInsets.all(TSizes.md),
                  backgroundColor: dark ? TColors.dark : TColors.light,
                  child: Column(
                    children: [
                      /// Row 1
                      Row(
                        children: [
                          /// 1 Icon
                          const Icon(Iconsax.ship),
                          const SizedBox(width: TSizes.spaceBtwItems / 2),

                          /// 2 Status & Date
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.orderStatusText,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .apply(
                                          color: TColors.primary,
                                          fontSizeDelta: 1),
                                ),
                                Text(order.formattedOrderDate,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                              ],
                            ),
                          ),

                          /// 3 Icon
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Iconsax.arrow_right_34,
                                size: TSizes.iconSm),
                          ),
                        ],
                      ),

                      const SizedBox(height: TSizes.spaceBtwItems),

                      /// Row 2
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                /// 1 Icon
                                const Icon(Iconsax.tag),
                                const SizedBox(width: TSizes.spaceBtwItems / 2),

                                /// 2 Status & Date
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'order',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                      Text(order.id,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                /// 1 Icon
                                const Icon(Iconsax.calendar),
                                const SizedBox(width: TSizes.spaceBtwItems / 2),

                                /// 2 Status & Date
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Shipping Date',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                      Text(order.formattedDeliveryDate,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
        });
  }
}
