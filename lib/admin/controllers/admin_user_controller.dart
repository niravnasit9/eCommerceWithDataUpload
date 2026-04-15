import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/utils/popups/loaders.dart';

class AdminUserController extends GetxController {
  static AdminUserController get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final isLoading = true.obs; // Start with true to show loader
  final RxList<Map<String, dynamic>> allUsers = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredUsers = <Map<String, dynamic>>[].obs;

  final totalUsers = 0.obs;
  final activeUsersToday = 0.obs;
  final newUsersThisWeek = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers(); // Fetch immediately on init
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      print('👥 Fetching users...');

      final snapshot = await _db.collection('Users').get();
      
      allUsers.value = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'email': data['email'] ?? data['Email'] ?? '',
          'name': data['name'] ?? data['Name'] ?? data['displayName'] ?? '',
          'phoneNumber': data['phoneNumber'] ?? data['PhoneNumber'] ?? '',
          'createdAt': data['createdAt'] ?? data['CreatedAt'],
          'lastLogin': data['lastLogin'] ?? data['LastLogin'],
          'isAdmin': data['isAdmin'] ?? data['IsAdmin'] ?? false,
        };
      }).toList();
      
      filteredUsers.value = allUsers;

      // Calculate stats
      totalUsers.value = allUsers.length;
      
      // Calculate active users today
      final today = DateTime.now();
      activeUsersToday.value = allUsers.where((user) {
        final lastLogin = user['lastLogin'];
        if (lastLogin == null) return false;
        if (lastLogin is Timestamp) {
          final loginDate = lastLogin.toDate();
          return loginDate.day == today.day &&
              loginDate.month == today.month &&
              loginDate.year == today.year;
        }
        return false;
      }).length;

      // Calculate new users this week
      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      newUsersThisWeek.value = allUsers.where((user) {
        final createdAt = user['createdAt'];
        if (createdAt == null) return false;
        if (createdAt is Timestamp) {
          return createdAt.toDate().isAfter(weekAgo);
        }
        return false;
      }).length;

      print('✅ Total Users: ${totalUsers.value}');
      print('✅ Active Today: ${activeUsersToday.value}');
      print('✅ New This Week: ${newUsersThisWeek.value}');

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('❌ Error fetching users: $e');
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to fetch users: $e');
    }
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.value = allUsers;
    } else {
      filteredUsers.value = allUsers.where((user) {
        final email = user['email']?.toString().toLowerCase() ?? '';
        final name = user['name']?.toString().toLowerCase() ?? '';
        return email.contains(query.toLowerCase()) ||
            name.contains(query.toLowerCase());
      }).toList();
    }
  }

  Future<void> updateUserRole(String userId, bool isAdmin) async {
    try {
      await _db.collection('Users').doc(userId).update({
        'isAdmin': isAdmin,
        'updatedAt': DateTime.now(),
      });
      await fetchUsers();
      TLoaders.successSnackBar(title: 'Success', message: 'User role updated successfully');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to update user role: $e');
    }
  }

  Future<void> deleteUserAccount(String userId) async {
    try {
      // Delete user's addresses
      final addressesSnapshot = await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .get();
      
      for (var doc in addressesSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Delete user's orders
      final ordersSnapshot = await _db
          .collection('Users')
          .doc(userId)
          .collection('Orders')
          .get();
      
      for (var doc in ordersSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Delete user document
      await _db.collection('Users').doc(userId).delete();
      
      await fetchUsers();
      TLoaders.successSnackBar(title: 'Success', message: 'User account deleted successfully');
    } catch (e) {
      throw 'Failed to delete user account: $e';
    }
  }
}