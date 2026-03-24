import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/texts/section_heading.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/controllers/address_controller.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart'; // Ensure correct import

class TBillingAddressSection extends StatelessWidget {
  const TBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final addressController = AddressController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TSectionHeading(
          title: 'Shipping Address',
          buttonTitle: 'Change',
          onPressed: () => addressController.selectNewAddressPopup(context),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Obx(() {
          final address = addressController.selectedAddress.value;

          if (address.id.isEmpty) {
            return GestureDetector(
              onTap: () => addressController.selectNewAddressPopup(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: dark ? Colors.grey.shade900 : Colors.grey.shade100,
                  border: Border.all(
                      color: dark ? Colors.grey.shade700 : Colors.grey.shade300),
                ),
                child: Text(
                  'Select Address',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            );
          }

          final fullAddress =
              "${address.street}, ${address.city}, ${address.state}, "
              "${address.postalCode}, ${address.country}";

          return Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: dark ? Colors.grey.shade900 : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: dark ? Colors.grey.shade700 : Colors.grey.shade300,
              ),
              boxShadow: [
                if (!dark)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  address.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // Phone Number
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 18,
                      color: dark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      address.phoneNumber,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Full Address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 18,
                      color: dark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        fullAddress,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
