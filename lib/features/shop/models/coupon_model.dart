import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  String id;
  String code;
  String description;
  String discountType; // 'percentage' or 'fixed'
  double discountValue;
  double? minimumOrderAmount;
  double? maximumDiscount;
  DateTime validFrom;
  DateTime validTo;
  int usageLimit;
  int usedCount;
  bool isActive;
  List<String> applicableProducts;
  List<String> applicableCategories;
  DateTime createdAt;
  DateTime? updatedAt;

  CouponModel({
    required this.id,
    required this.code,
    required this.description,
    required this.discountType,
    required this.discountValue,
    this.minimumOrderAmount,
    this.maximumDiscount,
    required this.validFrom,
    required this.validTo,
    required this.usageLimit,
    required this.usedCount,
    required this.isActive,
    required this.applicableProducts,
    required this.applicableCategories,
    required this.createdAt,
    this.updatedAt,
  });

  static CouponModel empty() => CouponModel(
        id: '',
        code: '',
        description: '',
        discountType: 'percentage',
        discountValue: 0,
        validFrom: DateTime.now(),
        validTo: DateTime.now(),
        usageLimit: 0,
        usedCount: 0,
        isActive: true,
        applicableProducts: [],
        applicableCategories: [],
        createdAt: DateTime.now(),
      );

  /// Calculate discount amount
  double calculateDiscount(double orderAmount) {
    if (!isActive || DateTime.now().isBefore(validFrom) || DateTime.now().isAfter(validTo)) {
      return 0;
    }
    if (usedCount >= usageLimit && usageLimit > 0) {
      return 0;
    }
    if (minimumOrderAmount != null && orderAmount < minimumOrderAmount!) {
      return 0;
    }

    double discount = 0;
    if (discountType == 'percentage') {
      discount = orderAmount * (discountValue / 100);
      if (maximumDiscount != null && discount > maximumDiscount!) {
        discount = maximumDiscount!;
      }
    } else {
      discount = discountValue;
      if (discount > orderAmount) discount = orderAmount;
    }
    return discount;
  }

  bool get isExpired => DateTime.now().isAfter(validTo);
  bool get isValid => isActive && !isExpired && (usageLimit == 0 || usedCount < usageLimit);
  String get discountText => discountType == 'percentage' 
      ? '${discountValue.toInt()}% OFF' 
      : '₹${discountValue.toInt()} OFF';

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code.toUpperCase(),
    'description': description,
    'discountType': discountType,
    'discountValue': discountValue,
    'minimumOrderAmount': minimumOrderAmount,
    'maximumDiscount': maximumDiscount,
    'validFrom': Timestamp.fromDate(validFrom),
    'validTo': Timestamp.fromDate(validTo),
    'usageLimit': usageLimit,
    'usedCount': usedCount,
    'isActive': isActive,
    'applicableProducts': applicableProducts,
    'applicableCategories': applicableCategories,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
  };

  factory CouponModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CouponModel(
      id: doc.id,
      code: data['code'] ?? '',
      description: data['description'] ?? '',
      discountType: data['discountType'] ?? 'percentage',
      discountValue: (data['discountValue'] ?? 0).toDouble(),
      minimumOrderAmount: data['minimumOrderAmount']?.toDouble(),
      maximumDiscount: data['maximumDiscount']?.toDouble(),
      validFrom: (data['validFrom'] as Timestamp).toDate(),
      validTo: (data['validTo'] as Timestamp).toDate(),
      usageLimit: data['usageLimit'] ?? 0,
      usedCount: data['usedCount'] ?? 0,
      isActive: data['isActive'] ?? true,
      applicableProducts: List<String>.from(data['applicableProducts'] ?? []),
      applicableCategories: List<String>.from(data['applicableCategories'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null ? (data['updatedAt'] as Timestamp).toDate() : null,
    );
  }
}