import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/models/addres_model.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/cart_item_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class OrderModel {
  final String id;
  final String userId;
  final OrderStatus status;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;

  // ✅ NEW FIELDS (important)
  final String? paymentId;
  final String? paymentStatus;

  final AddressModel? address;
  final DateTime? deliveryDate;
  final List<CartItemModel> items;

  OrderModel({
    required this.id,
    this.userId = '',
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    this.paymentMethod = 'Paypal',
    this.paymentId,
    this.paymentStatus,
    this.address,
    this.deliveryDate,
  });

  /// ------------------ GETTERS ------------------

  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate => deliveryDate != null
      ? THelperFunctions.getFormattedDate(deliveryDate!)
      : '';

  String get orderStatusText {
    switch (status) {
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.shipped:
        return 'Shipment on the way';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.pending:
      default:
        return 'Processing';
    }
  }

  /// ------------------ TO JSON ------------------

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.name, // ✅ cleaner than toString()
      'totalAmount': totalAmount,
      'orderDate': Timestamp.fromDate(orderDate),
      'paymentMethod': paymentMethod,

      // ✅ NEW
      'paymentId': paymentId,
      'paymentStatus': paymentStatus,

      'address': address?.toJson(),
      'deliveryDate':
          deliveryDate != null ? Timestamp.fromDate(deliveryDate!) : null,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  /// ------------------ FROM SNAPSHOT ------------------

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return OrderModel(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',

      status: OrderStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => OrderStatus.pending,
      ),

      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,

      orderDate: (data['orderDate'] as Timestamp).toDate(),

      paymentMethod: data['paymentMethod'] ?? 'Unknown',

      // ✅ NEW
      paymentId: data['paymentId'],
      paymentStatus: data['paymentStatus'],

      address: data['address'] != null
          ? AddressModel.fromMap(data['address'])
          : null,

      deliveryDate: data['deliveryDate'] != null
          ? (data['deliveryDate'] as Timestamp).toDate()
          : null,

      items: (data['items'] as List<dynamic>? ?? [])
          .map((itemData) =>
              CartItemModel.fromJson(itemData as Map<String, dynamic>))
          .toList(),
    );
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    OrderStatus? status,
    double? totalAmount,
    DateTime? orderDate,
    String? paymentMethod,
    String? paymentId,
    String? paymentStatus,
    AddressModel? address,
    DateTime? deliveryDate,
    List<CartItemModel>? items,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      orderDate: orderDate ?? this.orderDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentId: paymentId ?? this.paymentId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      address: address ?? this.address,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      items: items ?? this.items,
    );
  }
}
