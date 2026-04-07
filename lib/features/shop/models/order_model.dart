import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/models/addres_model.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/cart_item_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class OrderModel {
  final String docId;      // Firestore document ID (for updates/deletes)
  final String id;         // Custom order ID (ORD-xxxxx) for display
  final String userId;
  final OrderStatus status;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;

  final String? paymentId;
  final String? paymentStatus;

  final AddressModel? address;
  final DateTime? deliveryDate;
  final List<CartItemModel> items;

  OrderModel({
    this.docId = '',  // Default empty for new orders
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
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.refunded:
        return 'Refunded';
      // default:
      //   return 'Pending';
    }
  }

  /// ------------------ TO JSON ------------------

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.name,
      'totalAmount': totalAmount,
      'orderDate': Timestamp.fromDate(orderDate),
      'paymentMethod': paymentMethod,
      'paymentId': paymentId,
      'paymentStatus': paymentStatus,
      'address': address?.toJson(),
      'deliveryDate': deliveryDate != null ? Timestamp.fromDate(deliveryDate!) : null,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  /// ------------------ FROM SNAPSHOT ------------------

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    // Get status string from Firebase
    String statusString = data['status'] ?? 'pending';
    
    // Convert string to enum
    OrderStatus orderStatus;
    switch (statusString.toLowerCase()) {
      case 'pending':
        orderStatus = OrderStatus.pending;
        break;
      case 'processing':
        orderStatus = OrderStatus.processing;
        break;
      case 'confirmed':
        orderStatus = OrderStatus.confirmed;
        break;
      case 'shipped':
        orderStatus = OrderStatus.shipped;
        break;
      case 'out for delivery':
      case 'outfordelivery':
      case 'out_for_delivery':
        orderStatus = OrderStatus.outForDelivery;
        break;
      case 'delivered':
        orderStatus = OrderStatus.delivered;
        break;
      case 'cancelled':
        orderStatus = OrderStatus.cancelled;
        break;
      case 'refunded':
        orderStatus = OrderStatus.refunded;
        break;
      default:
        orderStatus = OrderStatus.pending;
    }

    return OrderModel(
      docId: snapshot.id,  // ✅ Firestore document ID
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      status: orderStatus,
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      paymentMethod: data['paymentMethod'] ?? 'Unknown',
      paymentId: data['paymentId'],
      paymentStatus: data['paymentStatus'],
      address: data['address'] != null ? AddressModel.fromMap(data['address']) : null,
      deliveryDate: data['deliveryDate'] != null ? (data['deliveryDate'] as Timestamp).toDate() : null,
      items: (data['items'] as List<dynamic>? ?? [])
          .map((itemData) => CartItemModel.fromJson(itemData as Map<String, dynamic>))
          .toList(),
    );
  }

  OrderModel copyWith({
    String? docId,
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
      docId: docId ?? this.docId,
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