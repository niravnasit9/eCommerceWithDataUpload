import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:yt_ecommerce_admin_panel/admin/controllers/admin_user_controller.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_delete_confirmation.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_info_row.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/order/order_details.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/order_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';
import 'package:yt_ecommerce_admin_panel/utils/popups/loaders.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.find<AdminUserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// User Profile Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: TColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        (userData['email'] as String? ?? 'U')[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: TColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    userData['name'] ?? userData['email']?.split('@')[0] ?? 'User',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: TSizes.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.sm,
                      vertical: TSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: (userData['isAdmin'] == true)
                          ? TColors.primary.withOpacity(0.1)
                          : TColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                    ),
                    child: Text(
                      userData['isAdmin'] == true ? 'Administrator' : 'Customer',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: userData['isAdmin'] == true
                                ? TColors.primary
                                : TColors.success,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// User Information
            Text(
              'User Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            Container(
              padding: const EdgeInsets.all(TSizes.md),
              decoration: BoxDecoration(
                color: dark ? TColors.dark : TColors.white,
                borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                border: Border.all(
                  color: dark ? TColors.borderSecondary : TColors.borderPrimary,
                ),
              ),
              child: Column(
                children: [
                  AdminInfoRow(
                    label: 'Email Address',
                    value: userData['email'] ?? 'Not provided',
                    icon: Iconsax.sms,
                    dark: dark,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  AdminInfoRow(
                    label: 'Phone Number',
                    value: userData['phoneNumber'] ?? 'Not provided',
                    icon: Iconsax.call,
                    dark: dark,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  AdminInfoRow(
                    label: 'User ID',
                    value: userData['id'] ?? 'Unknown',
                    icon: Iconsax.tag,
                    dark: dark,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  AdminInfoRow(
                    label: 'Joined Date',
                    value: _formatDate(userData['createdAt']),
                    icon: Iconsax.calendar,
                    dark: dark,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  AdminInfoRow(
                    label: 'Last Login',
                    value: _formatDate(userData['lastLogin']),
                    icon: Iconsax.clock,
                    dark: dark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// User Actions
            Text(
              'Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            Container(
              padding: const EdgeInsets.all(TSizes.md),
              decoration: BoxDecoration(
                color: dark ? TColors.dark : TColors.white,
                borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                border: Border.all(
                  color: dark ? TColors.borderSecondary : TColors.borderPrimary,
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Iconsax.shopping_cart),
                    title: const Text('View Orders'),
                    subtitle: const Text('See all orders placed by this user'),
                    trailing: const Icon(Iconsax.arrow_right_3),
                    onTap: () => _navigateToUserOrders(context, userData['id']),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Iconsax.message),
                    title: const Text('Send Message'),
                    subtitle: const Text('Contact this user via email'),
                    trailing: const Icon(Iconsax.arrow_right_3),
                    onTap: () => _sendEmailToUser(context, userData['email']),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      Iconsax.flag,
                      color: userData['isAdmin'] == true ? TColors.warning : TColors.primary,
                    ),
                    title: Text(
                      userData['isAdmin'] == true ? 'Remove Admin Access' : 'Make Admin',
                    ),
                    subtitle: Text(
                      userData['isAdmin'] == true
                          ? 'Remove administrator privileges'
                          : 'Grant administrator access',
                    ),
                    trailing: const Icon(Iconsax.arrow_right_3),
                    onTap: () async {
                      final confirm = await Get.dialog<bool>(
                        AlertDialog(
                          title: Text(
                            userData['isAdmin'] == true
                                ? 'Remove Admin Access?'
                                : 'Make User Admin?',
                          ),
                          content: Text(
                            userData['isAdmin'] == true
                                ? 'This user will lose all admin privileges.'
                                : 'This user will gain full admin access to the dashboard.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(result: false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Get.back(result: true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TColors.primary,
                              ),
                              child: const Text('Confirm'),
                            ),
                          ],
                        ),
                      );
                      
                      if (confirm == true) {
                        await controller.updateUserRole(
                          userData['id'],
                          !(userData['isAdmin'] ?? false),
                        );
                        Get.back();
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// Danger Zone
            Container(
              padding: const EdgeInsets.all(TSizes.md),
              decoration: BoxDecoration(
                color: TColors.error.withOpacity(0.05),
                borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                border: Border.all(color: TColors.error.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Danger Zone',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: TColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  ListTile(
                    leading: const Icon(Iconsax.trash, color: TColors.error),
                    title: const Text('Delete User Account'),
                    subtitle: const Text('This action cannot be undone'),
                    trailing: const Icon(Iconsax.arrow_right_3),
                    onTap: () => _showDeleteUserConfirmation(context, controller, userData['id']),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Never';
    if (date is Timestamp) {
      return DateFormat('dd MMM yyyy, hh:mm a').format(date.toDate());
    }
    if (date is DateTime) {
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    }
    return 'Invalid date';
  }

  void _navigateToUserOrders(BuildContext context, String userId) {
    if (userId.isEmpty) {
      TLoaders.warningSnackBar(title: 'Error', message: 'User ID not found');
      return;
    }
    Get.to(() => UserOrdersScreen(userId: userId));
  }

  void _sendEmailToUser(BuildContext context, String? email) {
    if (email == null || email.isEmpty) {
      TLoaders.warningSnackBar(title: 'Error', message: 'User email not found');
      return;
    }
    
    final emailController = TextEditingController();
    final subjectController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: const Text('Send Email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              TLoaders.successSnackBar(title: 'Email Sent', message: 'Email sent to $email');
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showDeleteUserConfirmation(BuildContext context, AdminUserController controller, String userId) {
    AdminDeleteConfirmation.show(
      context: context,
      title: 'Delete User Account',
      message: 'Are you sure you want to delete this user account? This action cannot be undone.',
      onConfirm: () async {
        Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
        try {
          await controller.deleteUserAccount(userId);
          Get.back();
          Get.back();
          TLoaders.successSnackBar(title: 'Success', message: 'User account deleted successfully');
        } catch (e) {
          Get.back();
          TLoaders.errorSnackBar(title: 'Error', message: 'Failed to delete user account: $e');
        }
      },
    );
  }
}

/// User Orders Screen
class UserOrdersScreen extends StatelessWidget {
  const UserOrdersScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Orders'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left),
        ),
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: _fetchUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.shopping_cart,
                    size: 64,
                    color: dark ? TColors.grey : TColors.darkGrey,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    'Error loading orders',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Text(
                    snapshot.error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.shopping_cart,
                    size: 64,
                    color: dark ? TColors.grey : TColors.darkGrey,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    'No orders found',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Text(
                    'This user has not placed any orders yet',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
            itemBuilder: (_, index) {
              final order = orders[index];
              return _buildOrderCard(context, order, dark);
            },
          );
        },
      ),
    );
  }

  Future<List<OrderModel>> _fetchUserOrders() async {
    try {
      final ordersSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Orders')
          .orderBy('orderDate', descending: true)
          .get();

      return ordersSnapshot.docs
          .map((doc) => OrderModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching user orders: $e');
      return [];
    }
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order, bool dark) {
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: dark ? TColors.dark : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        border: Border.all(
          color: dark ? TColors.borderSecondary : TColors.borderPrimary,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.sm,
                  vertical: TSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                ),
                child: Text(
                  order.orderStatusText,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _getStatusColor(order.status),
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            children: [
              const Icon(Iconsax.calendar, size: 14),
              const SizedBox(width: TSizes.xs),
              Text(
                order.formattedOrderDate,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              const Icon(Iconsax.money, size: 14),
              const SizedBox(width: TSizes.xs),
              Text(
                '₹${order.totalAmount.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TColors.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            children: [
              const Icon(Iconsax.shopping_bag, size: 14),
              const SizedBox(width: TSizes.xs),
              Text(
                '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Get.to(() => OrderDetailsScreen(order: order)),
                child: const Text('View Details'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return TColors.warning;
      case OrderStatus.confirmed:
        return TColors.info;
      case OrderStatus.shipped:
        return TColors.primary;
      case OrderStatus.outForDelivery:
        return TColors.secondary;
      case OrderStatus.delivered:
        return TColors.success;
      case OrderStatus.cancelled:
        return TColors.error;
      default:
        return TColors.primary;
    }
  }
}