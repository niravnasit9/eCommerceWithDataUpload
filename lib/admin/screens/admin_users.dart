import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/admin/controllers/admin_user_controller.dart';
import 'package:yt_ecommerce_admin_panel/admin/screens/user_details_screen.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_search_bar.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_stats_card.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_empty_state.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class AdminUsers extends StatelessWidget {
  const AdminUsers({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(AdminUserController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            /// Search Bar
            AdminSearchBar(
              hintText: 'Search users...',
              onChanged: controller.searchUsers,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Stats Row
            Row(
              children: [
                Expanded(
                  child: AdminStatCard(
                    title: 'Total Users',
                    value: controller.totalUsers.value.toString(),
                    icon: Iconsax.user,
                    color: TColors.primary,
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Expanded(
                  child: AdminStatCard(
                    title: 'Active Today',
                    value: controller.activeUsersToday.value.toString(),
                    icon: Iconsax.activity,
                    color: TColors.success,
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Expanded(
                  child: AdminStatCard(
                    title: 'New This Week',
                    value: controller.newUsersThisWeek.value.toString(),
                    icon: Iconsax.profile_add,
                    color: TColors.info,
                  ),
                ),
              ],
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// Users List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredUsers.isEmpty) {
                  return AdminEmptyState(
                    icon: Iconsax.user,
                    title: 'No users found',
                    subtitle: 'No users have registered yet',
                  );
                }

                return ListView.separated(
                  itemCount: controller.filteredUsers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                  itemBuilder: (_, index) {
                    final user = controller.filteredUsers[index];
                    return _buildUserCard(context, user, dark);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, Map<String, dynamic> user, bool dark) {
    final email = user['email']?.toString() ?? user['Email']?.toString() ?? 'No email';
    final name = user['name']?.toString() ?? user['Name']?.toString() ?? email.split('@')[0];
    final createdAt = user['createdAt'] ?? user['CreatedAt'];
    final isAdmin = user['isAdmin'] == true || user['IsAdmin'] == true;

    return GestureDetector(
      onTap: () => Get.to(() => UserDetailsScreen(userData: user)),
      child: Container(
        padding: const EdgeInsets.all(TSizes.sm),
        decoration: BoxDecoration(
          color: dark ? TColors.dark : TColors.white,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          border: Border.all(
            color: dark ? TColors.borderSecondary : TColors.borderPrimary,
          ),
        ),
        child: Row(
          children: [
            /// User Avatar
            CircleAvatar(
              radius: 30,
              backgroundColor: TColors.primary.withOpacity(0.1),
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                ),
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),

            /// User Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: TSizes.xs),
                  Text(
                    email,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: TSizes.xs),
                  Row(
                    children: [
                      Icon(
                        Iconsax.calendar,
                        size: 12,
                        color: dark ? TColors.grey : TColors.darkGrey,
                      ),
                      const SizedBox(width: TSizes.xs),
                      Text(
                        _formatDate(createdAt),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Actions
            Column(
              children: [
                if (isAdmin)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.sm,
                      vertical: TSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: TColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                    ),
                    child: Text(
                      'Admin',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: TColors.primary,
                          ),
                    ),
                  ),
                const SizedBox(height: TSizes.sm),
                IconButton(
                  onPressed: () => Get.to(() => UserDetailsScreen(userData: user)),
                  icon: const Icon(Iconsax.arrow_right_3, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Unknown';
    if (date is Timestamp) {
      return '${date.toDate().day}/${date.toDate().month}/${date.toDate().year}';
    }
    if (date is DateTime) {
      return '${date.day}/${date.month}/${date.year}';
    }
    return 'Unknown';
  }
}