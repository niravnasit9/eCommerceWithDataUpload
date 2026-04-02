import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/admin/screens/admin_dashboard.dart';
import 'package:yt_ecommerce_admin_panel/admin/screens/admin_products.dart';
import 'package:yt_ecommerce_admin_panel/admin/screens/admin_brands.dart';
import 'package:yt_ecommerce_admin_panel/admin/screens/admin_banners.dart';
import 'package:yt_ecommerce_admin_panel/admin/screens/admin_orders.dart';
import 'package:yt_ecommerce_admin_panel/admin/screens/admin_users.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_drawer.dart';
// import 'package:yt_ecommerce_admin_panel/features/shop/screens/load_data/load_data.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class AdminNavigationMenu extends StatefulWidget {
  const AdminNavigationMenu({super.key});

  @override
  State<AdminNavigationMenu> createState() => _AdminNavigationMenuState();
}

class _AdminNavigationMenuState extends State<AdminNavigationMenu> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = const [
    AdminDashboard(),
    AdminProducts(),
    AdminBrands(),
    AdminBanners(),
    AdminOrders(),
    AdminUsers(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Products',
    'Brands',
    'Banners',
    'Orders',
    'Users',
  ];

  final List<IconData> _icons = [
    Iconsax.chart_21,
    Iconsax.shop,
    Iconsax.tag,
    Iconsax.image,
    Iconsax.shopping_cart,
    Iconsax.user,
  ];

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AdminDrawer(),
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        leading: IconButton(
          icon: Icon(
            Iconsax.menu,
            color: dark ? TColors.white : TColors.black, // ✅ Fix icon color for dark mode
            size: 24,
          ),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Iconsax.notification,
              color: dark ? TColors.white : TColors.black,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Iconsax.refresh,
              color: dark ? TColors.white : TColors.black,
            ),
            onPressed: () {
              setState(() {});
            },
          ),
          // IconButton(
          //   icon: Icon(
          //     Iconsax.data,
          //     color: dark ? TColors.white : TColors.black,
          //   ),
          //   onPressed: () {
          //     Get.to(() => const LoadData());
          //   },
          //   tooltip: 'Upload Data',
          // ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: TColors.primary,
        unselectedItemColor: dark ? TColors.grey : TColors.darkGrey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: [
          BottomNavigationBarItem(
            icon: Icon(_icons[0]),
            label: _titles[0],
          ),
          BottomNavigationBarItem(
            icon: Icon(_icons[1]),
            label: _titles[1],
          ),
          BottomNavigationBarItem(
            icon: Icon(_icons[2]),
            label: _titles[2],
          ),
          BottomNavigationBarItem(
            icon: Icon(_icons[3]),
            label: _titles[3],
          ),
          BottomNavigationBarItem(
            icon: Icon(_icons[4]),
            label: _titles[4],
          ),
          BottomNavigationBarItem(
            icon: Icon(_icons[5]),
            label: _titles[5],
          ),
        ],
      ),
    );
  }
}