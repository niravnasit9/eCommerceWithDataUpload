import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/order_model.dart';

class AdminController extends GetxController {
  static AdminController get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final isLoading = false.obs;
  final isLoadingOrders = false.obs;

  final totalProducts = 0.obs;
  final totalOrders = 0.obs;
  final totalUsers = 0.obs;
  final totalRevenue = 0.obs;

  // Trend values (percentage changes)
  final productGrowth = '+0%'.obs;
  final orderGrowth = '+0%'.obs;
  final userGrowth = '+0%'.obs;
  final revenueGrowth = '+0%'.obs;

  final RxList<OrderModel> recentOrders = <OrderModel>[].obs;

  // Previous day's data for trend calculation
  int previousTotalProducts = 0;
  int previousTotalOrders = 0;
  int previousTotalUsers = 0;
  double previousTotalRevenue = 0;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
    fetchRecentOrders();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      print('📊 Fetching dashboard data...');

      // Fetch today's data
      final productsSnapshot = await _db.collection('Products').get();
      final currentTotalProducts = productsSnapshot.docs.length;
      totalProducts.value = currentTotalProducts;

      // Fetch orders from all users
      final usersSnapshot = await _db.collection('Users').get();
      int currentTotalOrders = 0;
      double currentTotalRevenue = 0;
      
      for (var userDoc in usersSnapshot.docs) {
        final ordersSnapshot = await _db
            .collection('Users')
            .doc(userDoc.id)
            .collection('Orders')
            .get();
        
        currentTotalOrders += ordersSnapshot.docs.length;
        
        for (var orderDoc in ordersSnapshot.docs) {
          final orderData = orderDoc.data();
          currentTotalRevenue += (orderData['totalAmount'] ?? 0).toDouble();
        }
      }
      
      totalOrders.value = currentTotalOrders;
      totalRevenue.value = currentTotalRevenue.toInt();

      // Fetch total users
      totalUsers.value = usersSnapshot.docs.length;

      // Calculate trends (compare with previous day)
      _calculateTrends(
        currentProducts: currentTotalProducts,
        currentOrders: currentTotalOrders,
        currentUsers: totalUsers.value,
        currentRevenue: currentTotalRevenue,
      );

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('❌ Error fetching dashboard data: $e');
    }
  }

  void _calculateTrends({
    required int currentProducts,
    required int currentOrders,
    required int currentUsers,
    required double currentRevenue,
  }) {
    // Calculate product growth
    if (previousTotalProducts > 0) {
      final productPercent = ((currentProducts - previousTotalProducts) / previousTotalProducts * 100);
      productGrowth.value = productPercent >= 0 
          ? '+${productPercent.toStringAsFixed(0)}%' 
          : '${productPercent.toStringAsFixed(0)}%';
    } else {
      productGrowth.value = currentProducts > 0 ? '+100%' : '0%';
    }

    // Calculate order growth
    if (previousTotalOrders > 0) {
      final orderPercent = ((currentOrders - previousTotalOrders) / previousTotalOrders * 100);
      orderGrowth.value = orderPercent >= 0 
          ? '+${orderPercent.toStringAsFixed(0)}%' 
          : '${orderPercent.toStringAsFixed(0)}%';
    } else {
      orderGrowth.value = currentOrders > 0 ? '+100%' : '0%';
    }

    // Calculate user growth
    if (previousTotalUsers > 0) {
      final userPercent = ((currentUsers - previousTotalUsers) / previousTotalUsers * 100);
      userGrowth.value = userPercent >= 0 
          ? '+${userPercent.toStringAsFixed(0)}%' 
          : '${userPercent.toStringAsFixed(0)}%';
    } else {
      userGrowth.value = currentUsers > 0 ? '+100%' : '0%';
    }

    // Calculate revenue growth
    if (previousTotalRevenue > 0) {
      final revenuePercent = ((currentRevenue - previousTotalRevenue) / previousTotalRevenue * 100);
      revenueGrowth.value = revenuePercent >= 0 
          ? '+${revenuePercent.toStringAsFixed(0)}%' 
          : '${revenuePercent.toStringAsFixed(0)}%';
    } else {
      revenueGrowth.value = currentRevenue > 0 ? '+100%' : '0%';
    }

    // Update previous values for next calculation
    previousTotalProducts = currentProducts;
    previousTotalOrders = currentOrders;
    previousTotalUsers = currentUsers;
    previousTotalRevenue = currentRevenue;
  }

  Future<void> fetchRecentOrders() async {
    try {
      isLoadingOrders.value = true;
      
      List<OrderModel> allOrders = [];
      
      final usersSnapshot = await _db.collection('Users').get();
      
      for (var userDoc in usersSnapshot.docs) {
        final ordersSnapshot = await _db
            .collection('Users')
            .doc(userDoc.id)
            .collection('Orders')
            .orderBy('orderDate', descending: true)
            .limit(5)
            .get();
        
        for (var orderDoc in ordersSnapshot.docs) {
          allOrders.add(OrderModel.fromSnapshot(orderDoc));
        }
      }
      
      allOrders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      recentOrders.value = allOrders.take(5).toList();

      isLoadingOrders.value = false;
    } catch (e) {
      isLoadingOrders.value = false;
      print('Error fetching recent orders: $e');
    }
  }
}