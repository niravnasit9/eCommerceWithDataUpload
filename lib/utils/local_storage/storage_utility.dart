import 'package:get_storage/get_storage.dart';

class TLocalStorage {
  static final TLocalStorage _instance = TLocalStorage._internal();
  late final GetStorage _storage;
  bool _isInitialized = false;
  String _currentUserId = '';
  
  TLocalStorage._internal();
  
  static TLocalStorage get instance {
    return _instance;
  }
  
  /// Initialize with default storage
  Future<void> initialize() async {
    if (!_isInitialized) {
      await GetStorage.init();
      _storage = GetStorage();
      _isInitialized = true;
      print('✅ TLocalStorage initialized successfully');
    }
  }
  
  /// Initialize with user-specific storage (for cart persistence per user)
  Future<void> initializeForUser(String userId) async {
    await initialize();
    _currentUserId = userId;
    print('✅ TLocalStorage initialized for user: $userId');
  }
  
  bool get isInitialized => _isInitialized;
  
  /// Get user-specific key
  String _getUserKey(String key) {
    if (_currentUserId.isNotEmpty) {
      return '${_currentUserId}_$key';
    }
    return key;
  }
  
  void writeData(String key, dynamic value) {
    if (!_isInitialized) {
      print('⚠️ Storage not initialized, cannot write: $key');
      return;
    }
    final userKey = _getUserKey(key);
    _storage.write(userKey, value);
    print('💾 Data saved: $userKey -> ${value is List ? '${value.length} items' : value}');
  }
  
  dynamic readData(String key) {
    if (!_isInitialized) {
      print('⚠️ Storage not initialized, cannot read: $key');
      return null;
    }
    final userKey = _getUserKey(key);
    final value = _storage.read(userKey);
    print('📖 Data read: $userKey -> ${value != null ? (value is List ? '${value.length} items' : 'found') : 'not found'}');
    return value;
  }
  
  void removeData(String key) {
    if (!_isInitialized) return;
    final userKey = _getUserKey(key);
    _storage.remove(userKey);
    print('🗑️ Data removed: $userKey');
  }
  
  void clearAll() {
    if (!_isInitialized) return;
    _storage.erase();
    print('🗑️ All storage cleared');
  }
  
  /// Clear user-specific data
  void clearUserData() {
    if (!_isInitialized) return;
    removeData('cartItems');
    print('🗑️ User data cleared for: $_currentUserId');
  }
}